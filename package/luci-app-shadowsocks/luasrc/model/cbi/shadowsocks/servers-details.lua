-- Copyright (C) 2016-2017 Jian Chang <aa65535@live.com>
-- Copyright (C) 2017 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocks = "shadowsocks"
local sid = arg[1]
local encrypt_methods = {
	"none",
	"table",
	"rc4",
	"rc4-md5",
	"rc4-md5-6",
	"aes-128-cfb",
	"aes-192-cfb",
	"aes-256-cfb",
	"aes-128-ctr",
	"aes-192-ctr",
	"aes-256-ctr",
	"aes-128-gcm",
	"aes-192-gcm",
	"aes-256-gcm",
	"camellia-128-cfb",
	"camellia-192-cfb",
	"camellia-256-cfb",
	"bf-cfb",
	"cast5-cfb",
	"des-cfb",
	"idea-cfb",
	"rc2-cfb",
	"seed-cfb",
	"salsa20",
	"chacha20",
	"chacha20-ietf",
	"chacha20-ietf-poly1305",
	"xchacha20-ietf-poly1305",
}

local protocols = {
	"origin",
	"auth_sha1_v4",
	"auth_aes128_md5",
	"auth_aes128_sha1",
	"auth_chain_a",
	"auth_chain_b"
}
local obfs_list = {
	"plain",
	"http_simple",
	"http_post",
	"tls1.2_ticket_auth"
}

m = Map(shadowsocks, "%s - %s" %{translate("ShadowSocks"), translate("Edit Server")})
m.redirect = luci.dispatcher.build_url("admin/services/shadowsocks/servers")

if m.uci:get(shadowsocks, sid) ~= "server" then
	luci.http.redirect(m.redirect)
	return
end

-- [[ Edit Server ]]--
s = m:section(NamedSection, sid, "server")
s.anonymous = true
s.addremove = false

o = s:option(Value, "alias", translate("Alias(optional)"))

o = s:option(Flag, "ssr_server", translate("SSR Server"))

o = s:option(Value, "server_addr", translate("Server Address"))
o.datatype = "ipaddr"
o.rmempty = false

o = s:option(Value, "server_port", translate("Server Port"))
o.datatype = "port"
o.rmempty = false

o = s:option(Flag, "fast_open", translate("TCP Fast Open"))
o:depends("ssr_server", 0)

o = s:option(Value, "timeout", translate("Connection Timeout"))
o.datatype = "uinteger"
o.placeholder = 60

o = s:option(Value, "password", translate("Password"))
o.password = true
o.rmempty = false

o = s:option(Value, "key", translate("Directly Key"))
o:depends("ssr_server", 0)

o = s:option(ListValue, "encrypt_method", translate("Encrypt Method"))
for _, v in ipairs(encrypt_methods) do o:value(v) end
o.rmempty = false

o = s:option(Value, "plugin", translate("Plugin Name"))
o:depends("ssr_server", 0)
o.placeholder = "eg: obfs-local"

o = s:option(Value, "plugin_opts", translate("Plugin Arguments"))
o.placeholder = "eg: obfs=http;obfs-host=www.bing.com"
o:depends("ssr_server", 0)

o = s:option(ListValue, "protocol", translate("Protocol"))
o:depends("ssr_server", 1)
for _, v in ipairs(protocols) do o:value(v) end

o = s:option(Value, "protocol_param", translate("Protocol Param"))
o:depends("ssr_server", 1)

o = s:option(ListValue, "obfs", translate("OBFS"))
o:depends("ssr_server", 1)
for _, v in ipairs(obfs_list) do o:value(v) end

o = s:option(Value, "obfs_param", translate("OBFS Param"))
o:depends("ssr_server", 1)

return m
