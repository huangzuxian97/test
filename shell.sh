

i------------------------------------------------------------------
----------------------------shell day01----------------------------
i------------------------------------------------------------------

https://github.com/redhatedu

读万卷书，下笔如有神？？？

第二阶段

shell脚本、运维、集群

----------------重点------------需要逻辑思维！！-----------------

 shell 脚本 一个大的类别
 /bin/bash 具体的一个脚本解释器

[root@server0 ~]# cat /etc/shells	#查看当前系统已安装的所有解释器
	/bin/sh
	/bin/bash
	/sbin/nologin
	/usr/bin/sh
	/usr/bin/bash
	/usr/sbin/nologin
	/bin/tcsh
	/bin/csh
	/bin/ksh
	
------------------------------------------------------------------------------

默认记录历史条数
grep -i HISTSIZE /etc/profile	#[-i] 忽略大小写

查看历史条数
history | wc -l

后10条
history | tail

调用历史
history
!yum #命令前面的字母
!123  #命令的行号

清空历史
history -c
cat .bash_history | wc -l
> ~/.bash_history		#重定向一个空内容到 .bash_history

------------------------------------------------------------------------------

别名：
alias 关机="poweroff"	#临时别名
unalias 关机			#取消别名

永久别名 --->  ～/.bashrc	#当前用户可用
	/etc/bashrc		#所有用户可用

------------------------------------------------------------------------------

重定向
	> 	覆盖重定向
	>> 	追加重定向

错误重定向
	2>	错误 覆盖重定向
	2>>	错误 追加重定向
	
正确和错误输出
	ls /etc/hosts /xxx  >1.txt  2>2.txt	#分别把正确的输出和错误的输出重定向到不同文件里面
	ls /etc/hosts /xxx  &>3.txt	#把正确和错误的输出重定向到同一个文件里面

	&>  == ls /xxx /etc/passwd >hehe.txt  2>&1

------------------------------------------------------------------------------

mail -s title root < /etc/passwd
echo "hehe" | mail -s title root

------------------------------------------------------------------------------

当脚本没有执行权限时，可以直接调用解释器bash、sh、source 来加载脚本文件。
bash /root/test.sh 



[root@server0 ~]# chmod +x test.sh 
[root@server0 ~]# ./test.sh
        ├─sshd─┬─sshd───bash───test.sh───sleep

[root@server0 ~]# bash test.sh
        ├─sshd─┬─sshd───bash───bash───sleep

[root@server0 ~]# source test.sh
        │      └─sshd───bash───sleep


不开子进程，直接执行脚本
source /etc/profile	#重新加载脚本配置文件
. /etc/profile

------------------------------------------------------------------------------

变量的定义
test=11	# 等于号前后不能有空格

变量的使用
echo $test
echo ${test}RMB

变量的取消
unset test

------------------------------------------------------------------------------

环境变量
$HISTSIZE
$PS1  $PS2

env #查看系统变量

set #查看所有变量

位置变量	$1 $2 ..
预定义变量	$0 $* $# $$ $?

echo $0	//当前程序名称
echo $1	//第一个参数
echo $2	//第二个参数
echo $*	//所有参数
echo $#	//参数的个数
echo $$	//当前bash进程的PID
echo $?	//上一个程序的返回状态码
echo $!	//最后一个后台程序的PID
------------------------------------------------------------------------------

单引号	界定完整字符串 屏蔽特殊符号	#整体，没有特殊含义，看到什么就是什么
双引号	界定完整字符串		#整体，可能有特殊含义
反引号	命令替换			# `` 等同于 $()

stty -echo	#关闭回显
read -p "请输入密码：" pass
stty echo	#打开回显

------------------------------------------------------------------------------

export nb=456	#定义全局变量

nb=456
export nb

------------------------------------------------------------------------------

if [];then
elif
else
fi

for . in .
do
done

while bool
do
done


i------------------------------------------------------------------
----------------------------shell day02----------------------------
i------------------------------------------------------------------

运算
整数：expr、$[]/$(())、let

	nb=3
	expr 1 * 3		#错误，*会被当成通配符来处理
	expr 3 \* $nb	#引用变量时要加$、运算符前后必须有空格
	expr 3 '*' $nb	#使用*时，需要加 ‘ 单引号 ’ 或者 " 双引号 " ，或者转义符 \
	
	$[]/$(())	#i对空格没有严格要求
	i=9;j=5
	echo $[i*j]	#对变量运算可以省略$
	echo $((i*j))
	支持 ++ -- += -= *= /= %=
	
	let x=1+2	#把计算结果赋值给一个参数，不直接显示结果
	echo $x
	i=2
	j=3
	let x=i*j	#对变量运算不需要加$
	支持 ++ -- += -= *= /= %=
	
