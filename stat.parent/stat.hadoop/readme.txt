kettle工作转换+脚本调度

linux kettle部署
1.配置
 export KETTLE_HOME=/opt/data-integration
2. 配置日志服务：
 [file:/home/ryxc/kettle/data-integration/./system/osgi/log4j.xml].
java.io.FileNotFoundException: /home/ryxc/kettle/data-integration/./system/osgi/log4j.xml (No such file or directory)

执行
mkdir /home/ryxc/kettle/data-integration/./system/osgi/
cp /home/ryxc/kettle/data-integration/classes/log4j.xml /home/ryxc/kettle/data-integration/./system/osgi/
 
3. 上传mysql驱动包 到/home/ryxc/kettle/data-integration/lib目录下

kettle整合维度指标
sh /home/ryxc/kettle/data-integration/kitchen.sh -rep file_rep -job J_O_app_core_view_stat -dir /access/core_view -param:stat_date=2016-10-03 -level Detailed > /home/ryxc/work/stat/logs/J_O_app_core_view_stat.2016-10-03 2>&1 

脚本调度
sh access.sh