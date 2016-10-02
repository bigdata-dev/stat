

CREATE DATABASE IF NOT EXISTS fruit COMMENT '统计库';
use fruit;

-- ----------------------------
-- Table structure for t_stat_app_login_tbl
-- ----------------------------
DROP TABLE IF EXISTS t_stat_app_login_tbl;
CREATE TABLE t_stat_app_login_tbl (
appid int COMMENT 'app维度登录的appid',
uv int COMMENT 'app维度登录的uv',
pv int COMMENT 'app维度登录的pv',
datecol STRING COMMENT 'datecol')
COMMENT 'app维度登录的统计表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- ----------------------------
-- Table structure for t_stat_app_one_remain_tbl
-- ----------------------------
DROP TABLE IF EXISTS t_stat_app_one_remain_tbl;
CREATE TABLE t_stat_app_one_remain_tbl (
appid int COMMENT 'app维度一日留存的appid',
uv int COMMENT 'app维度一日留存的uv',
datecol STRING COMMENT 'datecol')
COMMENT 'app维度一日留存的统计表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- ----------------------------
-- Table structure for t_stat_app_reg_tbl
-- ----------------------------
DROP TABLE IF EXISTS t_stat_app_reg_tbl;
CREATE TABLE t_stat_app_reg_tbl (
appid int COMMENT 'app维度注册的appid',
uv int COMMENT 'app维度注册的uv',
datecol STRING COMMENT 'datecol')
COMMENT 'app维度注册的统计表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- ----------------------------
-- Table structure for t_stat_app_seven_remain_tbl
-- ----------------------------
DROP TABLE IF EXISTS t_stat_app_seven_remain_tbl;
CREATE TABLE t_stat_app_seven_remain_tbl (
appid int COMMENT 'app维度七日留存的appid',
uv int COMMENT 'app维度七日留存的uv',
datecol STRING COMMENT 'datecol')
COMMENT 'app维度七日留存的统计表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- ----------------------------
-- Table structure for t_stat_app_uv_tbl
-- ----------------------------
DROP TABLE IF EXISTS t_stat_app_uv_tbl;
CREATE TABLE t_stat_app_uv_tbl (
appid int COMMENT 'app维度uv统计的appid',
uv int COMMENT 'app维度uv统计的uv',
pv int COMMENT 'app维度uv统计的pv',
datecol STRING COMMENT 'datecol')
COMMENT 'app维度uv统计的统计表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;



DROP TABLE IF EXISTS t_origin_access_stat_tbl;
CREATE TABLE t_origin_access_stat_tbl (
appid int COMMENT 'appid',
ip string COMMENT 'ip',
province string COMMENT 'province',
city string COMMENT 'city',
mid string COMMENT '机器码id',
userid int COMMENT '用户的id',
loginType int COMMENT '登录类型',
request string COMMENT '请求的方法',
method string COMMENT '请求的方法',
path string COMMENT '请求的地址',
httpVersion string COMMENT 'http的版本',
status string COMMENT '响应状态码',
httpReferer string COMMENT '上一跳的url',
userAgent string COMMENT 'userAgent',
ieType string COMMENT 'ie的类型',
time int COMMENT '时间戳',
dateTime string COMMENT '时间字符串')
COMMENT '原始access数据表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE ;


DROP TABLE IF EXISTS t_origin_ugc_head_stat_tbl;
CREATE TABLE t_origin_ugc_head_stat_tbl (
appid int COMMENT 'appid',
ip string COMMENT 'ip',
province string COMMENT 'province',
city string COMMENT 'city',
mid string COMMENT '机器码id',
userid int COMMENT '用户的id',
param string COMMENT '参数体',
seid string COMMENT 'ugc序列一致号',
time int COMMENT '时间戳',
dateTime string COMMENT '时间字符串')
COMMENT '原始ugchead数据表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE ;


DROP TABLE IF EXISTS t_origin_ugc_tail_stat_tbl;
CREATE TABLE t_origin_ugc_tail_stat_tbl (
appid int COMMENT 'appid',
ip string COMMENT 'ip',
province string COMMENT 'province',
city string COMMENT 'city',
mid string COMMENT '机器码id',
userid int COMMENT '用户的id',
param string COMMENT '参数体',
seid string COMMENT 'ugc序列一致号',
time int COMMENT '时间戳',
dateTime string COMMENT '时间字符串')
COMMENT '原始ugctail数据表'
PARTITIONED BY(stat_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE ;
