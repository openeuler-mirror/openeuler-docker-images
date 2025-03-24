# Quick reference

- The official Dotnet-aspnet（ASP.NET Core） docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Dotnet-aspnet（ASP.NET Core） | openEuler
Current Dotnet-aspnet（ASP.NET Core） docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Dotnet-aspnet (ASP.NET Core) is an open source cross-platform framework for building modern cloud-based Internet-connected applications, such as web applications, IoT applications, and mobile backends. ASP.NET Core applications run on .NET.

Learn more about Dotnet-aspnet（ASP.NET Core）（ASP on [learn.microsoft.com](https://learn.microsoft.com/en-us/dotnet/core/deploying/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dotnet-aspnet` docker image is consist of the version of `dotnet-aspnet` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[8.0.3-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.3/22.03-lts-sp3/Dockerfile)| Dotnet-aspnet 8.0.3 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.7-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.7/22.03-lts-sp3/Dockerfile)| Dotnet-aspnet 8.0.7 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.8-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.8/22.03-lts-sp3/Dockerfile)| Dotnet-aspnet 8.0.8 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.10-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.10/20.03-lts-sp4/Dockerfile)| Dotnet-aspnet 8.0.10 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[8.0.10-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.10/22.03-lts-sp1/Dockerfile)| Dotnet-aspnet 8.0.10 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[8.0.10-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.10/22.03-lts-sp3/Dockerfile)| Dotnet-aspnet 8.0.10 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.10-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.10/22.03-lts-sp4/Dockerfile)| Dotnet-aspnet 8.0.10 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[8.0.10-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-aspnet/8.0.10/24.03-lts/Dockerfile)| Dotnet-aspnet 8.0.10 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dotnet-aspnet` image from docker

	```bash
	docker pull openeuler/dotnet-aspnet:{Tag}
	```

- Start a dotnet-aspnet instance

	```bash
	docker run -d --name my-dotnet-aspnet -p 8080:8080 openeuler/dotnet-aspnet:{Tag}
	```
    After `my-dotnet-aspnet` is started, access the service through `http://localhost:8080`.

- An example with HelloWorld application example

    1. Obtain the dotnetcore-docs-hello-world source code and navigate to the root directory.
        ```
        git clone https://github.com/Azure-Samples/dotnetcore-docs-hello-world
        cd dotnetcore-docs-hello-world
        ```

	2. Modify the .NET Version for Application Publishing
        Open the `dotnetcoresample.csproj` file, and replace `{x.x}` in `<TargetFramework>net{x.x}</TargetFramework>` with the desired .NET version.

	3. Publish the application.
        ```
        dotnet publish -c Release -o /app --self-contained false
        ```
        During execution, the following key information will be displayed:
        ```
        Determining projects to restore...
        All projects are up-to-date for restore.
        dotnetcoresample -> /tmp/dotnetcore-docs-hello-world/bin/Release/net{x.x}/dotnetcoresample.dll
        dotnetcoresample -> /app/
        ```
	
	4. Run the application using openeuler/dotnet-aspnet:{Tag}
        ```
        docker run --rm -v /app:/app -p 8080:8080 openeuler/dotnet-aspnet:{Tag} /app/dotnetcoresample.dll 
        ```
		Note: The .NET version `{x.x}` used for publishing the application must match the version specified by `{Tag}`.
			
- View container running logs

	```bash
	docker logs -f my-dotnet-aspnet
	```

- To get an interactive shell

	```bash
	docker run -it --entrypoint /bin/bash --name my-dotnet-aspnet -p 8080:8080 openeuler/dotnet-aspnet:{Tag}
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).