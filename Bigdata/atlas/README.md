# Quick reference

- The official atlas docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# atlas | openEuler
Current atlas docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Atlas is a scalable and extensible set of core foundational governance services – enabling enterprises to effectively and efficiently meet their compliance requirements within Hadoop and allows integration with the whole enterprise data ecosystem.

Apache Atlas provides open metadata management and governance capabilities for organizations to build a catalog of their data assets, classify and govern these assets and provide collaboration capabilities around these data assets for data scientists, analysts and the data governance team.

Learn more on [atlas website](https://atlas.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each atlas docker image is consist of the version of atlas and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.4.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/atlas/2.4.0/24.03-lts-sp1/Dockerfile)| Apache Atlas 2.4.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a atlas instance by following command:
```bash
docker run -it \
    --name atlas \
    -p 21000:21000 \
    openeuler/atlas:latest
```

Running Apache Atlas with Local Apache HBase & Apache Solr
```
bin/atlas_start.py
```

To verify if Apache Atlas server is up and running, run curl command as shown below:
```
curl -u {username}:{password} http://localhost:21000/api/atlas/admin/version
```
This will return result like
```
{"Description":"Metadata Management and Data Governance Platform over Hadoop","Version":"2.2.0","Name":"apache-atlas"}
```

Access Apache Atlas UI using a browser: `http://localhost:21000`, the default credentials: `admin / admin`.

To stop Apache Atlas, run following command:
```
bin/atlas_stop.py
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).