# NGINX

* [nginx-json-logformat](https://github.com/kmjones1979/nginx-json-logformat/blob/master/etc/nginx/conf.d/json_log.conf)

## 关于 upsteam

```nginx
upstream example {
    # 1. 只有一个 server 时没有 next_upstream 存在，不会换到下一个 server 重试，不会对同一个 upstream 重试
    # 2. 如果有多个 server，上游返回 502 时，会换机器重试，请求日志中会有多个 upstream 记录，无错误日志记录
    # 3. 如果有多个 server，上游返回 502 时，max_fails 如果不等于 0，在错误达到一定次数时会被标记为 不可用，如果同时处于不可用状态，则会出现 no live upstreams
    # 这里希望能够按预期进行失败重试，必须要配置多个 server，且至少有两个 server 存活，即 第一次 请求失败后，还能有至少一个可分配的 server，所以，要么是 server 很多，要么是 server 不会轻易被标记为不可用
    # 注意 backup server 同样可能被标识为不可用
    # 因为 upstream 地址是相同的，失败计数没意义，所以配置 max_fails=0 关闭失败计数

    server 127.0.0.1:65535 max_fails=0 fail_timeout=10s;
    server 127.0.0.1:65535 max_fails=0 fail_timeout=10s;

    # server 127.0.0.1:65534 max_fails=0 fail_timeout=10s;

    # Nginx 对上游不同的响应状态码的 KeepAlive 策略是不同的
    # 抓包观察到 200，会正常 KeepAlive，5xx会尝试进行close，但是发现并不是所有 5xx 都 close，可能跟 max_fails 有关，这个要再观察观察

    # 保持的最大连接数，超过了，Nginx 会清理最久未被使用的
    keepalive 1000;
  
    # 单个连接上最多请求数，达到这个数量的链接将会被清理
    keepalive_requests 100;

    # KeepAlive 保持时间
    keepalive_timeout 6s;
}
```

## 关于 Nginx 502 504

### Nginx 502

上游重启：

upstream prematurely closed connection while reading response header from upstream
recv() failed (104: Connection reset by peer) while reading response header from upstream

上游没启动

connect() failed (61: Connection refused) while connecting to upstream

### Nginx 504

connect() failed (110: Connection timed out) while connecting to upstream
upstream timed out (110: Connection timed out) while connecting to upstream

## Nginx 重试优化

Nginx 对上游进行重试时，可以配置多种策略，如何只在TCB连接未建立的情况下进行重试呢？设置连接超时时间很小

http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream
https://github.com/openresty/openresty/issues/200

```nginx
proxy_next_upstream error timeout non_idempotent;
proxy_next_upstream_tries 1;    # 代理请求的重试次数
proxy_next_upstream_timeout 3s; # 重试的超时时间
proxy_connect_timeout 200ms;
proxy_read_timeout 75s;
proxy_send_timeout 30s;
proxy_buffer_size 256k;
proxy_buffers 4 256k;
proxy_busy_buffers_size 256k;
proxy_temp_file_write_size 256k;

proxy_ignore_client_abort on;

client_body_buffer_size 256k;
client_max_body_size 50m;

keepalive_requests 10000;
```

## 关于 Nginx 499

1. nginx 在接受到客户端请求后，在发送请求给 upstream 前，会检查客户端连接，如果连接异常，此时 nginx 会记录 499。
2. nginx 在发送请求 next_upstream 前，会检查客户端连接，此时 nginx 会记录 499。
3. nginx 在 upstream 处理请求未结束，而 client 提前关闭了连接，nginx 会主动关闭与 upstream 的连接，nginx 此时会记录 499。

默认情况下，如果请求过程中如果客户端主动关闭连接或客户端网络断掉，那么 Nginx 会记录 499，同时 request_time 是「后端已经处理」的时间，而 upstream_response_time 为 `-`。

让 nginx 不要主动关闭连接，那么客户端主动断掉连接之后，Nginx 会等待后端处理完(或者超时)，然后记录 「后端的返回信息」 到日志。

```nginx
proxy_ignore_client_abort  on;
```

## 关于 Nginx 408

HTTP408代表链接超时，即：客户端的请求发送到服务器端花费的时间超过了服务器端等待的时间，所以服务器端放弃了该连接。

Nginx 遇到 408 错误的处理方案

一般情况下408错误（Request time out）并不常见，如果遇到了这类错误我们建议修改Nginx配置（nginx.conf）参数，可能会导致408错误的Nginx参数有：

1. `client_header_timeout` 此参数代表服务器端等待客户端(client)发送请求头的超时时间，如果此时间过短就会导致 Client Header 头信息发送失败，Nginx就会返回408状态。
2. `client_body_timeout` 此参数指定了请求体的读取超时时间，如果服务器在规定时间内没有读取到请求体，Nginx就会返回408状态。

## Nginx 日志轮转

https://github.com/logrotate/logrotate

```sh
$ cat /etc/logrotate.d/nginx.logroate
path-to-nginx-log-dir/access.log {
    su root root
    daily
    rotate 2
    missingok
    notifempty
    nocompress
    sharedscripts
    postrotate
        nginx -t && /usr/local/services/tnginx_1_0_0-1.0/bin/nginx -s reopen # 注意这里是 reopen 而不是 reload
    endscript
}
```
