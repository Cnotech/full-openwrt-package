config 'CONFIG_VDI_IMAGES=y'
config 'CONFIG_VMDK_IMAGES=y'

class 'standard'

packages {
	'kmod-3c59x',
	'kmod-8139cp',
	'kmod-8139too',
	'kmod-e100',
	'kmod-e1000',
	'kmod-e1000e',
	'kmod-forcedeth',
	'kmod-igb',
	'kmod-natsemi',
	'kmod-ne2k-pci',
	'kmod-pcnet32',
	'kmod-r8169',
	'kmod-sis900',
	'kmod-sky2',
	'kmod-tg3',
	'kmod-tulip',
	'kmod-via-rhine',
	'kmod-via-velocity',
	'kmod-ath9k',
	'kmod-gpio-button-hotplug',
	'kmod-gpio-nct5104d',
	'kmod-hwmon-core',
	'kmod-leds-gpio',
	'kmod-leds-apu2',
	'kmod-sp5100_tco',
	'kmod-usb-core',
	'kmod-usb-ohci',
	'kmod-usb2',
	'kmod-usb3',
	'kmod-usb-serial',
	'kmod-ath10k',
	'ath10k-firmware-qca9887',
	'ath10k-firmware-qca9888',
	'ath10k-firmware-qca988x',
	'ath10k-firmware-qca9984',
	'kmod-mt76x0e',
	'kmod-mt76x2',
	'kmod-mt7603',
	'kmod-mt7615e',
}