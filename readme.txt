stat.parent 为源代码工程项目
work 为生产部署目录

一.互联网数据产生
1. 初始化redis数据  （ip城市映射）
nohup java -cp stat.hadoop-0.0.1-SNAPSHOT-jar-with-dependencies.jar  com.ryxc.stat.hadoop.data.InitIP4Redis /home/ryxc/work/stat/jar/ip.data &
2. 产生日志
nohup java -cp /home/ryxc/stat/jar/stat.hadoop-0.0.1-SNAPSHOT-jar-with-dependencies.jar  com.ryxc.stat.hadoop.data.Creator &


二.日志采集
1.启动日志产生机器的flume
nohup bin/flume-ng agent --conf conf/ --conf-file conf/exec_source_avro_sink.conf --name access -Dflume.root.logger=INFO,console &
2.启动flume的avro，收集flume到hdfs
启动：(需要在hadoop的gateway环境下启动)
nohup bin/flume-ng agent --conf conf/ --conf-file conf/avro_source_hdfs_sink.conf --name access -Dflume.root.logger=INFO,console &

三.使用shell脚本调度 (使用shell脚本将整个项目流程串起来)
sh access.sh
该脚本分为三个阶段：
第一阶段：清洗数据         accessCleaner.sh  (hdfs -> hive表)
第二阶段：统计登陆uvpv   app_login_stat.sh  (hive表 -> hive表 -> mysql表)
                 统计次日留存uv  app_one_remain_stat.sh (hive表 -> hive表 -> mysql表)
                 统计uvpv    app_one_remain_stat.sh  (hive表 -> hive表 -> mysql表)
第三阶段：使用kettle将第二阶段各指标整合到mysql汇总表中 (mysql表 -> mysql表)   
sh /home/ryxc/kettle/data-integration/kitchen.sh -rep file_rep -job J_O_app_core_view_stat -dir /access/core_view -param:stat_date=${stat_date} -level Detailed > /home/ryxc/work/stat/logs/J_O_app_core_view_stat.${stat_date} 2>&1 

四.使用kettle脚本调度 (使用kettle将整个项目流程串起来)
sh access_kettle.sh