# anacron

* [Anacron理解及探究](http://soooldier.github.io/2017/04/01/Anacron理解及探究/)
* [使用anacron定期执行任务](http://blog.lujun9972.win/blog/2018/04/19/使用anacron定期执行任务/)
* [Linux 系统定时任务：crontab,anacron](https://segmentfault.com/a/1190000014806494)

```conf
# /etc/anacrontab: configuration file for anacron

# See anacron(8) and anacrontab(5) for details.

SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# the maximal random delay added to the base delay of the jobs
# 最大任务执行延迟时间
RANDOM_DELAY=45
# the jobs will be started during the following hours only
# 执行时间范围是 3:00~22:00
START_HOURS_RANGE=3-22

# 每天开机 delay 分钟后检查 /etc/cron.* 目录内的文件是否被执行，如果今天没有被执行，那就执行
# period in days  delay in minutes   job-identifier   command
1                 5                  cron.daily       nice run-parts /etc/cron.daily # 定时执行目录下的程序
7                 25                 cron.weekly      nice run-parts /etc/cron.weekly
@monthly          45                 cron.monthly     nice run-parts /etc/cron.monthly
```

我们用 cron.daily 工作来说明一下 /etc/anacrontab 的执行过程:

1. 读取 `/var/spool/anacron/cron.daily` 文件中 `anacron` 上一次执行的时间
2. 和当前时间比较，如果两个时间的差值超过 `1` 天，就执行 `cron.daily` 工作，这里可以清理文件进行执行测试
3. 只能在 03：00 ~ 22：00 执行
4. 执行工作时强制延迟时间为 5 分钟，再随机延迟 0～45 分钟
5. 使用 `nice` 命令指定默认优先级，使用 `run-parts` 脚本执行 `/etc/cron.daily` 目录中所有的可执行文件

cat /etc/cron.hourly/0anacron

每小时执行 `/etc/cron.hourly` 目录下的程序

```sh
# cat /etc/cron.d/0hourly
# Run the hourly jobs
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
01 * * * * root run-parts /etc/cron.hourly
```

每小时检查当天是否有任务遗漏，如有，执行 `anacron`

```sh
# cat /etc/cron.hourly/0anacron
#!/bin/sh
# Check whether 0anacron was run today already
if test -r /var/spool/anacron/cron.daily; then
    day=`cat /var/spool/anacron/cron.daily`
fi
if [ `date +%Y%m%d` = "$day" ]; then
    exit 0;
fi

# Do not run jobs when on battery power
if test -x /usr/bin/on_ac_power; then
    /usr/bin/on_ac_power >/dev/null 2>&1
    if test $? -eq 1; then
    exit 0
    fi
fi
/usr/sbin/anacron -s
```
