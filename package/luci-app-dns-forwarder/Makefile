#
# Copyright (C) 2016 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-dns-forwarder
PKG_VERSION:=1.6.1
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Jian Chang <aa65535@live.com>

LUCI_TITLE:=LuCI support for DNS-forwarder
LUCI_DEPENDS:=+dns-forwarder
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/config
# shown in make menuconfig <Help>
help
	$(LUCI_TITLE)
	.
	Version: $(PKG_VERSION)-$(PKG_RELEASE)
	$(PKG_MAINTAINER)
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
