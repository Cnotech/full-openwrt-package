#
# Copyright (C) 2016-2017 Xingwang Liao <kuoruan@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/kuoruan/shadowsocksr-libev.git
PKG_SOURCE_DATE:=2017-08-31
PKG_SOURCE_VERSION:=ab0020d16ebed4441e6ca8a3b7f00ce2da1c1ca0

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Xingwang Liao <kuoruan@gmail.com>

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy
	URL:=https://github.com/shadowsocksr/shadowsocksr-libev
	DEPENDS:=+libev +libudns +libpcre +libpthread +libsodium +libopenssl +zlib
endef

define Package/shadowsocksr-libev/description
  Shadowsocksr-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

CONFIGURE_ARGS += \
	--disable-ssp \
	--disable-assert \
	--disable-documentation \
	--enable-system-shared-lib

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(LN) ssr-local $(1)/usr/bin/ssr-tunnel
endef

$(eval $(call BuildPackage,shadowsocksr-libev))
