package com.ryxc.stat.hadoop.mr;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.log4j.Logger;


public class AccessLogCleaner {

	private static Logger  logger = Logger.getLogger(AccessLogCleaner.class);
	
	public static void main(String[] args) throws Exception {
		
		if(args.length<2){
			logger.error("args need at least 2");
		}
		
		String output_path = args[args.length-1];
		
		Configuration conf = new Configuration();
		
		
		Job job = Job.getInstance(conf, "accessLogCleaner");
		
		job.setJarByClass(AccessLogCleaner.class);
		job.setMapperClass(AccessLogCleanerMapper.class);
		job.setMapOutputKeyClass(NullWritable.class);
		job.setMapOutputValueClass(Text.class);
		
		//遍历用户的输入作为输入参数
		for (int i = 0; i < args.length-1; i++) {
			FileInputFormat.addInputPath(job, new Path(args[i]));
		}
		
		//将最后参数作为输出参数
		FileOutputFormat.setOutputPath(job, new Path(output_path));
		//提交job并等job ok后系统推出
		System.exit(job.waitForCompletion(true)?0:1);
	}
}
