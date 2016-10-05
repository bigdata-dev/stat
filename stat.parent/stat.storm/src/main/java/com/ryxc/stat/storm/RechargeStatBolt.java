package com.ryxc.stat.storm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

import backtype.storm.Config;
import backtype.storm.Constants;
import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichBolt;
import backtype.storm.tuple.Tuple;

import com.alibaba.fastjson.JSONObject;

public class RechargeStatBolt  extends BaseRichBolt{

	private ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, Double>> appIdUserMap=new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer,Double>>();
	private OutputCollector _collector;
	private String log;
	private String[] logs;
	private String param;
	private Integer userId=0;
	private Integer appId=0;
	private Double rmb=0d;
	private Logger logger;
	private DateFormat dateformat;
	private Connection connection;
	private Integer num=0;
	private Double total=0d;
	
	@Override
	public Map<String, Object> getComponentConfiguration() {
		
		Map<String,Object> map=new HashMap<String, Object>();
		//特殊的定时器配置
		map.put(Config.TOPOLOGY_TICK_TUPLE_FREQ_SECS, 20);
		return map;
		
	}
	
	@Override
	public void prepare(Map stormConf, TopologyContext context,
			OutputCollector collector) {
		// TODO Auto-generated method stub
		this._collector=collector;
		dateformat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		logger=Logger.getLogger(RechargeStatBolt.class);
		try {
			Properties prop=new Properties();
			prop.load(RechargeStatBolt.class.getClassLoader().getResourceAsStream("jdbc.properties"));
			
			Class.forName("com.mysql.jdbc.Driver");
			connection=DriverManager.getConnection(prop.getProperty("mysql.url"),
					prop.getProperty("mysql.username"), prop.getProperty("mysql.password"));
			
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}

	@Override
	public void execute(Tuple input) {
		// TODO Auto-generated method stub
		//{\"ugctype\":\"recharge\",\"userId\":\"10022\",\"rmb\":\"100\",\"number\":\"20\"}
		////appid	param	time
		
		//系统每隔20秒发送一次
		//统计数据的信号
		if(input.getSourceComponent().equals(Constants.SYSTEM_COMPONENT_ID)){
		try {
			String statTime=dateformat.format(new Date());
			for (Integer appId : appIdUserMap.keySet()) {
				//num=0;
				num=appIdUserMap.get(appId).size();
				total=0d;
				for (Double rmb : appIdUserMap.get(appId).values()) {
					total=total+rmb;
				}
				String sql="insert into t_view_app_recharge_online_tbl(appid,user_num,rmb,stat_time) values (?,?,?,?);";
				PreparedStatement ps=connection.prepareStatement(sql);
				ps.setInt(1, appId);
				ps.setInt(2, num);
				ps.setDouble(3, total);
				ps.setString(4, statTime);
				ps.executeUpdate();
				ps.close();
			}
			appIdUserMap.clear();
			
			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
			
			
			
			
			
			
		}else{
			_collector.ack(input);
			//组装数据
			log=input.getStringByField("str");
			if(null!=log){
				//分割日志信息
				logs=log.split("\t");
				if(logs.length==3){
					param=logs[1];
					if(null!=param){
						//json转化日志里面的param
						JSONObject json=JSONObject.parseObject(param);
						//过滤 只计算ugctype=recharge的用户日志
						if(json!=null&&json.getString("ugctype").equals("recharge")){
							try {
								appId=Integer.parseInt(logs[0]);
							} catch (Exception e) {
								logger.error(e.getMessage());
							}
							try {
								userId=json.getInteger("userId");
							} catch (Exception e) {
								logger.error(e.getMessage());
							}
							try {
								rmb=json.getDouble("rmb");
							} catch (Exception e) {
								logger.error(e.getMessage());
							}
							ConcurrentHashMap<Integer, Double> concurrentHashMap;
							
							//map中不含有此appid
							if(!appIdUserMap.containsKey(appId)){
								concurrentHashMap=new ConcurrentHashMap<Integer, Double>();
								concurrentHashMap.put(userId, rmb);
								
							}else{
								//map中含有appid 
								concurrentHashMap=appIdUserMap.get(appId);
								//该用户userId在此appid里充值过  充值金额叠加
								if(concurrentHashMap.containsKey(userId)){
									concurrentHashMap.put(userId, concurrentHashMap.get(userId)+rmb);
								}else{
									//没有充值过就增加此次的充值金额
									concurrentHashMap.put(userId,rmb);
								}
							}
							//更新appIdUserMap
							appIdUserMap.put(appId, concurrentHashMap);
							
							
							
							
						}
						
					}
					
					
					
				}
			
			}
			
			
			
		}
		
		
		
		
		
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		
	}

}
