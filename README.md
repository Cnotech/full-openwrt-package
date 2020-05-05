## 更全面的第三方OpenWrt Feeds仓库
### 收集自
[Lienol/openwrt-package](https://github.com/Lienol/openwrt-package)


[huchanghui123/Lienol-openwrt-packages-backup](https://github.com/huchanghui123/Lienol-openwrt-packages-backup)


[kuoruan/luci-app-v2ray](https://github.com/kuoruan/luci-app-v2ray)


[kuoruan/openwrt-frp](https://github.com/kuoruan/openwrt-frp)


[kuoruan/openwrt-upx](https://github.com/kuoruan/openwrt-upx)


[kuoruan/luci-app-frpc](https://github.com/kuoruan/luci-app-frpc)


[kuoruan/openwrt-feeds](https://github.com/kuoruan/openwrt-feeds)


[vernesong/OpenClash](https://github.com/vernesong/OpenClash)


[frainzy1477/luci-app-clash](https://github.com/frainzy1477/luci-app-clash)


[aa65535/openwrt-shadowvpn](https://github.com/aa65535/openwrt-shadowvpn)


[kenzok8/openwrt-packages](https://github.com/kenzok8/openwrt-packages)


[rufengsuixing/luci-app-adguardhome](https://github.com/rufengsuixing/luci-app-adguardhome)


[wongsyrone/openwrt-Pcap_DNSProxy](https://github.com/wongsyrone/openwrt-Pcap_DNSProxy)


[hubaiz/DslrDashboardServer](https://github.com/hubaiz/DslrDashboardServer)


[tobiaswaldvogel/openwrt-addpack](https://github.com/tobiaswaldvogel/openwrt-addpack)


[maxlicheng/luci-app-unblockmusic](https://github.com/maxlicheng/luci-app-unblockmusic)


[giaulo/luci-app-filebrowser](https://github.com/giaulo/luci-app-filebrowser)


[sensec/ddns-scripts_aliyun](https://github.com/sensec/ddns-scripts_aliyun)


[freifunk-gluon/gluon](https://github.com/freifunk-gluon/gluon)


[Kiougar/luci-wrtbwmon](https://github.com/Kiougar/luci-wrtbwmon)


[anshi233/Openwrt-BBR](https://github.com/anshi233/Openwrt-BBR)


[zhaojh329/oui](https://github.com/zhaojh329/oui)

### 如何使用

1. 添加 `src-git cnotech https://github.com/Cnotech/full-openwrt-package` 到 OpenWRT源码根目录feeds.conf.default文件

2. 执行
```bash
cd scripts
./feeds clean
./feeds update -a
./feeds install -a
cd ..
```
或者你可以把该源码手动下载或Git Clone下载放到OpenWRT源码的Package目录里面，然后编译。
如果你使用的是Luci19或更高，请编译时选上"luci","luci-compat","luci-lib-ipkg"后编译