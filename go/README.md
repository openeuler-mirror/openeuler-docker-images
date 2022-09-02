#golang


# Quick reference

- The official golang docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/golang:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d openeuler/golang:1.17.3
```

# How to use this image
## Start a Go instance in your app
The most staightforward way to use this image is to use a Go container as both the build and runtime enviroment.
In your Dockfile, writhing something along the lines of the following will compile and run your project.
```shell
FROM openeuler/golang:1.17.3

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]
```
You can then build and run the Docker image:
```shell
docker build -t my-golang-app .
docker run -it --rm --name my_app my-golang-app
```

# Supported tags and respective Dockerfile links

- 1.17.3-22.03-lts: golang v1.17.3, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
