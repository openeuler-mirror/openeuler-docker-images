# Quick reference

- The official Kong docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Kong | openEuler
Current Kong docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Kong or Kong API Gateway is a cloud-native, platform-agnostic, scalable API Gateway distinguished for its high performance and extensibility via plugins. It also provides advanced AI capabilities with multi-LLM support.

Learn more on [Kong Website](https://docs.konghq.com/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `kong` docker image is consist of the version of `kong` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.4.0-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/kong/3.4.0/24.03-lts/Dockerfile)| Kong 3.4.0 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
Choose a path to install Kong Gateway:
- With a database: Use a database to store Kong entity configurations. Can use the Admin API or declarative configuration files to configure Kong.
- Without a database (DB-less mode): Store Kong configuration in-memory on the node. In this mode, the Admin API is read only, and you have to manage Kong using declarative configuration.

Prepare the database
1. Create a custom Docker network to allow the containers to discover and communicate with each other:
	```bash
	docker network create kong-net
	```
	You can name this network anything you want. We use kong-net as an example throughout this guide.

2. Start a PostgreSQL container:
	```bash
	docker run -d --name kong-database \
	--network=kong-net \
	-p 5432:5432 \
	-e "POSTGRES_USER=kong" \
	-e "POSTGRES_DB=kong" \
	-e "POSTGRES_PASSWORD=kongpass" \
	openeuler/postgres:{Tag}
	```
	- POSTGRES_USER and POSTGRES_DB: Set these values to kong. This is the default value that Kong Gateway expects.
	- POSTGRES_PASSWORD: Set the database password to any string.

3. Prepare the Kong database:
	```bash
	docker run --rm --network=kong-net \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=kong-database" \
	-e "KONG_PG_PASSWORD=kongpass" \
	openeuler/kong:{Tag} kong migrations bootstrap
	```
	Where:
	- KONG_DATABASE: Specifies the type of database that Kong is using.
	- KONG_PG_HOST: The name of the Postgres Docker container that is communicating over the kong-net network, from the previous step.
	- KONG_PG_PASSWORD: The password that you set when bringing up the Postgres container in the previous step.
	- KONG_PASSWORD (Enterprise only): The default password for the admin super user for Kong Gateway.
	- {IMAGE-NAME:TAG} kong migrations bootstrap: In order, this is the Kong Gateway container name and tag, followed by the command to Kong to prepare the Postgres database.

Start Kong Gateway
> **Important**: The settings below are intended for non-production use only, as they override the default admin_listen setting to listen for requests from any source. Do not use these settings in environments directly exposed to the internet.If you need to expose the admin_listen port to the internet in a production environment, secure it with authentication.

1. Run the following command to start a container with Kong Gateway:
	```bash
	docker run -d --name kong-gateway \
	--network=kong-net \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=kong-database" \
	-e "KONG_PG_USER=kong" \
	-e "KONG_PG_PASSWORD=kongpass" \
	-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
	-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
	-e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
	-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
	-e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
	-e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
	-p 8000:8000 \
	-p 8443:8443 \
	-p 127.0.0.1:8001:8001 \
	-p 127.0.0.1:8002:8002 \
	-p 127.0.0.1:8444:8444 \
	openeuler/kong:${Tag}

	```
	Where:
	- --name and --network: The name of the container to create, and the Docker network it communicates on.
	- KONG_DATABASE: Specifies the type of database that Kong is using.
	- KONG_PG_HOST: The name of the Postgres Docker container that is communicating over the kong-net network.
	- KONG_PG_USER and KONG_PG_PASSWORD: The Postgres username and password. Kong Gateway needs the login information to store configuration data in the KONG_PG_HOST database.
	- All _LOG parameters: set filepaths for the logs to output to, or use the values in the example to print messages and errors to stdout and stderr.
	- KONG_ADMIN_LISTEN: The port that the Kong Admin API listens on for requests.
	- KONG_ADMIN_GUI_URL: The URL for accessing Kong Manager, preceded by a protocol (for example, http://).
	- KONG_LICENSE_DATA: (Enterprise only) If you have a license file and have saved it as an environment variable, this parameter pulls the license from your environment.

2. Verify your installation:
Access the /services endpoint using the Admin API:
	```bash
	curl -i -X GET --url http://localhost:8001/services
	```
You should receive a 200 status code.

3. Verify that Kong Manager is running by accessing it using the URL specified in KONG_ADMIN_GUI_URL:
	```bash
	http://localhost:8002
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).