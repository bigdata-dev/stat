use fruit;

insert overwrite table t_stat_app_one_remain_tbl partition ( stat_date ="${hivevar:yester_day}" )
select a.appid,count(1),"${hivevar:yester_day}" from
(select appid,mid from t_origin_access_stat_tbl where stat_date="${hivevar:yester_day_before}" group by appid,mid)a
inner join
(select appid,mid from t_origin_access_stat_tbl where stat_date="${hivevar:yester_day}" group by appid,mid)b
on a.mid=b.mid and a.appid=b.appid
group by a.appid;


insert into table t_stat_app_one_remain_tbl partition ( stat_date ="${hivevar:yester_day}" )
select -1,count(1),"${hivevar:yester_day}" from
(select mid from t_origin_access_stat_tbl where stat_date="${hivevar:yester_day_before}" group by mid)a
inner join
(select mid from t_origin_access_stat_tbl where stat_date="${hivevar:yester_day}" group by mid)b
on a.mid=b.mid