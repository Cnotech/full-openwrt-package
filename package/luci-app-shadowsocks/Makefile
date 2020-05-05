#
# Copyright (C) 2016-2017 Jian Chang <aa65535@live.com>
# Copyright (C) 2017 Xingwang Liao <kuoruan@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-shadowsocks
PKG_VERSION:=2.2.2
PKG_RELEASE:=2

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Xingwang Liao <kuoruan@gmail.com>

LUCI_TITLE:=LuCI support for Shadowsocks and ShadowsocksR
LUCI_DEPENDS:=+jshn +iptables +ipset +ip +iptables-mod-tproxy
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/config
# shown in make menuconfig <Help>
help
	$(LUCI_TITLE)
	.
	Version: $(PKG_VERSION)-$(PKG_RELEASE)
	$(PKG_MAINTAINER)
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/shadowsocks
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/40_luci-shadowsocks ) && rm -f /etc/uci-defaults/40_luci-shadowsocks
fi
chmod 755 $${IPKG_INSTROOT}/etc/init.d/shadowsocks \
	$${IPKG_INSTROOT}/usr/bin/ss-rules >/dev/null 2>&1
$${IPKG_INSTROOT}/etc/init.d/shadowsocks enable >/dev/null 2>&1
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
