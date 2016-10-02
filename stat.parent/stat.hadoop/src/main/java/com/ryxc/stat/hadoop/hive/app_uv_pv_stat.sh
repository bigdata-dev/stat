#!/bin/sh
source /etc/profile
#通用的属性配置
source /home/ryxc/stat/conf/mysqlconn.conf

#将hdfs的hive表数据导出到mysql对应的表中 供前台查看和展示
function handle(){
	date=$1
	path="/user/hive/warehouse/fruit.db/t_stat_app_uv_tbl/stat_date=$date/"
	hdfs dfs -test -e ${path}
	if [ $? -eq 0 ];then
		echo "开始执行导数据到mysql ${path}"
			sqoop export \
		--connect jdbc:mysql://$stat_ipaddr:$stat_port/$stat_dbname \
		--username $stat_uname \
		--password $stat_upwd \
		--table t_stat_app_uv_tbl  \
		--export-dir ${path} \
		--columns appid,uv,pv,stat_date \
		--input-fields-terminated-by '\t' \
		--input-lines-terminated-by '\n' 2>&1
		
	else
		echo "${path} is not exists"
	fi
	
	
}

#起始变量
j=1
#结束变量
k=0

while [ $j -gt $k ]
do
	
yesterday=`date -d"$j days ago"  +"%Y-%m-%d"`
echo $yesterday
let j=j-1

#分appid的统计uv和pv 从access表计算结果并插入到t_stat_app_uv_tbl中分appid
hive -e "use fruit;INSERT OVERWRITE TABLE t_stat_app_uv_tbl PARTITION (stat_date='$yesterday') select appid,count(distinct mid),count(1),'$yesterday' from t_origin_access_stat_tbl where stat_date='$yesterday' group by appid"
#不分appid的统计 从access表计算结果并插入到t_stat_app_uv_tbl中 不 分appid
hive -e "use fruit;INSERT INTO TABLE t_stat_app_uv_tbl PARTITION (stat_date='$yesterday') select -1,count(distinct mid),count(1),'$yesterday' from t_origin_access_stat_tbl where stat_date='$yesterday'"

#导数据前将mysql的当前的数据删除掉，防止重复的从hdfs的hive表导出到mysql数据表中
echo "开始执行导数据前将mysql的当前的数据删除掉"
/usr/bin/mysql -h$stat_ipaddr -P$stat_port -u$stat_uname -p$stat_upwd -D$stat_dbname -e "delete from t_stat_app_uv_tbl where stat_date='${yesterday}'"

#sqoop 执行导数据
handle ${yesterday}

done

