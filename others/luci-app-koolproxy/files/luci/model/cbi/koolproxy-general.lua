-- Copyright (C) 2016 chenhw2 <https://github.com/chenhw2>
-- Licensed to the public under the MIT License.

local m, s, o

if luci.sys.call("pgrep koolproxy >/dev/null") == 0 then
	m = Map("koolproxy", translate("KoolProxy"), "%s - %s" %{translate("KoolProxy"), translate("RUNNING")})
else
	m = Map("koolproxy", translate("KoolProxy"), "%s - %s" %{translate("KoolProxy"), translate("NOT RUNNING")})
end

s = m:section(TypedSection, "general", translate("General Setting"))
s.anonymous = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty = false

if luci.sys.call("command -v /var/run/koolproxy/kp >/dev/null") == 0 then
	o = s:option(DummyValue, "stat0", "%s %s" %{translate("KoolProxy"), translate("Version")})
	o.value=string.format("[ %s ]", luci.sys.exec("/var/run/koolproxy/kp -v"))

	o = s:option(DummyValue, "stat1", "%s-%s %s" %{translate("KoolProxy"), translate("Rules"), translate("Version")})
	o.value=string.format("%s", luci.sys.exec("head /var/run/koolproxy/data/rules/koolproxy.txt | sed -n '/]$/d; s/.*\\[/[/p'"))

	o = s:option(DummyValue, "stat2", "%s-%s %s" %{translate("KoolProxy"), translate("Rules"), translate("Counts")})
	o.value=string.format("[ %s ]", luci.sys.exec("sed '/^!/d' /var/run/koolproxy/data/rules/koolproxy.txt | wc -l"))

	o = s:option(DummyValue, "stat3", "%s-%s %s" %{translate("User Custom"), translate("Rules"), translate("Counts")})
	o.value=string.format("[ %s ]", luci.sys.exec("sed '/^!/d; /^[ \\t]*$/d' /var/run/koolproxy/data/rules/user.txt | wc -l"))

	o = s:option(DummyValue, "stat4", "%s-%s %s" %{translate("ADBlock"), translate("Hosts"), translate("Counts")})
	o.value=string.format("[ %s ]", luci.sys.exec("wc -l /var/dnsmasq.d/adblock.conf | sed 's/ .*//g'"))

end

o = s:option(Value, "startup_delay", translate("Startup Delay"))
o:value(0, translate("Not enabled"))
for _, v in ipairs({5, 10, 15, 25, 40, 60, 120}) do
	o:value(v, translate("%u seconds") %{v})
end
o.datatype = "uinteger"
o.default  = 0
o.rmempty  = false

o = s:option(Value, "ipt_ext", translate("Extra arguments"),
	translate("Passes additional arguments to iptables. Use with care!"))
o:value("", translate("None"))
o:value("--dport 80:88", translatef("Proxy port numbers %s only", "80~88"))
o:value("-m multiport --dports 80,88,8080", translatef("Proxy port numbers %s only", "80,88,8080"))

o = s:option(DynamicList, "lan_bp_list", translate("ByPass LAN"), translate("e.g. aa:bb:cc:dd:ee:ff"))
o.template = "koolproxy/dynamiclist"
o:value("00:00:00:00:00:00", "%s (%s)" %{"00:00:00:00:00:00", "NULL"})
o.placeholder = "00:00:00:00:00:00"
luci.sys.net.mac_hints(function(mac, name)
	o:value(mac, "%s (%s)" %{mac, name})
end)
o.datatype = "macaddr"
o.rmempty = false

return m
