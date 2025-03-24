# Quick reference

- The official Dotnet-deps(.NET Deps) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Dotnet-deps(.NET Deps) | openEuler
Current Dotnet-deps(.NET Deps) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The dotnet-deps(.NET Deps) image is for developers to layer standalone .NET and ASP.NET applications. It only contains the runtime dependencies required to run a standard self-contained .NET application: ca-certificates, glibc, libgcc, libicu, openssl-libs, libstdc++, tzdata, zlib.

Learn more about Dotnet-deps(.NET Deps) on [learn.microsoft.com](https://learn.microsoft.com/en-us/dotnet/core/deploying/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dotnet-deps` docker image is consist of the version of `dotnet-deps` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[8.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-deps/8.0/22.03-lts-sp3/Dockerfile)| It includes the runtime dependencies required to run a standard self-contained .NET application of version 8.0.x on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dotnet-deps` image from docker

	```bash
	docker pull openeuler/dotnet-deps:{Tag}
	```

- Start a dotnet-deps instance

	```bash
	docker run -d --name my-dotnet-deps openeuler/dotnet-deps:{Tag}
	```
- An example with HelloWorld application example

    1. Obtain the dotnetcore-docs-hello-world source code and navigate to the root directory.
        ```
        git clone https://github.com/Azure-Samples/dotnetcore-docs-hello-world
        cd dotnetcore-docs-hello-world
        ```

	2. Modify the dotnetcoresample.csproj file.
        Open the dotnetcoresample.csproj file and update it with the following content:
        ```
        <Project Sdk="Microsoft.NET.Sdk.Web">
        <PropertyGroup>
            <TargetFramework>net{x.x}</TargetFramework>
            <Nullable>enable</Nullable>
            <ImplicitUsings>enable</ImplicitUsings>
            <RuntimeIdentifiers>linux-x64;linux-arm64</RuntimeIdentifiers>
        </PropertyGroup>
        </Project>
        ```
        Replace {x.x} with the desired .NET version.

	3. Publish the application.
        ```
        dotnet publish -c Release -o /app -r linux-x64 --self-contained true
        ```
        During execution, the following key information will be displayed:
        ```
        Determining projects to restore...
        All projects are up-to-date for restore.
        dotnetcoresample -> /home/deps/dotnetcore-docs-hello-world/bin/Release/net{x.x}/linux-x64/dotnetcoresample.dll
        dotnetcoresample -> /app/
        ```
	
	4. Run the application using openeuler/dotnet-deps:{Tag}
        ```
        docker run --rm -v /app:/app openeuler/dotnet-deps:{Tag} /app/dotnetcoresample 
        ```
	Note that the .NET version {x.x} used to publish the application must match the version specified by {Tag}.
			
- View container running logs

	```bash
	docker logs -f my-dotnet-deps
	```

- To get an interactive shell

	```bash
	docker run -it --name my-dotnet-deps openeuler/dotnet-deps:{Tag} /bin/bash{Tag}
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).