# Quick reference

- The official Dotnet Runtime (.NET Runtime) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Dotnet Runtime (.NET Runtime) | openEuler
Current Dotnet Runtime (.NET Runtime) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

.NET is a free, cross-platform, open-source developer platform for building many kinds of applications. It can run programs written in multiple languages, with C# being the most popular. It relies on a high-performance runtime that is used in production by many high-scale apps.

Learn more about Dotnet Runtime on [learn.microsoft.com](https://learn.microsoft.com/en-us/dotnet/core/introduction)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dotnet-runtime` docker image is consist of the version of `dotnet-runtime` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[8.0.3-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.3/22.03-lts-sp3/Dockerfile)| Dotnet-runtime 8.0.3 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.7-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.7/22.03-lts-sp3/Dockerfile)| Dotnet-runtime 8.0.7 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.8-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.8/22.03-lts-sp3/Dockerfile)| Dotnet-runtime 8.0.8 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.10-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.10/20.03-lts-sp4/Dockerfile)| Dotnet-runtime 8.0.10 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[8.0.10-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.10/22.03-lts-sp1/Dockerfile)| Dotnet-runtime 8.0.10 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[8.0.10-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.10/22.03-lts-sp3/Dockerfile)| Dotnet-runtime 8.0.10 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[8.0.10-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.10/22.03-lts-sp4/Dockerfile)| Dotnet-runtime 8.0.10 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[8.0.10-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dotnet-runtime/8.0.10/24.03-lts/Dockerfile)| Dotnet-runtime 8.0.10 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dotnet-runtime` image from docker

	```bash
	docker pull openeuler/dotnet-runtime:{Tag}
	```

- Start a dotnet-runtime instance

	```bash
	docker run -d --name my-dotnet-runtime openeuler/dotnet-runtime:{Tag}
	```
- An example with HelloWorld application example

	1. Create a HelloWorld.csproj file with the following content
	
	       <Project Sdk="Microsoft.NET.Sdk">
			 <PropertyGroup>
				  <OutputType>Exe</OutputType>
				  <TargetFramework>net8.0</TargetFramework>
				  <ImplicitUsings>enable</ImplicitUsings>
				  <Nullable>enable</Nullable>
			 </PropertyGroup>
		   </Project>

	2. Create a Program.cs file with the following code
	
			Console.WriteLine("Hello, World!");

	3. Publish the .NET application (you need the "dotnet8" package)
	
			dotnet publish -c Release -o app
	
	4. Run the app with "openeuler/dotnet-runtime:8.0.3-oe2203sp3" 
	
			docker run --rm -v $PWD/app:/app openeuler/dotnet-runtime:8.0.3-oe2203sp3 /app/HelloWorld.dll 
			Hello, World!
			
- View container running logs

	```bash
	docker logs -f my-dotnet-runtime
	```

- To get an interactive shell

	```bash
	docker run -it --entrypoint /bin/bash --name my-dotnet-runtime openeuler/dotnet-runtime:{Tag}
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).