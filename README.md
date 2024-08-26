中文 | [English](README.en.md)

# openEuler官方容器镜像仓

## 介绍

这里存放着由openEuler官方提供的容器镜像，包含openEuler基础镜像、应用镜像。

## 相关链接
- [openEuler容器镜像使用指南](https://forum.openeuler.org/t/topic/4189)
- [bisheng-jdk容器镜像实践](https://blog.csdn.net/weixin_43878094/article/details/139444574)

## 基础镜像

openEuler的基础镜像由社区官方发布，目前发布在[openEuler镜像站](https://repo.openeuler.org), 其中"openeuler:latest"是最新可用的长期稳定镜像。

镜像发布后，会同步推送到各个远端容器镜像仓，信息如下：

- 仓库及镜像名：`openeuler/openeuler`
- 下载命令：`docker pull [远端容器镜像仓URL]openeuler/openeuler[:tags]`
- 支持架构：amd64, arm64
- 当前可用镜像的Tags: 
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

## 应用镜像

基于openEuler基础镜像内置应用，发布openEuler的应用镜像。

- 仓库及镜像名：`openeuler/[应用名]`
- 存放路径规则：`[应用名]/[应用版本号]/[openEuler版本号]/Dockerfile`, 例如：基于openEuler 20.03-lts-sp1的nginx 1.20.1的Dockerfile位于`nginx/1.20.1/20.03-lts-sp1/Dockerfile`。

    特殊地，对于复杂软件栈的应用容器镜像，为了准确表达其依赖情况，Dockerfile存放路径的`[应用版本号]`可以描述为完整的软件栈版本号，例如：`pytorch/2.1.0-cann7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile`存放基于`cann7.0.RC1.alpha002`和`openEuler 22.03-lts-sp2`的`pytorch 2.1.0`版本应用镜像的Dockerfile。

- Tags规则：`[应用版本号]-[openeuler版本号]`，例如：`openeuler/nginx:1.20.1-oe2003sp1`。

每个应用容器镜像目录包含的内容：
1. 包含一个README文件（例如`nginx/README.md`），按顺序涵盖以下信息：
	- `Quick reference`：相关链接信息
	- `[应用名] | openEuler`：描述应用的功能
	- `Supported tags and respective Dockerfile links`：描述当前应用容器镜像的tags及Dockerfile链接，新增镜像时必须更新
	- `Usage`：描述该应用容器镜像的使用方法，尽量出给一个能够简单运行的测试用例
	- `Question and answering`：提供Issue链接
	
	README会同步发布到第三方Hub镜像详情页面的`Overview`或`Description`，贡献PR时需认真对待。

2. 包含一个`meta.yml`文件，存放该镜像的构建发布信息，文件路径为:`[应用名]/meta.yml`。文件格式如下所示：
	```
	# spark/meta.yml

	# tag1
	3.3.1-oe2203lts: 
		path: spark/3.3.1/22.03-lts/Dockerfile

	# tag2
	3.3.2-oe2203lts:
		path: spark/3.3.2/22.03-lts/Dockerfile
		arch: aarch64
	```

	上述文件中，每一对`<key, value>`描述一个镜像的构建发布规则，其中：
	- key：表示镜像的tag，如`3.3.1-oe2203lts`和`3.3.2-oe2203lts`均表示`openeuler/spark`镜像的不同tag
	- value: 用于描述如何构建镜像，说明如下
		| 配置项 | 是否必选 | 功能说明 | 示例 |
		|--|--|--|--|
		| path | 是 | 描述构建镜像的Dockerfile相对路径 | spark/3.3.1/22.03-lts/Dockerfile |
		| arch | 否 | 用于发布单架构镜像时，指定构建架构可选`x86_64`或`aarch64`；未填写该项时，默认发布`x86_64`和`aarch64`的双架构镜像 | x86_64 |

	备注： 镜像tag更新时，需要同步更新上述配置。

3. （可选）包含一个`doc/`目录，存放该镜像的图文信息：

	- `doc/image-info.yml`，内容如下：

			名称（name）：应用名
			分类（category）：应用镜像功能分类，可选：大数据（bigdata）、AI（ai）、分布式存储（storage）、数据库（database）、云服务（cloud）、HPC（hpc）、其他（others）
			功能简介（description）
			运行环境（environment）
			镜像标签（tags）
			获取方式（download）
			使用方式（usage）
			LICENSE（license）
			近似软件（similar_packages）
			依赖软件（dependency）
	- `doc/picture/`

		存放与应用特征相关的图片，如应用的logo或典型场景的运行时截图
	

## 镜像托管平台

目前支持的第三方镜像托管平台有：
- [hub.oepkgs.net](https://hub.oepkgs.net/)
- [hub.docker.com](https://hub.docker.com/)
- [quay.io](https://quay.io/)

以基础镜像`openeuler/openeuler:latest`为例，从指定托管平台获取镜像的方式如下：
```
# 从hub.oepkgs.net获取镜像
docker pull hub.oepkgs.net/openeuler/openeuler:latest

# 从hub.docker.com获取镜像
docker pull docker.io/openeuler/openeuler:latest

# 从quay.io获取镜像
docker pull quay.io/openeuler/openeuler:latest
```
注意：由于国内用户访问`hub.docker.com`受限，建议从`hub.oepkgs.net`或`quay.io`拉取所需的镜像。

## 镜像发布指南
欢迎广发开发者贡献openEuler应用容器镜像，请根据上述要求提交PR，待门禁检查成功且合入后，会触发自动发布流程，您的镜像将会出现在上文中提到的镜像托管平台中！

关于门禁检查的说明：

1. 所有容器镜像的构建、发布、测试均由[EulerPublisher](https://gitee.com/openeuler/eulerpublisher)完成。

2. 应用容器镜像的测试通过[tests/container/app](https://gitee.com/openeuler/eulerpublisher/tree/master/tests/container/app)目录的测试脚本实现。开发者贡献应用镜像时，可通过[EulerPublisher](https://gitee.com/openeuler/eulerpublisher)仓库的说明同时贡献对应的测试用例。

关于PR合入后，自动发布镜像的规则说明：

3. 新增或修改镜像Dockerfile的PR合入后，会触发新增镜像自动发布或已有镜像更新。

4. 新增或修改镜像README.md的PR合入后，会触发所有镜像托管平台的Overview或Description信息刷新。
