package com.ryxc.stat.hadoop.utils;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class RedisUtils {
	
	private static  JedisPool jedisPool = null;
	
	//获取链接
	public static synchronized Jedis getJedis(){
		if(jedisPool==null){
			JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
			//指定连接池中最大空闲连接数
			jedisPoolConfig.setMaxIdle(10);
			//链接池中创建的最大连接数
			jedisPoolConfig.setMaxTotal(100);
			//设置创建链接的超时时间
			jedisPoolConfig.setMaxWaitMillis(10000);
			//表示连接池在创建链接的时候会先测试一下链接是否可用，这样可以保证连接池中的链接都可用的
			//String host = "hh166.all123.net";
			String host = "192.168.116.166";
			jedisPool = new JedisPool(jedisPoolConfig, host, 6379,30000, "redis");
		}
		return jedisPool.getResource();
	}
	
	//关闭链接
	public static void closeResource(Jedis jedis){
		if(null !=jedis){
			jedis.close();
		}
	}

}
