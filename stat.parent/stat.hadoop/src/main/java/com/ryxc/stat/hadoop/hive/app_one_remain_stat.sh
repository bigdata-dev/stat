#!/usr/bin/env bash

source /etc/profile
source /home/ryxc/stat/conf/mysqlconn.conf

function handle(){
	date=$1
	path="/user/hive/warehouse/fruit.db/t_stat_app_one_remain_tbl/stat_date=${date}/"
	hdfs dfs -test -e ${path}
	if [ $? -eq 0 ];then
		echo "begin export 4 mysql ${date}"
		sqoop export \
		--connect jdbc:mysql://$stat_ipaddr:$stat_port/$stat_dbname \
		--username $stat_uname \
		--password $stat_upwd \
		--table t_stat_app_one_remain_tbl \
		--export-dir ${path} \
		--columns appid,uv,stat_date \
		--input-fields-terminated-by '\t' \
		--input-lines-terminated-by '\n' 2>&1
		echo "end export 4 mysql ${date}"
	else
			echo "${path} is not exists"	
	fi
	
	
	
}



j=1
k=0

while [ $j -gt $k ]
do

yesterday=`date -d " $j days ago" +"%Y-%m-%d"`
let before=j+1
yesterday_before=`date -d " $before days ago" +"%Y-%m-%d"`

echo $yesterday_before
echo $yesterday

let j=j-1





hive -hivevar yester_day="${yesterday}" -hivevar yester_day_before="${yesterday_before}" -f '/home/ryxc/stat/shell/hive_script/app_one_remain_stat.hql';

#mysql export
/usr/bin/mysql -h$stat_ipaddr -P$stat_port -u$stat_uname -p$stat_upwd -D$stat_dbname -e "delete from t_stat_app_one_remain_tbl where stat_date = '${yesterday}'";
#load
handle ${yesterday}

done
