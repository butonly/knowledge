# strace

* [强大的strace命令用法详解](https://www.linuxidc.com/Linux/2018-01/150654.htm)
* [[译]strace的10个命令](https://colobu.com/2021/04/30/strace-commands-for-troubleshooting-and-debugging-linux/)
* [Linux Tools Quick Tutorial](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/index.html)

```sh
usage: strace [-dDffhiqrtttTvVxx] [-a column] [-e expr] ... [-o file]
              [-p pid] ... [-s strsize] [-u username] [-E var=val] ...
              [command [arg ...]]
   or: strace -c [-D] [-e expr] ... [-O overhead] [-S sortby] [-E var=val] ...
              [command [arg ...]]
  -c -- count time, calls, and errors for each syscall and report summary
  -f -- follow forks, -ff -- with output into separate files
  -F -- attempt to follow vforks, -h -- print help message
  -i -- print instruction pointer at time of syscall
  -q -- suppress messages about attaching, detaching, etc.
  -r -- print relative timestamp, -t -- absolute timestamp, -tt -- with usecs
  -T -- print time spent in each syscall, -V -- print version
  -v -- verbose mode: print unabbreviated argv, stat, termio[s], etc. args
  -x -- print non-ascii strings in hex, -xx -- print all strings in hex
  -a column -- alignment COLUMN for printing syscall results (default 40)
  -e expr -- a qualifying expression: option=[!]all or option=[!]val1[,val2]...
     options: trace, abbrev, verbose, raw, signal, read, or write
  -o file -- send trace output to FILE instead of stderr
  -O overhead -- set overhead for tracing syscalls to OVERHEAD usecs
  -p pid -- trace process with process id PID, may be repeated
  -D -- run tracer process as a detached grandchild, not as parent
  -s strsize -- limit length of print strings to STRSIZE chars (default 32)
  -S sortby -- sort syscall counts by: time, calls, name, nothing (default time)
  -u username -- run command as username handling setuid and/or setgid
  -E var=val -- put var=val in the environment for command
  -E var -- remove var from the environment for command
```

```sh
-e trace=file     跟踪和文件访问相关的调用(参数中有文件名)
-e trace=process  和进程管理相关的调用，比如 fork/exec/exit_group
-e trace=network  和网络通信相关的调用，比如 socket/sendto/connect
-e trace=signal   信号发送和处理相关，比如 kill/sigaction
-e trace=desc     和文件描述符相关，比如 write/read/select/epoll 等
-e trace=ipc      进程见同学相关，比如 shmget 等
```

https://mozillazg.com/2019/03/linux-debug-with-strace-cookbook-examples.html

## 使用示例

strace -tt -T -v -f -e trace=network -e trace=desc -o strace-$(hostname)-$(date +"%Y%m%d-%H%M%S").log -s 1024 -p $pid
strace -tt -T -v -f -o strace-$(hostname)-$(date +"%Y%m%d-%H%M%S").log -s 1024 -p 33 -p 40
strace -tt -T -v -f -o strace-$(hostname)-$(date +"%Y%m%d-%H%M%S").log -s 1024 -p 32
strace -tt -T -v -e trace=network -e trace=desc -s 1024 -p 32
strace -tt -T -p 32

```sh
-tt 在每行输出的前面，显示毫秒级别的时间
-T 显示每次系统调用所花费的时间
-v 对于某些相关调用，把完整的环境变量，文件 stat 结构等打出来。
-f 跟踪目标进程，以及目标进程创建的所有子进程
-e 控制要跟踪的事件和跟踪行为，比如指定要跟踪的系统调用名称
-o 把 strace 的输出单独写到指定的文件
-s 当系统调用的某个参数是字符串时，最多输出指定长度的内容，默认是32个字节
-p 指定要跟踪的进程 pid, 要同时跟踪多个 pid, 重复多次 -p 选项即可。
```