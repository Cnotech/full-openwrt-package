Shadowsocksr-libev for OpenWrt
=== 

简介
---

 本项目是 [shadowsocksr-libev][1] 在 OpenWrt 上的移植  

特性
---

软件包只包含 [shadowsocksr-libev][1] 的可执行文件, 可与 [luci-app-shadowsocks][2] 搭配使用
可编译两种版本  

 - shadowsocksr-libev

   ```
   客户端/
   └── usr/
       └── bin/
           ├── ssr-local       // 提供 SOCKS 代理
           ├── ssr-redir       // 提供透明代理, 从 v2.2.0 开始支持 UDP
           └── ssr-tunnel      // 提供端口转发, 可用于 DNS 查询
   ```

 - shadowsocksr-libev-server

   ```
   服务端/
   └── usr/
       └── bin/
           └── ssr-server      // 服务端可执行文件
   ```

编译
---

 - 从 OpenWrt 的 [SDK][S] 编译

   ```bash
   # 以 ar71xx 平台为例
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx-*
   # 添加 feeds
   git clone https://github.com/shadowsocks/openwrt-feeds.git package/feeds
   # 获取 shadowsocksr-libev Makefile
   git clone https://github.com/kuoruan/openwrt-shadowsocksr.git package/shadowsocksr-libev
   # 选择要编译的包 Network -> shadowsocksr-libev
   make menuconfig
   # 开始编译
   make package/shadowsocksr-libev/compile V=99
   ```

配置
---

   软件包本身并不包含配置文件, 配置文件内容为 JSON 格式, 支持的键:  

   键名           | 数据类型 | 说明
   ---------------|----------|-----------------------------------------------
   server         | 字符串   | 服务器地址, 可以是 IP 或者域名
   server_port    | 整数值   | 服务器端口号
   local_address  | 字符串   | 本地绑定的 IP 地址, 默认 `127.0.0.1`
   local_port     | 整数值   | 本地绑定的端口号
   password       | 字符串   | 服务端设置的密码
   method         | 字符串   | 加密方式, [详情参考][E]
   timeout        | 整数值   | 超时时间（秒）, 默认 60
   fast_open      | 布尔值   | 是否启用 [TCP Fast Open][F], 只适用于 `ss-local`, `ss-server`
   auth           | 布尔值   | 是否启用[一次验证][A]
   nofile         | 整数值   | 设置 Linux ulimit
   mode           | 枚举值   | 转发模式, 可用值: [`tcp_only`, `udp_only`, `tcp_and_udp`]
   mptcp          | 布尔值   | 是否启用 [Multipath TCP][M]


  [1]: https://github.com/shadowsocksr/shadowsocksr-libev
  [2]: https://github.com/kuoruan/luci-app-shadowsocks
  [A]: https://shadowsocks.org/en/spec/one-time-auth.html
  [E]: https://github.com/shadowsocks/luci-app-shadowsocks/wiki/Encrypt-method
  [F]: https://github.com/shadowsocks/shadowsocks/wiki/TCP-Fast-Open
  [S]: https://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
  [M]: https://www.multipath-tcp.org/
