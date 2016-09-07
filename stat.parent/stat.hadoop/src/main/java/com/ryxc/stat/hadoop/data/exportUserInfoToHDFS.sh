#!/bin/sh
source /etc/profile
#通用的属性配置
source /opt/work/conf/mysqlconn.conf

#起始变量
j=1
#结束变量
k=0

while [ $j -gt $k ]
do
	
yesterday=`date -d"$j days ago"  +"%Y-%m-%d"`
echo $yesterday

let temp=j-1
stat_date=`date -d"$temp days ago"  +"%Y-%m-%d"`


sqoop import \
--connect jdbc:mysql://$test_ipaddr:$test_port/$test_dbname?charset=utf-8 \
--username $test_uname \
--password $test_upwd \
--target-dir /t_user_info/$yesterday \
--query "select * from t_user_info where time >='$yesterday' and time <'$stat_date' and \$CONDITIONS  " \
--fields-terminated-by '\t' \
-m 2 \
--split-by id \
--delete-target-dir

#int的加减计算
let j=j-1
done

