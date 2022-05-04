#!/usr/bin/env bash

# 内核参考文档：http://www.cyberciti.biz/files/linux-kernel/Documentation/networking/ip-sysctl.txt

# 修改用户进程可打开文件数限制
echo "ulimit -SHn 1024000" >> /etc/profile
source "/etc/profile"

# 系统所有进程一共可以打开的文件数量
echo "fs.file-max = 10485760" >> /etc/sysctl.conf

# 更大限度使用物理内存
echo "vm.swappiness = 10" >> /etc/sysctl.conf

# 设置系统中每一个端口最大的监听队列的长度
echo "net.core.somaxconn = 32768" >> /etc/sysctl.conf

# 已经完成三次握手、已经成功建立连接的套接字将要进入队列的长度
# 若设置的backlog值大于net.core.somaxconn值，将被置为net.core.somaxconn值大小
# 每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目，对重负载服务器而言，该值需要调高一点。
echo "net.core.netdev_max_backlog = 262144" >> /etc/sysctl.conf

# 连接跟踪数据库的最大跟踪连接条目 需精打细算
echo "net.ipv4.ip_conntrack_max = 655360" >> /etc/sysctl.conf

# 本地端口范围
echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf

# 警告！
#   在大多数的 Linux 中 rmem_max 和 wmem_max 被分配的值为 128 k，在一个低延迟的网络环境中，或者是 apps 比如 DNS、Web Server，这或许是足够的。
#   尽管如此，如果延迟太大，默认的值可能就太小了，所以请记录以下在你的服务器上用来提高内存使用方法的设置。
# TCP读写缓冲区设置,单位是Page，1 Page = 4096Bytes, 4k=4096 768k=786432 500k=512000 1000k=1024000
# 第一个数字表示，当 tcp 使用的 page 少于 196608 时，kernel 不对其进行任何的干预
# 第二个数字表示，当 tcp 使用了超过 262144 的 pages 时，kernel 会进入 “memory pressure” 压力模式
# 第三个数字表示，当 tcp 使用的 pages 超过 393216 时（相当于1.6GB内存），就会报：Out of socket memory
echo "net.ipv4.tcp_mem = 786432 512000 1024000" >> /etc/sysctl.conf
# 第一个数字表示，为TCP连接分配的最小内存
# 第二个数字表示，为TCP连接分配的缺省内存
# 第三个数字表示，为TCP连接分配的最大内存
echo "net.ipv4.tcp_rmem = 4096 4096 16456252" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 4096 16456252" >> /etc/sysctl.conf

# 防范SYN DDOS攻击
# 只有在内核编译时选择了CONFIG_SYNCOOKIES时才会发生作用。当出现syn等候队列出现溢出时象对方发送syncookies。目的是为了防止syn flood攻击。
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
#表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf

#对于一个新建连接，内核要发送多少个 SYN 连接请求才决定放弃,不应该大于255，默认值是5，对应于180秒左右时间
echo "net.ipv4.tcp_syn_retries=2" >> /etc/sysctl.conf

# TCP的定时器系列 — 保活定时器
# https://blog.csdn.net/zhangskd/article/details/44177475
#表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，改为300秒
#net.ipv4.tcp_keepalive_*一系列参数，是用来设置服务器检测连接存活的相关配置。
echo "net.ipv4.tcp_keepalive_time=600" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes=3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl=75" >> /etc/sysctl.conf

# FIN 报文重传次数
echo "net.ipv4.tcp_orphan_retries=3" >> /etc/sysctl.conf

#表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间
echo "net.ipv4.tcp_fin_timeout=30" >> /etc/sysctl.conf

#表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。
echo "net.ipv4.tcp_max_syn_backlog = 4096" >> /etc/sysctl.conf

#表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf

#表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf

##优化网络设备接收队列echo "net.core.netdev_max_backlog=3000" >> /etc/sysctl.conf

#net.ipv4.tcp_tw_reuse和net.ipv4.tcp_tw_recycle的开启都是为了回收处于TIME_WAIT状态的资源。
#net.ipv4.tcp_fin_timeout这个时间可以减少在异常情况下服务器从FIN-WAIT-2转到TIME_WAIT的时间。

sysctl -p
