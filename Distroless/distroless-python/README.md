# Quick reference

- The official distroless-python docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-python | openEuler
This image contains a minimal Linux, python runtime.

Distroless Python images are minimal container images designed to run Python applications with a reduced attack surface. They contain only the necessary Python runtime and its dependencies, excluding unnecessary components like shells and package managers, which are typically found in standard Linux distributions. This approach enhances security and simplifies dependency management. 

# Supported tags and respective Dockerfile links
The tag details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.11.6-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-python/3.11.6/24.03-lts/Distrofile)| python 3.11.6 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
**Create a Dockerfile in your python project**
```
# Dockerfile

FROM openeuler/distroless-python:3.11.6-oe2403lts
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

# Specify command to run when container starts
CMD ["python3", "./your-script.py"]
```
Then, run the commands to build and run the Docker image:
```
$ docker build -t my-python-app .
$ docker run -it --rm --name my-running-app my-python-app
```

**Running a Single Python Script (Standard Library Import Test)**

For quick testing of Python scripts, particularly to verify standard library availability in the distroless environment, you can directly mount and execute your script. 
Here's an example using he standard library import test script [import.py](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-python/example/import.py):   

```
docker run -it --rm \
  -v "$PWD/import.py":/usr/src/app/import.py \
  -w /usr/src/app \
  openeuler/distroless-python:3.11.6-oe2403lts \
  python3 import.py
```

Expected output:
```
......
Imported syslog
Imported termios
Imported unicodedata
Imported xxlimited
Imported xxlimited_35
Imported zlib
Import everything test successfully!
```

# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).