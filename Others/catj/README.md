# Quick reference

- The official catj docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# catj | openEuler
Current catj docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Displays JSON files in a flat format.

# Supported tags and respective Dockerfile links
The tag of each `catj` docker image is consist of the version of `catj` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/catj/1.0.4/24.03-lts-sp1/Dockerfile)| catj 1.0.4 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/catj` image from docker

	```bash
	docker pull openeuler/catj:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use catj.
    ```
    docker run -it --rm openeuler/catj:{Tag} bash
    ```

- Using catj

    catj [file]
    If no file is specified, catj reads from the standard input.

    Input:
    ```
    {
      "mappings": {
        "templates": [
          {
            "fields": {
              "mapping": {
                "norms": false,
                "type": "text",
                "fields": {
                  "keyword": {
                    "ignore_above": 256,
                    "type": "keyword"
                  }
                }
              }
            }
          }
        ]
      }
    } 
    ```
    
  Output:
  ```
  .mappings.templates[0].fields.mapping.norms = false
  .mappings.templates[0].fields.mapping.type = "text"
  .mappings.templates[0].fields.mapping.fields.keyword.ignore_above = 256
  .mappings.templates[0].fields.mapping.fields.keyword.type = "keyword"
  ```
    
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).