小数：bc
	scale=2	#保留2位小数点
	
	非交互：
	echo "1.2+2.8" | bc
	echo "scale=2;2/10" | bc
	echo "3>2" | bc	--> 1	#正确
	echo "3>4" | bc	--> 0	#错误
	对比： $?	#但凡出现$?，0代表正确，非0代表错误，代表程序执行后的状态值
		bc	#1代表正确，0代表错误，代表程序执行后的bool值

	[ $USER != root ] && exit	#判断当前用户
	[ $USER == root ] || exit

	nb=123
	[ -z $nb ] && echo Y || echo N	#判断变量是否为空
	
		N
	
	
	[ ! -z $nb ] && echo Y || echo N	#判断变量是否不为空
	
		Y
	
who	#当前登录的用户数

	[ -r /etc/passwd ] #判断当前用户是否具有读取权限，对root用户无效
	[ -w /etc/passwd ] #判断当前用户是否具有写入权限，对root用户无效
	[ -x /etc/passwd ] #判断当前用户是否具有执行权限，对所有用户有效
	
wc -l
	ls /xxx /etc/passwd | wc -l	#统计正确结果的行数
	ls /xxx /etc/passwd |& wc -l	#统计正确和错误结果的行数
	
	
i------------------------------------------------------------------
----------------------------shell day03----------------------------
i------------------------------------------------------------------

for i in `seq 5`
do
    循环体
done

C
for ((i=1;i<=5;i++))
do
    循环体
done

造数工具：
	{1..5}	#不支持变量
	seq $nb	#可以使用变量
	
ping -c3 -i0.1 -W1 176.121.202.$i &> /dev/null
	-c	#count  ping多少个数据包
	-i	#每次ping的时间间隔
	-W	#等待回应时间，最少等待一秒钟
	
------------------------------------------------------------------------------

while 条件测试
do
    循环体
done
	
	while :	#条件永远为真
	
	clear		#清屏
	sleep 0.1	#睡0.1秒
	
	#!/bin/bash
	dir=/root/day03/users.txt
	s=`cat $dir |wc -l`
	while :
	do
	    clear
	    i=$[RANDOM%s+1]
	    head -$i $dir | tail -1
	    sleep 0.01
	done
	
------------------------------------------------------------------------------
	
	case $1 in
	redhat)	#第一个匹配的值
	    echo haha	#非最后一行，不需要加;;
	    echo fedora;;	#代码块最后一行命令需要加;;
	fedora)	#第二个匹配的值
	    echo redhat;;
	*)		#代表其他所有
	    echo "xxx"	#最后一行可以不加;;
	esac			#esac结尾
	
	#!/bin/bash
	case $1 in
	-n)
	   touch $2;;
	-e)
	   vim $2;;
	-c)
	   cat $2;;
	-r)
	   rm -rf $2;;
	*)
	   echo "Usage:$0 [-n|-e|-c|-r] file" >&2
	   exit 1
	esac
	
------------------------------------------------------------------------------
	
函数
	function mycd{
	    mkdir $1
	    cd $1
	}
	
	mycd(){
	    mkdir $1
	    cd $1
	}


函数ping
	myping(){
	    ping -c3 -i0.1 -W1 $1 &> /dev/null
	    if [ $? -eq 0 ];then
	        echo "Host $1 is up" >> up.txt
	    else
	        echo "Host $1 is down" >> down.txt
	    fi
	}
	> ~./up.txt
	for i in `seq 255`
	do
	    myping 176.121.202.$i &
	done
	cat up.txt
	
函数炸弹
	#!/bin/bash
	#fork炸弹
	.(){
	.|.&
	}
	.
	
------------------------------------------------------------------------------

