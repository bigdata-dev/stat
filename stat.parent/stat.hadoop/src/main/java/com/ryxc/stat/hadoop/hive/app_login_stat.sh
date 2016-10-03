#!/usr/bin/env bash
source /etc/profile
#引入mysql连接
source /home/ryxc/work/stat/conf/mysqlconn.conf
#define hadoop export mysql method
function handle(){
        date=$1
        path="/user/hive/warehouse/fruit.db/t_stat_app_login_tbl/stat_date=${date}/"
        hdfs dfs -test -e ${path}
        if [ $? -eq 0 ];then    
            echo "开始执行exp4mysql ${date}"
               sqoop export \
	       --connect jdbc:mysql://$stat_ipaddr:$stat_port/$stat_dbname \
	       --username $stat_uname \
	       --password $stat_upwd \
	       --table t_stat_app_login_tbl  \
	       --export-dir ${path} \
	    --columns appid,uv,pv,stat_date \
	       --input-fields-terminated-by '\t' \
	       --input-lines-terminated-by '\n' 2>&1
            echo "结束执行exp4mysql ${date}"
        else
            echo "${path} is not exits"
        fi  
} 

j=1
k=0
while [ $j -gt $k ]
do
echo $j
yesterday=`date -d" $j days ago " +"%Y-%m-%d"`
echo $yesterday

let j=j-1
#把let j=j-1方最后会影响执行的结果状态码 如果放最后就是 执行结果为1

#分appid的
echo `hive -e "use fruit;INSERT OVERWRITE TABLE t_stat_app_login_tbl PARTITION (stat_date='$yesterday') select appid,count(distinct userid),count(1),'$yesterday' from t_origin_access_stat_tbl where stat_date = '$yesterday' and loginType=1 group by appid"`
#总的统计
echo `hive -e "use fruit;INSERT INTO TABLE t_stat_app_login_tbl PARTITION (stat_date='$yesterday') select -1,count(distinct userid),count(1),'$yesterday' from t_origin_access_stat_tbl where stat_date = '$yesterday' and loginType=1"`
#导入mysql过程
#delete
/usr/bin/mysql -h$stat_ipaddr -P$stat_port -u$stat_uname -p$stat_upwd -D$stat_dbname -e "delete from t_stat_app_login_tbl where stat_date = '${yesterday}'";

#load
handle ${yesterday}

done
