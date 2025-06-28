# Quick reference

- The official quartz docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# quartz | openEuler
Current quartz docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Quartz is a richly featured, open source job scheduling library that can be integrated within virtually any Java application - from the smallest stand-alone application to the largest e-commerce system.

Learn more about quartz on [quartz documentation](https://www.quartz-scheduler.org/documentation/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `quartz` docker image is consist of the version of `quartz` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.5.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/quartz/2.5.0/24.03-lts-sp1/Dockerfile)| quartz 2.5.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Add quartz dependency

  Maven: Add the following dependency to your `pom.xml`.
  ```
  <dependency>
      <groupId>org.quartz-scheduler</groupId>
      <artifactId>quartz</artifactId>
      <version>${quartz.version}</version>
  </dependency>
  ```

- Define a Job

  Create a class that implements `Job` interface:
  ```
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
  ```
  
- Schedule the job

  ```
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
  ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).