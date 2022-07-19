
* [Linux.Kernel.Write.Procedure.pdf](https://lrita.github.io/images/posts/filesystem/Linux.Kernel.Write.Procedure.pdf)
* [Linux file system analysis VFS](https://programmer.group/linux-file-system-analysis-vfs.html)
* [Linux文件读/写流程](https://xgwang0.github.io/2018/12/24/Linux-FileSystem_File-Read_Write-Process)
* [Linux VFS](https://xgwang0.github.io/2018/12/25/Linux-FileSystem_VFS/)
* [Linux PageCache详解](https://www.sunliaodong.cn/2021/03/11/Linux-PageCache%E8%AF%A6%E8%A7%A3/)
* [LINUX缓存写回机制](https://oenhan.com/linux-cache-writeback)
* [数据结构之Radix Tree](https://ivanzz1001.github.io/records/post/data-structure/2018/11/18/ds-radix-tree)

* [PageCache系列之一 什么是BufferCache](https://zhuanlan.zhihu.com/p/38408110)
* [PageCache系列之二 BufferCache实现](https://zhuanlan.zhihu.com/p/38410147)
* [PageCache系列之三 Filemap](https://zhuanlan.zhihu.com/p/38417467)
* [PageCache系列之四 PageCache的出现](https://zhuanlan.zhihu.com/p/38681930)
* [PageCache系列之五 统一缓存之PageCache](https://zhuanlan.zhihu.com/p/42364591)
* [PageCache系列之六 统一缓存之BufferCache](https://zhuanlan.zhihu.com/p/42431418)

https://bean-li.github.io/

Linux内核映像
linux文件系统 rootfs sysfs

linux内核启动关于先有鸡再有蛋的问题？
https://www.zhihu.com/question/26695745/answer/490790026

GRUB——系统的引导程序简单介绍
GRUB 和 LINUX 关系
Grub&initrd&initramfs详解
Initramfs 原理和实践

MBR&/BOOT和GRUB三者关系总结
https://blog.csdn.net/wjc19911118/article/details/52052989

linux的mount结构与原理
https://blog.csdn.net/jinking01/article/details/105683360

Linux文件系统的工作原理
https://www.lujianxin.com/x/art/ogqjbet7znn9

深入Linux内核架构--内存管理设计介绍
https://www.jianshu.com/p/5ab4a276928d

深入linux内核架构--虚拟文件系统
https://www.jianshu.com/p/ec77c8c62fc2
https://www.jianshu.com/p/a98cb5519a50

super_block: 文件系统初始化时建立起来了，其中存储着 inode 信息，文件系统类型，等等信息，每个挂载的文件系统对应一个 super_block 结构。
dentry: 主要用于管理文件名，建立与所有子目录项的联系。
dcache: 存储着文件系统中所有的 inode 信息，每个 inode 对应一个 dcache 结构。
inode: 主要管理文件的元数据信息，包括权限信息，访问信息，链接信息，存储设备信息等，对应的操作主要包括链接、权限。
address_space: 主要负责内存与磁盘数据的同步，包括内存页的写入写出等。
file: fd 对应的内核 file 结构。

vfs
vfsmount
rootfs
