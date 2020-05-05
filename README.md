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