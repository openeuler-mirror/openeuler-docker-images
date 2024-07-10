# openEuler官方容器镜像仓

#### 介绍

这里存放着由openEuler官方提供的容器镜像，包含openEuler基础镜像、应用镜像。


#### openEuler基础镜像

openEuler的基础镜像由社区官方发布，目前发布在[openEuler镜像站](https://repo.openeuler.org)。

"openeuler:latest"是最新可用的长期稳定镜像。

镜像发布后，会同步推送到各个远端容器镜像仓，信息如下：

- 仓库及镜像名：`openeuler/openeuler`
- 下载命令：`docker pull [远端容器镜像仓URL]openeuler/openeuler[:tags]`
- 支持架构：amd64, arm64
- 当前可用Tags的命名: 
	- [20.03-lts](https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/)
	- [20.03-lts-sp1](https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/)
	- [20.03-lts-sp2](https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/)
	- [20.03-lts-sp3](https://repo.openeuler.org/openEuler-20.03-LTS-SP3/docker_img/)
	- [20.03-lts-sp4, 20.03](https://repo.openeuler.org/openEuler-20.03-LTS-SP4/docker_img/)
	- [20.09](https://archives.openeuler.openatom.cn/openEuler-20.09/docker_img/)
	- [21.03](https://archives.openeuler.openatom.cn/openEuler-21.03/docker_img/)
	- [21.09](https://archives.openeuler.openatom.cn/openEuler-21.09/docker_img/)
	- [22.03-lts](https://repo.openeuler.org/openEuler-22.03-LTS/docker_img/)
	- [22.09](https://archives.openeuler.openatom.cn/openEuler-22.09/docker_img/)
	- [22.03-lts-sp1](https://repo.openeuler.org/openEuler-22.03-LTS-SP1/docker_img/)
	- [22.03-lts-sp2](https://repo.openeuler.org/openEuler-22.03-LTS-SP2/docker_img/)
	- [22.03-lts-sp3](https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/)
	- [22.03-lts-sp4, 22.03](https://repo.openeuler.org/openEuler-22.03-LTS-SP4/docker_img/)
	- [23.03](https://repo.openeuler.org/openEuler-23.03/docker_img/)
	- [23.09](https://repo.openeuler.org/openEuler-23.09/docker_img/)
	- [24.03-lts, latest](https://repo.openeuler.org/openEuler-24.03-LTS/docker_img/)
- 存放路径规则：`openeuler/[openEuler版本号]/Dockerfile`，
例如：openEuler 21.09的Dockerfile位于`openeuler/21.09/Dockerfile`。

#### openEuler应用镜像

基于openEuler基础镜像，将一些热门应用进行发布，生成基于openEuler的应用镜像。

- 存放路径规则：`[应用名]/[应用版本号]/[openEuler版本号]/Dockerfile`，
例如：基于openEuler 20.03-lts-sp1的nginx 1.20.1的Dockerfile位于`nginx/1.20.1/20.03-lts-sp1/Dockerfile`。
特殊地，对于复杂软件栈的应用容器镜像，为了准确表达其依赖情况，Dockerfile存放路径的`[应用版本号]`可以描述为完整的软件栈版本号，例如：`pytorch/2.1.0-cann7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile`存放基于cann7.0.RC1.alpha002和openEuler 22.03-lts-sp2的pytorch 2.1.0应用镜像Dockerfile。

- Tags命名：合入后，将会发布至openeuler仓库，
例如：`openeuler/nginx:1.20.1-oe2003sp1`。

每个应用镜像，应当包含一个README（例如nginx/README.md），涵盖以下信息：

- 构建容器镜像的说明。
- 配套的openEuler、容器（例如Docker, iSula）及应用的版本信息。

应用镜像的Dockerfile合入后，会触发jenkins上的CI流水线自动构建镜像并发布，默认使用`docker buildx`插件来构建amd64和arm64两种，构建的指令方式为：
- 切换到`[应用名]/[应用版本号]/[openEuler版本号]`目录
- 执行`docker buildx build -t tag_name --platform linux/amd64,linux/arm64 .`

每个应用镜像，包含一个`doc/`目录，存放该镜像的图文信息：
- `doc/image-info.yml`

	内容如下：

		名称（name）
		分类（category），共6大类：大数据（bigdata）、AI（ai）、分布式存储（storage）、数据库（database）、云服务（cloud）、HPC（hpc）
		功能简介（description）
		运行环境（environment）
		获取方式（download）
		使用方式（install）
		LICENSE（license）
		近似软件（similar_packages）
		依赖软件（dependency）

- `doc/picture/`

	存放应用相关的图片
	
每个应用镜像，包含一个meta.yml文件，存放该镜像的版本信息，文件路径为:`[应用名]/meta.yml`

 - `meta.yml`
	
	示例如下：

		# spark/meta.yml
		3.3.1-oe2203lts:
  			path: spark/3.3.1/22.03-lts/Dockerfile
		3.3.2-oe2203lts:
		  	path: spark/3.3.2/22.03-lts/Dockerfile
			arch: aarch64
	
	配置项说明:
	| 配置项 | 是否必填 | 配置说明 | 配置示例 |
	|--|--|--|--|
	| path | 是 | dockerfile相对路径 | spark/3.3.1/22.03-lts/Dockerfile |
	| arch | 否 | 用于发布单架构镜像时指定镜像架构；无该字段时，默认发布x86_64和aarch64的双架构镜像。| x86_64，配置仅支持x86_64或aarch64 |

#### 国内镜像仓

目前支持的第三方国内镜像仓有：

- [hub.oepkgs.net](https://hub.oepkgs.net/)

- [hub.docker.com](https://hub.docker.com/)

- [quay.io](https://quay.io/)

#### 镜像发布指南

1. 提交镜像的PR合入后，会触发CI流程自动发布镜像。
2. 镜像dockerfile文件新增和修改合入后，会触发CI流程自动发布镜像。
3. 镜像README.md文件新增和修改合入后，会触发CI流程自动发布镜像README信息。
4. 欢迎在`eulerPublisher`提交镜像的测试用例；当镜像没有测试用例时，自动发布流程中仅检查能否成功构建镜像。