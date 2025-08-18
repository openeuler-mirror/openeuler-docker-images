# Quick reference

- The official distroless-nodejs docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-nodejs | openEuler
This image contains a minimal Linux, that only contains the Node.js runtime.
- It contains the Node.js executable and standard libraries(`libnode.so` and the built-in modules in `node_muodules`)
- It does not include npm or any other package management or shell tools.

# Supported tags and respective Dockerfile links
The tag of each `distroless-nodejs` docker image is consist of the version of `Node.js` and version of openEuler. The details are as follows

| Tag                                                                                                                                            | Currently                              | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [20.18.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-nodejs/20.18.2/24.03-lts/Distrofile) | Node.js 20.18.2 on openEuler 24.03-LTS | amd64, arm64  |

# Usage
The container automatically uses the built-in Node.js runtime to execute the file, so you don't need to call node explicitly. For [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-nodejs/example)

```
FROM openeuler/distroless-nodejs:20.18.2-oe2403lts
COPY hello.js /hello.js
CMD ["/hello.js"]
```

# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).