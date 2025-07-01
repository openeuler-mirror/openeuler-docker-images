# Quick reference

- The official uWSGI docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# uWSGI | openEuler
Current uWSGI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

uWSGI is an open source software application that "aims at developing a full stack for building hosting services". It is named after the Web Server Gateway Interface (WSGI), which was the first plugin supported by the project. uWSGI is maintained by the Italian-based software company unbit.

# Supported tags and respective Dockerfile links
The tag of each `uwsgi` docker image is consist of the version of `uwsgi` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                               | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|---------------|
| [2.0.29-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/uwsgi/2.0.29/24.03-lts-sp1/Dockerfile) | uWSGI 2.0.29 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/uwsgi` image from docker

	```bash
	docker pull openeuler/uwsgi:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to use uwsgi.
    ```
    docker run -it --rm openeuler/uwsgi:{Tag} bash
    ```

- Prepare tne Application

    Create Working Directory
    ```
    mkdir /app
    ```

    Create WSGI Entry File(`myapp.py`)
    ```
    # /app/myapp.py
    def application(environ, start_response):
        status = '200 OK'
        headers = [('Content-type', 'text/plain; charset=utf-8')]
        start_response(status, headers)
        return [b"Hello World from uWSGI!"]
    ```

- Set Up Non-Root User & Permissions
    
    Create Dedicated User & Group
    ```
    groupadd -r uwsgi_group
    useradd -r -g uwsgi_group -d /app -s /bin/false uwsgi_user
    ```
    Set Proper Permissions
    ```
    chown -R uwsgi_user:uwsgi_group /app
    chmod -R 755 /app
    ```
  
- Start uWSGI with Recommended Parameters

    Basic Command
    ```
    ./uwsgi \
      --http-socket :8000 \
      --processes 4 \
      --threads 2 \
      --chdir /app \
      --wsgi-file myapp.py \
      --master \
      --enable-threads \
      --buffer-size 32768 \
      --uid uwsgi_user \
      --gid uwsgi_group
    ```
  
    **Parameters Explanation**:

    | Parameter              | Description                              | Recommended Value                                |
    |------------------------|------------------------------------------|--------------------------------------------------|
    | `--http-socket :8000`  | Bind to TCP port 8000 (HTTP mode)        | `:8000` (or any available port)                  |
    | `--processes 4`        | Number of worker processes               | `4` (adjust based on CPU cores)                  |
    | `--threads 2`          | 	Threads per worker                      | `2` (for concurrent requests)                    |
    | `--chdir /app`         | Working directory                        | `/app` (where `myapp.py` resides)                |
    | `--wsgi-file myapp.py` | WSGI application entry file              | `myapp.py` (must contain `application` callable) |
    | `--master`             | Enable master process (manages workers)	 | Always enable in production                      |
    | `--enable-threads`     | Allow threading in workers               | 	Required for threaded apps                      |
    | `--buffer-size 32768`  | Request buffer size (bytes)              | `32768` (32KB, adjust if needed)                 |
    | `--uid uwsgi_user`     | Run as non-root user                     | Dedicated user (e.g., `uwsgi_user`)              |
    | `--gid uwsgi_group`    | 	Run with non-root group                 | Dedicated group (e.g., `uwsgi_group`)            |

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).