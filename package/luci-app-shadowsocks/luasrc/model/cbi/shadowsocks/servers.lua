-- Copyright (C) 2016-2017 Jian Chang <aa65535@live.com>
-- Copyright (C) 2017 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocks = "shadowsocks"

m = Map(shadowsocks, "%s - %s" %{translate("ShadowSocks"), translate("Servers Manage")})

-- [[ Servers Manage ]]--
s = m:section(TypedSection, "server")
s.anonymous = true
s.addremove = true
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = luci.dispatcher.build_url("admin/services/shadowsocks/servers/%s")
function s.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(s.extedit % sid)
		return
	end
end

function titleCase(first, rest)
   return first:upper() .. rest:lower()
end

o = s:option(DummyValue, "alias", translate("Alias"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end

o = s:option(DummyValue, "ssr_server", translate("SSR Server"))
function o.cfgvalue(...)
	local v = Flag.cfgvalue(...)
	return v == "1" and translate("Yes") or translate("No")
end

o = s:option(DummyValue, "server_addr", translate("Server Address"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue, "server_port", translate("Server Port"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue, "encrypt_method", translate("Encrypt Method"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue, "protocol", translate("Protocol"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "origin"
end

o = s:option(DummyValue, "obfs", translate("OBFS"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "plain"
end

return m
