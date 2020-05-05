-- Copyright (C) 2014-2017 Jian Chang <aa65535@live.com>
-- Copyright (C) 2017 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocks = "shadowsocks"
local uci = require "luci.model.uci".cursor()
local servers = {}

uci:foreach(shadowsocks, "server", function(s)
	if s.server_addr and s.server_port then
		servers[#servers+1] = {
			name = s[".name"],
			alias = s.alias or "%s:%s" %{s.server_addr, s.server_port}
		}
	end
end)

m = Map(shadowsocks, "%s - %s" %{translate("ShadowSocks"), translate("General Settings")})
m:append(Template("shadowsocks/status"))

s = m:section(TypedSection, "general", translate("Global Settings"))
s.addremove = false
s.anonymous = true

o = s:option(Value, "startup_delay", translate("Startup Delay"))
o:value(0, translate("Not enabled"))
for _, v in ipairs({5, 10, 15, 25, 40}) do
	o:value(v, translatef("%u seconds", v))
end
o.datatype = "uinteger"
o.default = 0

s = m:section(TypedSection, "proxy", translate("Proxy List"))
s.addremove = true
s.anonymous = true

o = s:option(ListValue, "type", translate("Proxy Type"))
o:value("transparent", translate("Transparent"))
o:value("socks5", translate("Socks5"))
o:value("forward", translate("Port Froward"))

o = s:option(DynamicList, "use_server", translate("Use Server"))
o:value("", translate("Disable"))
for _, s in ipairs(servers) do o:value(s.name, s.alias) end
o.rmempty = false

o = s:option(ListValue, "udp_relay_server", translate("UDP-Relay Server"))
o:value("", translate("Disable"))
o:value("same", translate("Same as Main Server"))
for _, s in ipairs(servers) do o:value(s.name, s.alias) end

o = s:option(Value, "local_port", translate("Local Port"))
o.datatype = "port"
o.rmempty = false

o = s:option(Value, "destination", translate("Destination"))
o:depends("type", "forward")
o.placeholder = "8.8.4.4:53"
o.default = "8.8.4.4:53"

o = s:option(Value, "mtu", translate("Override MTU"))
o.datatype = "range(296,9200)"
o.placeholder = 1492

return m
