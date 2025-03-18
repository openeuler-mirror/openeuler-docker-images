中文 | [English](README.en.md)

# openEuler官方容器镜像仓

## 介绍

这里存放着由openEuler官方提供的容器镜像，包含openEuler基础镜像、应用镜像。

## 相关链接
- [openEuler容器镜像使用指南](https://forum.openeuler.org/t/topic/4189)
- [bisheng-jdk容器镜像实践](https://blog.csdn.net/weixin_43878094/article/details/139444574)

## 基础镜像
openEuler的基础镜像由社区官方发布，目前发布在[openEuler镜像站](https://repo.openeuler.org), 其中"openeuler:latest"是最新可用的长期稳定镜像。

社区官方镜像发布后，会同步推送到各个远端容器镜像仓，信息如下：

### 1.仓库及镜像名
基础镜像在第三方镜像托管平台的仓库名/镜像名为：[`openeuler/openeuler`](https://hub.docker.com/r/openeuler/openeuler)

### 2.可用镜像的Tags

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
- [24.03-lts](https://repo.openeuler.org/openEuler-24.03-LTS/docker_img/)
- [24.03-lts-sp1, latest](https://repo.openeuler.org/openEuler-24.03-LTS-SP1/docker_img/)
- [24.09](https://repo.openeuler.org/openEuler-24.09/docker_img/)

### 3.存放路径：
`Base/openeuler/Dockerfile`

## 应用镜像

基于openEuler基础镜像内置应用，发布openEuler的应用镜像。

### 1.仓库及镜像名
应用镜像在第三方镜像托管平台的仓库名/镜像名为：[`openeuler/[应用名]`](https://hub.docker.com/u/openeuler)

### 2.存放路径
应用镜像按场景分为7类，按场景目录存放镜像构建文件：
  - 大数据:    `Bigdata/`
  - AI:       `AI/`
  - 分布式存储: `Storage/`
  - 数据库:    `Database/`
  - 云服务:    `Cloud/`
  - 高性能计算: `HPC/`
  - 其他:      `Others/`

由于应用镜像功能的复杂性，可能存放的路径深度具有不确定性，例如：
```
openeuler-docker-images/
└── AI/
    |── image-list.yml
	|── OPEA/ # 解决方案层级
	|    |── AudioQnA/ # 案例1
	|	 |    └── Image_1/
	|	 |    └── Image_2/
	|	 └── DocSum/  # 案例2
	|	      └── Image_3/
	|	      └── Image_4/
	|		  └── Image_5/
	|───Image6/
	└───Image7/
```

在上述示例中，存放应用镜像的**最小目录单元**是`Image_i/`，在每个场景目录下必包含一个`image-list.yml`文件用以描述每个应用镜像**最小目录单元**的起始路径，便于CI检查镜像目录完整性。格式如下：
```
# AI/image-list.yml示例
images:
	Image_1: AI/OPEA/AudioQnA/Image_1/  # root path to Image_1
	Image_2: AI/OPEA/AudioQnA/Image_2/
	Image_3: AI/OPEA/DocSum/Image_3/
	Image_4: AI/OPEA/DocSum/Image_4/
	Image_5: AI/OPEA/DocSum/Image_5/
	Image_6: Image_6/
	Image_7: Image_7/
```
本仓库要求**最小目录单元**`Image_i`严格遵循以下结构：
```
# 以`Image_i` == `nginx`为例
nginx/
	|── README.md
	|── meta.yml
	|── doc/ (可选)
	|    |── picture/
	|	 |    └── logo.png
	|	 └── image-info.yml
	└── 1.27.2/
	     |── 24.03-lts
		 |    └── Dockerfile
		 |── 22.03-lts-sp4
		 |    └── Dockerfile
	     |── 22.03-lts-sp3
		 |    └── Dockerfile
	     └── 22.03-lts-sp1
		      └── Dockerfile
```
在每个**最小目录单元**中`Image_i/`下，包含以下内容：
- Dockerfile：

    存放路径为`[应用的版本号]/[openEuler的版本号]/Dockerfile`。示例：基于openEuler `22.03-lts-sp1`的nginx `1.27.1`应用镜像Dockerfile位于`1.27.1/22.03-lts-sp1/Dockerfile`。

    特殊地，对于复杂软件栈的应用容器镜像，为了准确表达其依赖情况，Dockerfile存放路径的`[应用版本号]`可以描述为完整的软件栈版本号，例如PyTorch：`2.1.0-cann7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile`存放基于`cann7.0.RC1.alpha002`和`openEuler 22.03-lts-sp2`的`pytorch 2.1.0`版本应用镜像的Dockerfile（AI类容器镜像的tag可参考[oEEP-0014](https://gitee.com/openeuler/TC/blob/be62b1cb6d5131aafac5f7b0eabf75d712d2b4f0/oEEP/oEEP-0014%20openEuler%20AI%E5%AE%B9%E5%99%A8%E9%95%9C%E5%83%8F%E8%BD%AF%E4%BB%B6%E6%A0%88%E8%A7%84%E8%8C%83.md)）。

- README.md文件

	按顺序涵盖以下信息：
	- `Quick reference`：相关链接信息
	- `[应用名] | openEuler`：描述应用的功能
	- `Supported tags and respective Dockerfile links`：描述当前应用容器镜像的tags及Dockerfile链接，新增镜像时**必须更新**
	- `Usage`：描述该应用容器镜像的使用方法，尽量出给一个能够简单运行的测试用例
	- `Question and answering`：提供Issue链接
	
	README会同步发布到第三方Hub镜像详情页面的`Overview`或`Description`，贡献PR时需认真对待。

- meta.yml文件

	描述每个镜像的tag信息和Dockerfile存放路径等信息，文件路径为:`[应用名]/meta.yml`。文件格式如下所示：
	```
	# spark/meta.yml
	3.3.1-oe2203lts: 
		path: spark/3.3.1/22.03-lts/Dockerfile
	3.3.2-oe2203lts:
		path: spark/3.3.2/22.03-lts/Dockerfile
		arch: aarch64
	```
	上述文件中，每一对`<key, value>`描述一个镜像的构建发布规则，其中：
	- key：表示镜像的tag，建议tag命名格式为：`[应用版本号]-[openeuler版本号]`，如`3.3.1-oe2203lts`和`3.3.2-oe2203lts`均表示`openeuler/spark`镜像的不同tag
	- value: 用于描述如何构建镜像，说明如下
		| 配置项 | 是否必选 | 功能说明 | 示例 |
		|--|--|--|--|
		| path | 是 | 描述构建镜像的Dockerfile相对路径 | spark/3.3.1/22.03-lts/Dockerfile |
		| arch | 否 | 用于发布单架构镜像时，指定构建架构可选`x86_64`或`aarch64`；未填写该项时，默认发布`x86_64`和`aarch64`的双架构镜像 | x86_64 |

	备注： **镜像tag更新时，需要同步更新上述配置**。

- （可选）`doc/`目录

	存放该镜像的图文信息，用于在[openEuler软件中心的应用镜像版本](https://easysoftware.openeuler.org/zh/image)展示该镜像。无需展示在软件中心时，可不填写本部分内容。
	- `doc/image-info.yml`，内容如下：

			名称（name）：应用名
			分类（category）：应用镜像功能分类，可选：bigdata、ai、storage、database、cloud、hpc、others
			功能简介（description）
			运行环境（environment）
			镜像标签（tags）
			获取方式（download）
			使用方式（usage）
			LICENSE（license）
			近似软件（similar_packages）
			依赖软件（dependency）
	- `doc/picture/`：

		存放与应用特征相关的图片，如应用的logo或典型场景的运行时截图
	
	备注：**上述`doc/`目录的文件和内容必须同时存在才可在软件中心正确显示该镜像**。

## 镜像托管平台

目前支持的第三方镜像托管平台有：
- [hub.oepkgs.net](https://hub.oepkgs.net/)
- [hub.docker.com](https://hub.docker.com/u/openeuler)
- [quay.io](https://quay.io/organization/openeuler)

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

5. **已发布的镜像原则上不能下架**，即使不再更新维护也存在用户仍在使用的情况。因此，特殊情况下需要下架镜像时，请创建issue提供需要下架的镜像tag以及下架原因，并与maintainer联系。
