package com.ryxc.stat.kafka;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import kafka.consumer.Consumer;
import kafka.consumer.ConsumerConfig;
import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;
import kafka.message.MessageAndMetadata;

/**
 * Created by zenith on 2016/1/27.
 */
public class ConsumerDemo {


    public static void main(String[] args) throws IOException {

        String topic="rechargeStat";
        //准备配置信息
        Properties prop=new Properties();
        prop.load(ConsumerDemo.class.getClassLoader().getResourceAsStream("consumer.properties"));

        //创建消费者连接对象
        ConsumerConnector consumerConnector
                = Consumer.createJavaConsumerConnector(new ConsumerConfig(prop));

        //topicCountMap 的key是装载要消费的topic的集合，value是对于topic要使用的消费者的个数
        Map<String,Integer> topicCountMap=new HashMap<>();
        topicCountMap.put(topic,2);
        //根据topic和消费的数目创建消费流。
        Map<String, List<KafkaStream<byte[], byte[]>>> messageStreams =
                consumerConnector.createMessageStreams(topicCountMap);
        //获取topic为hello的流的list 这里的消费流数和topicmap里的一致
        List<KafkaStream<byte[], byte[]>> kafkaStreams = messageStreams.get(topic);

        //根据消费者个数创建线程进行消费消息
        for (KafkaStream<byte[], byte[]> kafkaStream:kafkaStreams){
            new Thread(new ConsumeData(kafkaStream)).start();
        }

    }


 static  class ConsumeData implements Runnable{

        public ConsumeData(KafkaStream<byte[], byte[]> kafkaStream) {
            this.kafkaStream = kafkaStream;
        }

        private KafkaStream<byte[], byte[]> kafkaStream;


        @Override
        public void run() {
            ConsumerIterator<byte[], byte[]> iterator = kafkaStream.iterator();
            while (iterator.hasNext()){
                MessageAndMetadata<byte[], byte[]> next = iterator.next();

                System.out.println(String.format("key:%s,message:%s,offset:%s,partition:%s,theadId:%s",
                        next.key()==null?"":new String(next.key())
                        ,new String(next.message()),next.offset(),next.partition()
                        ,Thread.currentThread().getId()
                        ));
            }


        }
    }
}
