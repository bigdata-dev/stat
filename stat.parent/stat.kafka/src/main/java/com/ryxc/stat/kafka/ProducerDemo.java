package com.ryxc.stat.kafka;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;

/**
 * Created by zenith on 2016/1/27.
 */
public class ProducerDemo {


	static Map<Integer,Integer> appid=new HashMap<Integer, Integer>();
   
    static Map<Integer,String> param=new HashMap<Integer, String>();



    private static void Initdata(){

        //web
        appid.put(0,1000);
        //android
        appid.put(1,1001);
        //ios
        appid.put(2,1002);
        //ipad
        appid.put(3,1003);


        param.put(0,"{\"ugctype\":\"consumer\",\"userId\":\"10022\",\"coin\":\"50\",\"number\":\"2\"}");
        param.put(1,"{\"ugctype\":\"consumer\",\"userId\":\"20202\",\"coin\":\"20\",\"number\":\"3\"}");
        param.put(2,"{\"ugctype\":\"consumer\",\"userId\":\"40604\",\"coin\":\"10\",\"number\":\"2\"}");
        param.put(3,"{\"ugctype\":\"recharge\",\"userId\":\"20202\",\"rmb\":\"50\",\"number\":\"10\"}");
        param.put(4,"{\"ugctype\":\"recharge\",\"userId\":\"40604\",\"rmb\":\"100\",\"number\":\"20\"}");
        param.put(5,"{\"ugctype\":\"recharge\",\"userId\":\"10022\",\"rmb\":\"100\",\"number\":\"20\"}");

    }
	
	
    public static void main(String[] args) throws IOException {
    	
    	Initdata();
        Random r=new Random();
        String _param;
        Integer _appid;

        
        
        
      //准备配置文件
        Properties prop=new Properties();
        prop.load(ProducerDemo.class.getClassLoader().getResourceAsStream("producer.properties"));


        //创建生产者对象
        Producer<String,String> stringProducer= new Producer<>(new ProducerConfig(prop));
        
        
        while (true) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            _appid=appid.get(r.nextInt(4));
            _param= param.get(r.nextInt(6));
            
            //appid	param	time
            stringProducer.send(new KeyedMessage<String, String>("rechargeStat", String.format("%s\t%s\t%s"
            		,_appid,_param,new Date().getTime())));
        }
        //关闭连接
        //stringProducer.close();

    }

}
