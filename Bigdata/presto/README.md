# Quick reference

- The official Presto docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Presto | openEuler
Current Presto docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Presto is the blazing-fast, scalable SQL query engine for modern data analytics.

Learn more on [Presto website](https://prestodb.io).

# Supported tags and respective Dockerfile links
The tag of each presto docker image is consist of the version of presto and the version of basic image. The details are as follows

| Tags                                                                                                                             | Currently |  Architectures|
|----------------------------------------------------------------------------------------------------------------------------------|--|--|
| [0.292-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/presto/0.292/24.03-lts-sp1/Dockerfile) | Presto 0.292 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/presto` image from docker

	```bash
	docker pull openeuler/presto:{Tag}
	```

- Run the container in the background

	You’ll see a series of logs as Presto starts, ending with SERVER STARTED signaling that it is ready to receive queries. We’ll use the Presto CLI to connect to Presto that we put inside the image using a separate Terminal window.

	```
	docker run --name presto openeuler/presto:{Tag}
	```

- Access the presto container and start the CLI client

    ```
    docker exec -it presto presto
    ```
  
- Execute a query against the tpch catalog
	```
	presto> SELECT
		 ->   l.returnflag,
		 ->   l.linestatus,
		 ->   sum(l.quantity)                                       AS sum_qty,
		 ->   sum(l.extendedprice)                                  AS sum_base_price,
		 ->   sum(l.extendedprice * (1 - l.discount))               AS sum_disc_price,
		 ->   sum(l.extendedprice * (1 - l.discount) * (1 + l.tax)) AS sum_charge,
		 ->   avg(l.quantity)                                       AS avg_qty,
		 ->   avg(l.extendedprice)                                  AS avg_price,
		 ->   avg(l.discount)                                       AS avg_disc,
		 ->   count(*)                                              AS count_order
		 -> FROM
		 ->   tpch.sf1.lineitem AS l
		 -> WHERE
		 ->   l.shipdate <= DATE '1998-12-01' - INTERVAL '90' DAY
		 -> GROUP BY
		 ->   l.returnflag,
		 ->   l.linestatus
		 -> ORDER BY
		 ->   l.returnflag,
		 ->   l.linestatus;
   returnflag | linestatus |   sum_qty   |    sum_base_price     |    sum_disc_price     |      sum_charge       |      avg_qty       |     avg_price     |       avg_disc       | count_order
  ------------+------------+-------------+-----------------------+-----------------------+-----------------------+--------------------+-------------------+----------------------+-------------
   A          | F          | 3.7734107E7 |  5.658655440072982E10 | 5.3758257134869644E10 |  5.590906522282741E10 | 25.522005853257337 | 38273.12973462155 |  0.04998529583846928 |     1478493
   N          | F          |    991417.0 |  1.4875047103800006E9 |  1.4130821680540998E9 |   1.469649223194377E9 | 25.516471920522985 | 38284.46776084832 |  0.05009342667421586 |       38854
   N          | O          |  7.447604E7 | 1.1170172969773982E11 | 1.0611823030760503E11 | 1.1036704387249734E11 |  25.50222676958499 | 38249.11798890821 |   0.0499965860537345 |     2920374
   R          | F          | 3.7719753E7 |   5.65680413808999E10 |  5.374129268460365E10 |  5.588961911983193E10 |  25.50579361269077 | 38250.85462609959 | 0.050009405830198916 |     1478870
  (4 rows)
	
  Query 20200625_171123_00000_xqmp4, FINISHED, 1 node
  Splits: 56 total, 56 done (100.00%)
  0:05 [6M rows, 0B] [1.1M rows/s, 0B/s]
  ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).