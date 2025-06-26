# Quick reference

- The official distroless-static docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-static | openEuler
This image contains a minimal Linux, glibc runtime for "mostly-statically compiled" languages like Rust and Go.

Statically compiled applications (Go) that do not require libc can use the `openeuler/distroless-static` image, which contains:
- ca-certificates
- tzdata

# Supported tags and respective Dockerfile links
The tag details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-static/1.0.0/24.03-lts/Distrofile)| openEuler 24.03-LTS static image | amd64, arm64 |

# Usage
Users are expected to include their compiled application and set the correct cmd in their image. For [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-static/example)
```
# Dockerfile

FROM openeuler/go:latest AS build
WORKDIR /go/src/app
COPY . .
RUN go mod download
RUN go vet -v
RUN go test -v
RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM openeuler/distroless-static:1.0.0-oe2403lts
COPY --from=build /go/bin/app /
CMD ["/app"]
```

# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).