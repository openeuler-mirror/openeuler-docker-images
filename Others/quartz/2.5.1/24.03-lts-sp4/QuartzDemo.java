package com.example;

import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

public class QuartzDemo {
    public static void main(String[] args) {
        try {
            Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();

            JobDetail job = JobBuilder.newJob(SimpleJob.class)
                    .withIdentity("job1", "group1")
                    .usingJobData("jobParam", "Hello, Quartz!")
                    .build();

            Trigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity("trigger1", "group1")
                    .startNow()
                    .withSchedule(SimpleScheduleBuilder.simpleSchedule()
                            .withIntervalInSeconds(5)
                            .repeatForever())
                    .build();

            scheduler.scheduleJob(job, trigger);

            scheduler.start();

            while (true) {
                Thread.sleep(1000);
            }

        } catch (SchedulerException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}