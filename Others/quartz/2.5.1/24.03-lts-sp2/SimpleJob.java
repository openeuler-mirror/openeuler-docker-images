package com.example;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class SimpleJob implements Job {
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        System.out.println("SimpleJob is executed at: " + new java.util.Date());

        JobDataMap dataMap = context.getJobDetail().getJobDataMap();
        String jobParam = dataMap.getString("jobParam");
        if(jobParam != null) {
            System.out.println("Job parameter: " + jobParam);
        }
    }
}