# Quick reference

- The official Go docker image.
- The official Go docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).
- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Go | openEuler

Current Go(Golang) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Go is expressive, concise, clean, and efficient. Its concurrency mechanisms make it easy to write programs that get the most out of multicore and networked machines, while its novel type system enables flexible and modular program construction. Go compiles quickly to machine code yet has the convenience of garbage collection and the power of run-time reflection. It's a fast, statically typed, compiled language that feels like a dynamically typed, interpreted language.

Learn more on [Go website](https://go.dev/doc/).

# Supported tags and respective Dockerfile links

The tag of each Go docker image is consist of the version of Go and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.17.3-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/go/1.17.3/22.03-lts/Dockerfile)| go 1.17.3 on openEuler 22.03-LTS | amd64, arm64 |
|[1.22.5-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/go/1.22.5/22.03-lts-sp4/Dockerfile)| go 1.22.5 on openEuler 22.03-LTS-SP4 | amd64, arm64 |

# Usage

Note: `/go` is world-writable to allow flexibility in the user which runs the container (for example, in a container started with `--user 1000:1000`, running go get `github.com/example/...` into the default `$GOPATH` will succeed). While the `777` directory would be insecure on a regular host setup, there are not typically other processes or users inside the container, so this is equivalent to `700` for Docker usage, but allowing for `--user` flexibility.
  
  - Start a Go instance in your app
  
    The most straightforward way to use this image is to use a Go container as both the build and runtime environment. In your Dockerfile, writing something along the lines of the following will compile and run your project (assuming it uses go.mod for dependency management):
    
    ```
    # Dockerfile
    FROM openeuler/go:1.22.5-oe2203sp4
    
    WORKDIR /usr/src/app
    COPY go.mod go.sum ./
    RUN go mod download && go mod verify
    COPY . .
    RUN go build -v -o /usr/local/bin/app ./...
    CMD ["app"]
    ```
  
    You can then build and run the Docker image:
    ```
    docker build -t my-golang-app .
    docker run -it --rm --name my-running-app my-golang-app
    ```
        
 - Compile your app inside the Docker container

    There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:
    ```
    docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/go:1.22.5-oe2203sp4 go build -v
    ```
    This will add your current directory as a volume to the container, set the working directory to the volume, and run the command go build which will tell go to compile the project in the working directory and output the executable to myapp. Alternatively, if you have a Makefile, you can run the make command inside your container.
    ```
    docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/go:1.22.5-oe2203sp4 make
    ```

  - Cross-compile your app inside the Docker container
    If you need to compile your application for a platform other than linux/amd64 (such as windows/386):
    ```
    docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e GOOS=windows -e GOARCH=386 openeuler/go:1.22.5-oe2203sp4 go build -v
    ```
    Alternatively, you can build for multiple platforms at once:
	```bash

  # First, start a Go instance
	docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/go:1.22.5-oe2203sp4 bash

  # Second, build for multiple platforms
	for GOOS in darwin linux; do
	  for GOARCH in 386 amd64; do
	    export GOOS GOARCH
	    go build -v -o myapp-$GOOS-$GOARCH
	  done
	done
	```

- View container running logs

	```bash
	docker logs -f my-go
	```

- To get an interactive shell

	```bash
	docker exec -it my-go /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).