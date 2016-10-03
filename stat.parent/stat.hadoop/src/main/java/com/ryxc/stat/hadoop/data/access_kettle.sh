#!/usr/bin/env bash
source /etc/profile
stat_date=`date -d "yesterday" +"%Y-%m-%d"`

echo "job begin "
echo `date +"%Y-%m-%d %H:%M:%S"`
cd /opt/work

sh /home/ryxc/kettle/data-integration/kitchen.sh -rep file_rep -job J_O_access_stat -dir /access -param:stat_date=${stat_date} -level Detailed > /home/ryxc/work/stat/logs/J_O_access_stat.log.${stat_date} 2>&1

echo "job end "
echo `date +"%Y-%m-%d %H:%M:%S"`
