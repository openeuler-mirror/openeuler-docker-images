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
	- [21.09](https://repo.openeuler.org/openEuler-21.09/docker_img/)
	- [20.09](https://repo.openeuler.org/openEuler-20.09/docker_img/)
	- [20.03-lts](https://repo.openeuler.org/openEuler-20.03-LTS/)
	- [20.03-lts-sp1, 20.03, latest](https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/)
	- [20.03-lts-sp2](https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/)
	- [20.03-lts-sp3](https://repo.openeuler.org/openEuler-20.03-LTS-SP3/docker_img/)
	- [21.03](https://repo.openeuler.org/openEuler-21.03/docker_img/)
	- [22.03-lts, 22.03, latest](https://repo.openeuler.org/openEuler-22.03-LTS/docker_img/)
- 存放路径规则：`openeuler/[openEuler版本号]/Dockerfile`，
例如：openEuler 21.09的Dockerfile位于`openeuler/21.09/Dockerfile`。

#### openEuler应用镜像

基于openEuler基础镜像，将一些热门应用进行发布，生成基于openEuler的应用镜像。

- 存放路径规则：`[应用名]/[应用版本号]/[openEuler版本号]/Dockerfile`，
例如：基于openEuler 20.03-lts-sp1的nginx 1.20.1的Dockerfile位于`nginx/1.20.1/20.03-lts-sp1/Dockerfile`。
- Tags命名：合入后，将会发布至openeuler仓库，
例如：`openeuler/nginx:1.20.1-20.03-lts-sp1`。

每个应用镜像，应当包含一个README（例如nginx/README.md），涵盖以下信息：

- 构建容器镜像的说明。
- 配套的openEuler、容器（例如Docker, iSula）及应用的版本信息。

应用镜像的Dockerfile合入后，会触发jenkins上的CI流水线自动构建镜像并发布，默认使用`docker buildx`插件来构建amd64和arm64两种，构建的指令方式为：
- 切换到`[应用名]/[应用版本号]/[openEuler版本号]`目录
- 执行`docker buildx build -t tag_name --platform linux/amd64,linux/arm64 .`


#### 国内镜像仓

目前支持的第三方国内镜像仓有：

- Hub oepkgs: https://hub.oepkgs.net/

- AtomHub: https://atomhub.org/


#### 参与贡献

欢迎发表想法、提交问题、贡献代码。
