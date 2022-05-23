# DNS

* [就是要你懂DNS--一文搞懂域名解析相关问题](https://plantegg.github.io/2019/06/09/一文搞懂域名解析相关问题/)
* [Linux 系统如何处理名称解析](https://blog.arstercz.com/linux-系统如何处理名称解析/)

* nslookup
* dig

for((i=0;i<100;i++)); do time nslookup domain dns-server; done
for((i=0;i<100;i++)); do time dig @dns-server domain; done
