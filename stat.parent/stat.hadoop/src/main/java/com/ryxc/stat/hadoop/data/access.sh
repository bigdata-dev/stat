#!/bin/sh 
source /etc/profile

stat_date=`date -d"yesterday"  +"%Y-%m-%d"`
echo "job begin"
start_time=`date`
echo `date +"%Y-%m-%d %H:%M:%S"`
cd /home/ryxc/work
echo "begin accessCleaner"

sh /home/ryxc/work/stat/shell/accessCleaner.sh > /home/ryxc/work/stat/logs/accessCleaner.log.${stat_date} 2>&1

echo "end accessCleaner" 


#login
{
echo "begin login"
sh /home/ryxc/work/stat/shell/hive/app_login_stat.sh > /home/ryxc/work/stat/logs/app_login_stat.log.${stat_date} 2>&1
}&
login_pid=$!
echo $login_pid
#uv pv
{
echo "begin uv pv"
sh /home/ryxc/work/stat/shell/hive/app_uv_pv_stat.sh > /home/ryxc/work/stat/logs/app_uv_pv_stat.sh.log.${stat_date} 2>&1
}&
uv_pid=$!
echo $uv_pid
#app_one_remain_stat
{
echo "begin app_one_remain_stat"
sh /home/ryxc/work/stat/shell/hive/app_one_remain_stat.sh > /home/ryxc/work/stat/logs/app_one_remain_stat.log.${stat_date} 2>&1
}&
remain_pid=$!
echo $remain_pid

wait $login_pid
wait $uv_pid
wait $remain_pid

echo "begin kettle"
sh /home/ryxc/kettle/data-integration/kitchen.sh -rep file_rep -job J_O_app_core_view_stat -dir /access/core_view -param:stat_date=${stat_date} -level Detailed > /home/ryxc/work/stat/logs/J_O_app_core_view_stat.${stat_date} 2>&1 
echo "end kettle"

echo `date +"%Y-%m-%d %H:%M:%S"`
end_time=`date`
timeInteval= end_time-start_time
echo "timeInteval-"$[$timeInteval / 1000 / 60]" minute"
echo "job end"



