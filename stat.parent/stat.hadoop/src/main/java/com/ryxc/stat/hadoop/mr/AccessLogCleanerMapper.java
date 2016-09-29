package com.ryxc.stat.hadoop.mr;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.log4j.Logger;

import redis.clients.jedis.Jedis;

import com.ryxc.stat.hadoop.utils.RedisUtils;
import com.ryxc.stat.hadoop.utils.UserAgent;
import com.ryxc.stat.hadoop.utils.UserAgentUtil;

public class AccessLogCleanerMapper extends Mapper<LongWritable, Text, NullWritable, Text>{
	
	private  Logger logger = Logger.getLogger(AccessLogCleanerMapper.class);
	
	private String [] strs = null;
	private Integer appId = 0;
	private Integer userId = 0;
	private Integer loginType = 0;
	private Integer status = 0;
	private Long time = 0l;
	
	private String [] requestStr = null;
	
	private Jedis jedis;
	private DateFormat dateFormat;
	private String ipInfo;
	private String [] ipStrs;
	private Text result = new Text();
	
	
	@Override
	protected void setup(
			Mapper<LongWritable, Text, NullWritable, Text>.Context context)
			throws IOException, InterruptedException {
		jedis = RedisUtils.getJedis();
		dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	}
	

	@Override
	protected void map(LongWritable key, Text value,
			Mapper<LongWritable, Text, NullWritable, Text>.Context context)
			throws IOException, InterruptedException {
		//appid	ip	mid	userid	login_type	request		status	http_referer	user_agent	time
		int len = value.toString().split("\t").length;
		if(null!=value&&value.toString().split("\t").length==10){
			strs = value.toString().split("\t");
			
			try {
				appId = Integer.parseInt(strs[0]);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
			}
			
			try {
				userId = Integer.parseInt(strs[3]);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
			}
			
			try {
				loginType = Integer.parseInt(strs[4]);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
			}
			try {
				status = Integer.parseInt(strs[6]);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
			}
			try {
				time = Long.parseLong(strs[9]);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
			}
			
		 	AccessLog accessLog = new AccessLog(appId, strs[1], strs[2], userId, loginType, strs[5], status, strs[7], strs[8], time);
		   
		 	//解析userAgent
		 	UserAgent userAgent = UserAgentUtil.getUserAgent(accessLog.getUserAgent());
		 	if(null!=userAgent){
		 		accessLog.setIeType(userAgent.getBrowserType());
		 	}
		 	
		 	//解析request 
		 	if(null!=accessLog&&accessLog.getRequest().split(" ").length==3){
		 		requestStr = accessLog.getRequest().split(" ");
		 		accessLog.setMethod(requestStr[0]);
		 		accessLog.setPath(requestStr[1]);
		 		accessLog.setHttpVersion(requestStr[2]);
		 	}
		 	
		 	//解析IP
		 	ipInfo = jedis.get("ip:"+accessLog.getIp());
		 	if(null!=ipInfo&&ipInfo.split("\t").length==2){
		 		ipStrs = ipInfo.split("\t");
		 		accessLog.setProvice(ipStrs[0]);
		 		accessLog.setCity(ipStrs[1]);
		 	}
		 	
		 	//解析时间
		 	accessLog.setDateTime(dateFormat.format(new Date(accessLog.getTime())));
		    result.set(accessLog.toString());
		    context.write(NullWritable.get(), result);
		}
	}
	
	@Override
	protected void cleanup(
			Mapper<LongWritable, Text, NullWritable, Text>.Context context)
			throws IOException, InterruptedException {
		jedis = null;
		dateFormat = null;
	}

}
