###前台

前后台必须运行的脚本
可以理解为 他们在服务器上面启动一些特定的端口 然后咱们配置工具的时候 配置服务器对应启动的端口
用工具连接和服务器交互

前台服务器上面 我们会放置一个文件夹



这个start.sh的脚本就是调用平台提供的执行程序 启动16134这个端口，然后在ydpx里面配置16314，ydpx工具才能用

当然这个端口也可以改 都配置一样就可以


###后台



提供了四个daemon
batdaemon：为周期批量提供的（默认端口是6502）
bspdaemon：为业务系统提供的（默认端口是6500）
cspdaemon：为渠道提供的（默认端口是6501）
devdaemon：为bsp工具提供的（默认端口是6504）





这个是这几个端口的使用配置

这几个6500 6501 6502 6504 是默认的

启动的时候不加指定端口 就是启动的是他们

也可以指定端口启动

bspdaemon -p xxx

然后对应使用的地方配置一样即可

也可以 bspdaemon -k 




还有一点 这个表如果把生产上面的替换了 【一定】 要记得调整配置的ip地址



select * froM syscat.TABLES where TABSCHEMA='BSPDEV1';
select * froM syscat.INDEXES where IESCHEMA='BSPDEV1';
select * froM syscat.TRIGGERS where TRIGSCHEMA='BSPDEV1';
select * froM syscat.PACKAGES where PKGSCHEMA='BSPDEV1';

select 'db2 drop table '||trim(TABSCHEMA)||'.'||tabname||';' froM syscat.TABLES where TABSCHEMA='BSPDEV2';
select 'db2 drop INDEX '||trim(indSCHEMA)||'.'||indname||';' froM syscat.INDEXES where INDSCHEMA='BSPDEV2';
select 'db2 drop VIEW '||trim(VIEWSCHEMA)||'.'||VIEWname||';' froM syscat.VIEWS where VIEWSCHEMA='BSPDEV2';
select 'db2 drop TRIGGER '||trim(trigSCHEMA)||'.'||trigname||';' froM syscat.TRIGGERS where TRIGSCHEMA='BSPDEV2';
select 'db2 drop PACKAGE '||trim(pkgSCHEMA)||'.'||PKGNAME||';' froM syscat.PACKAGES where pkgSCHEMA='BSPDEV2';





看到开发环境上面有这么多实例对吧

bspdev1 bspdev2 bspdev32 这些都不是系统用的

也不是系统用户 仅仅是一个“数据库用户”而已

是怎么来的呢

1、项目初期 备份数据啥的

2、数据移植导致

db2 一般数据移植用db2move 命令

导出 db2move devdb export -sn bspdev

这个命令是将bspdev这个用户的数据导出





这个list里面呢 是导出表和表数据的对应关系

然后看最前面的bspdev

这个是数据实例

db2的导入 db2move testdb import

这个命令在list同级目录执行

同样会使用刚才那个list

注意： 这个地方



使用vi命令打卡那个list 然后按ESC+:

%s/BSPDEV/BSPTEST/g

这个是啥意思呢 就是把这个文件里面的bspdev 全部 替换为bsptest

这样导入的时候 数据就是导入到bsptest里面

如果不改这个实例 那么就会在目标数据库里面自动创建一个bspdev

这也就是为啥开发上面会有 bsptest bsprun用户的原因

以后要杜绝这个事情

这几个命令是找到 bspdev1这个实例在当前数据库下的 表 索引 触发器 包



这个就是生成对应的drop语句



把信息都drop掉以后 就可以把无用实例也干掉

db2 drop schema bspdev1 RESTRICT

正常 一个bsp的数据库用户 一个plat的 一个workflow的

bsp的是业务用

plat是平台用

workflow是工作流用

bsp 分 运行库 管理库 查询库 备份库

bspdev bspmgr bspqry bsphis

备份库叫历史库


整个对话记录如下

: 都知道前后台必须要运行的那几个脚本吧
: 为啥前后台工具能使用连接服务器 
: 就是因为执行这几个脚本的原因
: 可以理解为 他们在服务器上面启动一些特定的端口 然后咱们配置工具的时候 配置服务器对应启动的端口
: 然后使用工具就可以和服务器交互
: 
: 为啥ydpx工具要配置这个端口
: 配置别的为啥不行
: 或者一定要配置这个
: 前台服务器上面 我们会放置一个文件夹
: 
: 
: 这个里面有这几个文件
: 
: 这个start.sh的脚本就是调用平台提供的执行程序 启动16134这个端口，然后在ydpx里面配置16314，ydpx工具才能用
: 当然这个端口也可以改 都配置一样就可以
: 前台就这一个
: -----------------------------------------
: 后台的
: 
: 提供了四个daemon 
: batdaemon：为周期批量提供的（默认端口是6502）
bspdaemon：为业务系统提供的（默认端口是6500）
cspdaemon：为渠道提供的（默认端口是6501）
devdaemon：为bsp工具提供的（默认端口是6504）
: batdaemon：为周期批量提供的（默认端口是6502）
bspdaemon：为业务系统提供的（默认端口是6500）
cspdaemon：为渠道提供的（默认端口是6501）
devdaemon：为bsp工具提供的（默认端口是6504）
: 
: 这个是这几个端口的使用配置

: 这几个6500 6501 6502 6504 是默认的
: 启动的时候不加指定端口 就是启动的是他们
: 也可以指定端口启动
: bspdaemon -p xxx
: 然后对应使用的地方配置一样即可
: 一般重启方法为   找到对应进程 然后跟进进程号杀掉进程
: 也可以 bspdaemon -k 
: 
: 这次说了 如果以后遇到和这个有关的 希望都能自己独立解决
