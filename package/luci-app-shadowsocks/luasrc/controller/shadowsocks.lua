-- Copyright (C) 2014-2017 Jian Chang <aa65535@live.com>
-- Copyright (C) 2017 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the GNU General Public License v3.

module("luci.controller.shadowsocks", package.seeall)

local http = require "luci.http"
local sys  = require "luci.sys"
local util = require "luci.util"

function index()
	if not nixio.fs.access("/etc/config/shadowsocks") then
		return
	end

	entry({"admin", "services", "shadowsocks"},
		alias("admin", "services", "shadowsocks", "general"),
		_("ShadowSocks"), 10).dependent = true

	entry({"admin", "services", "shadowsocks", "general"},
		cbi("shadowsocks/general"),
		_("General Settings"), 10).leaf = true

	entry({"admin", "services", "shadowsocks", "status"},
		call("action_status")).leaf = true

	entry({"admin", "services", "shadowsocks", "servers"},
		arcombine(cbi("shadowsocks/servers"), cbi("shadowsocks/servers-details")),
		_("Servers Manage"), 20).leaf = true

	entry({"admin", "services", "shadowsocks", "access-control"},
		cbi("shadowsocks/access-control"),
		_("Access Control"), 30).leaf = true
end

local function running_instance(name)
	return util.trim(sys.exec("pgrep %s | wc -l" % name))
end

function action_status()

	http.prepare_content("application/json")
	http.write_json({
		redir_status = {
			ss = running_instance("ss-redir"),
			ssr = running_instance("ssr-redir")
		},
		local_status = {
			ss = running_instance("ss-local"),
			ssr = running_instance("ssr-local")
		},
		tunnel_status = {
			ss = running_instance("ss-tunnel"),
			ssr = running_instance("ssr-tunnel")
		}
	})
end
