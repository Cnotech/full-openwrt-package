#define _GNU_SOURCE

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>
#include <signal.h>
#include <semaphore.h>
#include <net/if.h>

#include "alsa.h"
#include "xPL.h"

#include "log.h"
#include "code_ir_rf.h"
#include "xpld.h"
#include "args.h"

#define VERSION "1.0"

typedef struct {
	unsigned int rate, channels, bps;
	uint8_t	h, l;
	unsigned int bpf;
} RF_FRAME_CTX;

/* global/static variables */
static const char pcm_device[] = "default";

sem_t		sem_sound;

size_t rf_write_frame(void *ctx, uint8_t *buffer, size_t len, uint16_t time_ms)
{
	RF_FRAME_CTX	*rfc = ctx;
	uint32_t	units;
	uint8_t		*p;
	size_t		bytes;

	units  = time_ms;
	units *= rfc->rate;
	units += 1000000 >> 1;	// For rounding
	units /= 1000000;

	bytes = units * rfc->bpf;
	if (len < bytes)
		return 0;

	for (p = buffer; p < buffer + bytes;) {
		*(p++) = rfc->l;
		*(p++) = rfc->h;
		*(p++) = rfc->l;
		*(p++) = rfc->h;
	}

	rfc->h = ~(rfc->h);
	rfc->l = ~(rfc->l);
	return bytes;
}

int play_rf_code(const char* card, const CODEDEF *code, uint8_t *cmd, uint8_t cmd_len, uint8_t repeat)
{
	int			rc, retval = -2;
	uint8_t			*buffer = 0;
	size_t			len, r;
	snd_pcm_t		*handle; 
	RF_FRAME_CTX		rfc = { 48000, 2, 16, 0x80, 0x00 };

	sem_wait(&sem_sound);
	alsa_max_volume(pcm_device);

	/* Initialize audio first to get the final playback rate */
	if (alsa_init_playback(card, &rfc.rate, rfc.channels, rfc.bps, &handle)) {
		retval = -1;
		goto cleanup;
	}

	/* Initialize buffer for 125ms playback should be sufficient */
	rfc.bpf = rfc.channels * (rfc.bps >> 3);
	len = (rfc.rate * rfc.bpf) >> 3;
	buffer = malloc(len);

	len = ir_rf_generate_pulses(code, cmd, cmd_len, buffer, len, rf_write_frame, &rfc);
	len /= rfc.bpf;

	for (r = 0; r < repeat; r++) {
		rc = snd_pcm_writei(handle, buffer, len);
		if (rc < 0)
			_log(LOG_ERR, "Write %s\n", snd_strerror(rc));
	}

	snd_pcm_drain(handle);
	snd_pcm_close(handle);
	retval = 0;

cleanup:
	if (buffer)
		free(buffer);

	sem_post(&sem_sound);
	return retval;
}

char* rf_get_var(void *ctx, char *name)
{
	xPL_MessagePtr msg = ctx;

	if (0 == strcmp("id", name))
		return xPL_getTargetInstanceID(msg);

	return xPL_getMessageNamedValue(msg, name);
}

void rf_send_code(const CODEDEF *code, xPL_MessagePtr msg)
{
	char			buf[256];
	int			buf_pos;
	xPL_NameValueList	*body;
	xPL_NameValuePair	**nv;
	uint8_t			cmd[32];
	int			repeat, i;
	char			*repeat_str;

	if (!ir_rf_cmd_from_vars(code, rf_get_var, msg, cmd, sizeof(cmd)))
		return;

	repeat = 5;
	if (code->repeat)
		repeat = code->repeat;

	repeat_str = xPL_getMessageNamedValue(msg, "repeat");
	if (repeat_str)
		repeat = strtol(repeat_str, 0, 0);

	play_rf_code(pcm_device, code, cmd, sizeof(cmd), repeat);

	buf_pos = snprintf(buf, sizeof(buf), "RF 433mhz %s-%s.%s -> %s-%s.%s : %s.%s {",
		xPL_getSourceVendor(msg), xPL_getSourceDeviceID(msg), xPL_getSourceInstanceID(msg),
		xPL_getTargetVendor(msg), xPL_getTargetDeviceID(msg), xPL_getTargetInstanceID(msg),
		xPL_getSchemaClass(msg), xPL_getSchemaType(msg));

	body = xPL_getMessageBody(msg);
	for (i = 0, nv = body->namedValues; i < body->namedValueCount; i++)
		buf_pos += snprintf(buf + buf_pos, sizeof(buf) - buf_pos, " %s=%s", nv[i]->itemName, nv[i]->itemValue);

	buf_pos += snprintf(buf + buf_pos, sizeof(buf) - buf_pos, " } => code %s, (repeat=%d) ",
		code->name, repeat);
	for (i = 0; i < (code->bits + 7) >> 3; i++)
		buf_pos += snprintf(buf + buf_pos, sizeof(buf) - buf_pos, "%02x", cmd[i]);
	_log(LOG_NOTICE, buf);
}

void xpl433mhz_msg_handler(xPL_MessagePtr msg, xPL_ObjectPtr data)
{
	char	*vendor, *device, *msg_class, *msg_type;
	CODEDEF	*code;
	int		found = 0;
	char	*my_vendor_id = data;

	
	vendor = xPL_getTargetVendor(msg);
	if (vendor == 0 || strcmp(vendor, my_vendor_id))
		return;

	device = xPL_getTargetDeviceID(msg);
	if (device == 0)
		return;

	msg_class = xPL_getSchemaClass(msg);
	if (msg_class == 0 || strcmp(msg_class, "control"))
		return;

	msg_type = xPL_getSchemaType(msg);
	if (msg_type == 0 || strcmp(msg_type, "basic"))
		return;

	for (code = codes.entries; code < codes.entries + codes.count; code++) {
		if (strcmp(device, code->name))
			continue;

		found = 1;
		rf_send_code(code, msg);
	}

	if (!found)
		_log(LOG_ERR, "Unknown code %s", device);
}

int xpl433mhz_startup()
{
	sem_init(&sem_sound, 0, 1);
	return 0;
}
