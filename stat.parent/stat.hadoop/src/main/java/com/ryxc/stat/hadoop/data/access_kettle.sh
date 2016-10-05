#!/usr/bin/env bash
source ~/.bash_profile
stat_date=`date -d "yesterday" +"%Y-%m-%d"`

echo "job begin "
echo `date +"%Y-%m-%d %H:%M:%S"`
echo "stat_data"${stat_date}
start_time=`date +%s`

sh /home/ryxc/kettle/data-integration/kitchen.sh -rep file_rep -job J_O_access_stat -dir /access -param:stat_date=${stat_date} -level Detailed > /home/ryxc/work/stat/logs/J_O_access_stat.log.${stat_date} 2>&1

end_time=`date +%s`
timeInteval=$[ end_time - start_time ]
echo "timeInteval-"$timeInteval" m"
echo `date +"%Y-%m-%d %H:%M:%S"`
echo "job end "
echo "============================================================"
