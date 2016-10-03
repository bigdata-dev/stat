#!/bin/sh
source /etc/profile


#起始变量
j=1
#结束变量
k=0

while [ $j -gt $k ]
do
	
yesterday=`date -d"$j days ago"  +"%Y-%m-%d"`
dirYesterday=`date -d"$j days ago"  +"%Y%m%d"`
echo $yesterday

let j=j-1

##清洗之前检测输出时候存在 如果存在则删除此目录
path="/user/hive/warehouse/fruit.db/t_origin_access_stat_tbl/stat_date=$yesterday/"
hadoop fs -test -e ${path}
if [ $? -eq 0 ];then
hdfs dfs -rm -r ${path}
fi
#执行mr来清洗数据
hadoop jar /home/ryxc/work/stat/jar/stat.hadoop-0.0.1-SNAPSHOT-jar-with-dependencies.jar com.ryxc.stat.hadoop.mr.AccessLogCleaner /user/ryxc/source/access/$dirYesterday/* ${path}

#将mr清洗的数据load到hive的原始表中供后期的指标分析
hive -e "LOAD DATA INPATH '/user/hive/warehouse/fruit.db/t_origin_access_stat_tbl/stat_date=$yesterday/part-r-*' INTO TABLE fruit.t_origin_access_stat_tbl PARTITION (stat_date='$yesterday')"

done