颜色
	echo -e "\033[31m\033[42mOK\033[0m"
	
	\033[1-4m	#字体样式
	\033[31-37m	#字体颜色
	\033[41-37m	#背景颜色
	\033[0m	#结束
	
------------------------------------------------------------------------------
	
	[ $i -eq 3 ] && continue
	ssh 192.168.4.100 mkdir /nnb	#非交互远程
	
	continue	#跳出本一次循环
	break		#终止整个循环
	exit		#结束整个脚本程序
	
	
i------------------------------------------------------------------
----------------------------shell day04----------------------------
i------------------------------------------------------------------
	
字符串截取

	phone=13898803276
	
${::}
	${#phone} >> 11	#打印变量phone的长度
	${phone:起始索引:截取长度}	#起始索引从0开始
	${phone::4} >> 1389	#起始位置为0时，可以留空
	
expr
	#expr substr "$变量名" 起始位置 长度  
	#起始位置从1开始
	expr substr $phone 1 4 >> 1389
	
	
cut
	#echo $变量名 | cut -b 1-3
	#cut 起始位置为1
	#1-3 截取范围 1-3
	#1，3，5 截取第1，3，5位
	echo $phone | cut -b 1-3
	echo $phone | cut -b 1,3
	
------------------------------------------------------------------------------
	
字符串替换
	
	phone=13898803276
	${phone/8/*} >> 13*98803276
	${phone//8/*} >> 13*9**03276
	
------------------------------------------------------------------------------
	
掐头去尾
	
	[root@svr7 ~]# echo $A
		root:x:0:0:root:/root:/bin/bash

	[root@svr7 ~]# echo ${A#*:}
		     x:0:0:root:/root:/bin/bash
	
	[root@svr7 ~]# echo ${A##*:}
					    /bin/bash
	
	
	[root@svr7 ~]# echo ${A%:*}
		root:x:0:0:root:/root
	
	[root@svr7 ~]# echo ${A%%:*}
		root
	
------------------------------------------------------------------------------
	
定义变量初始值  防止报空
	
	test=${test:-123} #当$test的值为空时，使用123作为初始值
	
	read -p "please input your username" user
	[ -z $user ] && exit
	read -p "please input your password" pass
	pass=${pass:-123456}	#当输入为空时，使用默认密码
	
	
------------------------------------------------------------------------------
	
数组
	a=(11 22 33 44)
	/
	
	适合做循环
	a[0]=11
	a[1]=22
	a[2]=33
	a[3]=44
	
	${a[*]}	#查看数组的值*/@ 代表所有
	echo ${a[3]} --> 44
	
------------------------------------------------------------------------------

expect 预期交互
	
	mail -s title root << EOF
	hello,yue ma
	san li tun
	you yi ku
	EOF
	
	补充：
	> /var/mail/root	#清空邮件
	
	cat > /root/test.txt << EOF
	zhangsan
	lisi
	wangwu
	harry
	chihiro
	kenji
	haxi
	dc
	EOF
	
	expect << EOF
	spawn ssh -o StrictHostKeyChecking=no -X 192.168.4.207
	expect password 	{send "1\n"}
	expect #		{send "touch /test.txt\r"}
	expect #		{send "exit\n"}	#默认不执行,只是逢场作戏罢了。
	EOF
	
------------------------------------------------------------------------------
	
正则	
	^
	$
	[ ]
	
	
	
	grep "the" regular_express.txt
	grep -v "the" regular_express.txt
	grep -i "the" regular_express.txt
	#grep "t[ea]ste*" regular_express.txt	#不够好，会匹配多个e
	grep "t[ea]ste\{0,1\}" regular_express.txt
	
	grep "oo" regular_express.txt
	grep "[^g]oo" regular_express.txt	#木有问题
	grep "[^a-z]oo" regular_express.txt
	grep "[0-9]" regular_express.txt
	grep "^the" regular_express.txt
	grep "^[a-z]" regular_express.txt
	grep "^[^a-Z]" regular_express.txt	#等同于 "^[^a-zA-Z]"
	
	grep "\.$" regular_express.txt
	grep "^$" regular_express.txt
	grep "g..d" regular_express.txt
	grep "ooo*" regular_express.txt	#"o\{2,\}"
	grep "goo*g" regular_express.txt
	grep "[0-9]" regular_express.txt
	grep "o\{1,\}.*o\{1,\}" regular_express.txt
	grep "o\{2,5\}g" regular_express.txt
	
	
	\btest\b  ==  \<test\>	#单词边界
	
i------------------------------------------------------------------
----------------------------shell day05----------------------------
i------------------------------------------------------------------
	
sed [option] '条件指令' /路径/文件名

	[option]
	-n	#屏蔽默认输出
	-i	#直接对源文件进行修改
	-r	#使用扩展正则
	
	'条件指令p'
	p	#打印所有行
	1p	#打印第一行
	3,6p	#打印第3，4，5，6行
	3p;6p	#打印第3，6行
	3,+10p #打印第3行 以及3后面的10行
	$p	#打印最后一行
	
	#打印奇数行
	1~2p	#打印公差为2 的等差行： 1，3，5，7... 
	#打印偶数行
	2~2p
	
	'条件指令d'
	#同上...
	
    正则案例：
	# 格式：/正则表达式/
	/root/	#匹配包含root的行
	/^root/	#匹配以root开头的行
	/root$/	#匹配以root结尾的行

	's/a/b/'	#把所有行第一个a替换成b	
	#替换符可以是任何单个字符...
	
    考题：？？ #屏蔽符\
	's9\98\97\99\95\98\99'	#把98979 替换成 95989
	's#98979#95989#'		#替换符可以是任意单个字符...
	
	s/a/b/2	#把第二个a替换成b
	s/a/b/g	#把所有a替换成b
	s/a//		#把所有a替换为空
	2s/a/b/2	#把第二行第二个a替换成b
	4,7s/^/#/	#为第4，5，6，7行添加注释
	s/^#an/an/	#把an开头的注释去掉	#后面不写字符可以一次性去掉所有注释
	
	sed -r 's/^(.)(.*)(.)$/\3\2\1/' test.txt	#把第一个字符和倒数第一个字符对调
	sed -r 's/^(.)(.)(.*)(.)(.)$/\1\4\3\2\5/' test.txt	#把第二个字符和倒数第二个字符对调
	sed -r 's/^(.){5}(.*)(.){5}$/\2/' test.txt	#把前面五个字符和后面五个字符删掉~
	sed -r 's/.//5' test.txt		#把第五个字符替换为空
	
	

	sed -n 's/a/b/p'	#只显示替换过的行
	
	'='	#显示行号
	/^root/=	#显示以root开头的行号
	
------------------------------------------------------------------------------
	
	cp /etc/vsftpd/vsftpd.conf{,.bak}	#原地拷贝
	
[root@server0 ~]# cat test.txt
  Hello
    How Are You
  I am Fine

[root@server0 ~]# sed -r 's/^( )+//;s/([A-Z])/[\1]/g' test.txt 
[H]ello
[H]ow [A]re [Y]ou
[I] am [F]ine
	
	'################i指令i################'
	
	p	#print 打印输出
	d	#delete 删除
	s	#substitute 替换
	=	#显示行号
	!	#指令取反
	
	i	#insert插入
	a	#append追加
	c	#替换整行(和s不一样，s是替换某一个字符串)
	
	r	#read 
	w	#另存为
	H	#追加复制
	h	#覆盖复制
	G	#追加粘贴
	g	#覆盖粘贴
	
	h;d	#剪切
	
	sed -n 's/:.*//p' /etc/passwd	#提取用户名	等同于去尾
	sed -n 's/.*://p' /etc/passwd	#提取解释器	等同于掐头
	
	sed -n '2s/$/***/' test.txt	#追加***到第二行行尾
	
		
i------------------------------------------------------------------
----------------------------shell day06----------------------------
i------------------------------------------------------------------
	
	前置命令 | awk [选项] '[条件]{指令}'
	awk [选项] '[BEGIN{指令}][条件]{指令}[END{指令}]' 文件...
	awk [选项] '[条件]{指令}' 文件...
	
	条件: 	/正则/		/字符串/	NR==行号
	
	awk '/Failed/{print $11}' /var/log/secure		#查看登录失败的ip
	awk '/Accepted/{print $11}' /var/log/secure	#查看登录成功的ip
	awk 'BEGIN{x=10;y=3;print x%y}'	#作为计算器来使用
	awk 'BEGIN{x=0}/bash$/{x++}END{print x}' /etc/passwd	#统计符合条件的个数
	
 awk -F: 'BEGIN{print "用户名 UID 家目录"}{print $1,$3,$6}END{print "总用户:"NR}' /etc/passwd | column -t
	column -t	#自动对齐...
	
	awk -F: '$6~/root/' /etc/passwd	#正则匹配第6列
	
	#	!取反
	awk -F: '$7!~/nologin/' /etc/passwd	#打印：解释器不是nologin的行
	
	awk -F: '$7!~/nologin/{print $1,$7}' /etc/passwd | column -t

------------------------------------------------------------------------------
   question:
	awk '/^root/' /etc/passwd
		root:x:0:0:root:/root:/bin/bash
		roota:x:1002:1002::/home/roota:/bin/bash
   answer:	
	awk -F: '$1=="root"' /etc/passwd
		root:x:0:0:root:/root:/bin/bash
------------------------------------------------------------------------------

	awk -F: '$3>=1000{print $1}' /etc/passwd
		lisi
		tomcat
	awk -F: '$3==1000{print $1}' /etc/passwd
		lisi
	[root@svr7 nsd01]# id lisi
		uid=1000(lisi) gid=1000(lisi) 组=1000(lisi)
	
	seq 2050 | awk '$1%4==0&&$1%100!=0||$1%400==0'	#闰年
	
	#网站访问量统计/排序
	awk '{ip[$1]++}END{for(i in ip){print ip[i],i}}' /var/log/httpd/access_log | sort -nr
	
 awk '{ip[$1]++}END{for(i in ip){print ip[i],i}}' /var/log/httpd/access_log | awk '$1>1000{print $2}'
	
	ab -c 100 -n 100000 http://192.168.4.100/	#最后面一定要加/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
