# Quick reference

- The official Apache Drill docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Apache Drill | openEuler
Current Apache Drill docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Drill is a distributed MPP query layer that supports SQL and alternative query languages against NoSQL and Hadoop data storage systems. It was inspired in part by Google's Dremel.

Learn more on [Apache Drill Documentation](https://drill.apache.org/docs/).

# Supported tags and respective Dockerfile links
The tag of each `drill` docker image is consist of the version of `drill` and the version of basic image. The details are as follows

| Tag                                                                                                                               | Currently                                      | Architectures |
|-----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|---------------|
| [1.21.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/drill/1.21.2/24.03-lts-sp1/Dockerfile) | Apache Drill 1.21.2 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/drill` image from docker

	```bash
	docker pull openeuler/drill:{Tag}
	```

- Run with an interactive shell

    Run the following command to launch an interactive Apache Drill container and expose the Web UI port `8047` to you host:
    ```
    docker run -it --rm -p 8047:8047 openeuler/drill
    ```
  
    When the container starts, you'll see the sqlline shell prompt like:
    ```
    apache drill>
    ```
  
    You can immediately sun SQL queries inside the shell, for example:
    ```
    apache drill> SELECT * FROM cp.`employee.json` LIMIT 5;
    +-------------+-----------------+------------+-----------+-------------+------------------------+----------+---------------+------------+-----------------------+---------+---------------+------------------+----------------+--------+-------------------+----------+
    | employee_id |    full_name    | first_name | last_name | position_id |     position_title     | store_id | department_id | birth_date |       hire_date       | salary  | supervisor_id | education_level  | marital_status | gender |  management_role  | end_date |
    +-------------+-----------------+------------+-----------+-------------+------------------------+----------+---------------+------------+-----------------------+---------+---------------+------------------+----------------+--------+-------------------+----------+
    | 1           | Sheri Nowmer    | Sheri      | Nowmer    | 1           | President              | 0        | 1             | 1961-08-26 | 1994-12-01 00:00:00.0 | 80000.0 | 0             | Graduate Degree  | S              | F      | Senior Management | null     |
    | 2           | Derrick Whelply | Derrick    | Whelply   | 2           | VP Country Manager     | 0        | 1             | 1915-07-03 | 1994-12-01 00:00:00.0 | 40000.0 | 1             | Graduate Degree  | M              | M      | Senior Management | null     |
    | 4           | Michael Spence  | Michael    | Spence    | 2           | VP Country Manager     | 0        | 1             | 1969-06-20 | 1998-01-01 00:00:00.0 | 40000.0 | 1             | Graduate Degree  | S              | M      | Senior Management | null     |
    | 5           | Maya Gutierrez  | Maya       | Gutierrez | 2           | VP Country Manager     | 0        | 1             | 1951-05-10 | 1998-01-01 00:00:00.0 | 35000.0 | 1             | Bachelors Degree | M              | F      | Senior Management | null     |
    | 6           | Roberta Damstra | Roberta    | Damstra   | 3           | VP Information Systems | 0        | 2             | 1942-10-08 | 1994-12-01 00:00:00.0 | 25000.0 | 1             | Bachelors Degree | M              | F      | Senior Management | null     |
    +-------------+-----------------+------------+-----------+-------------+------------------------+----------+---------------+------------+-----------------------+---------+---------------+------------------+----------------+--------+-------------------+----------+
    5 rows selected (3.456 seconds)
    ```
    This will return sample rows from the `emploee.json` example file.

- Access the Drill Web Console

    By default, Apache Drill's Web Console runs at:
    ```
    http://localhost:8047
    ```
    
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).