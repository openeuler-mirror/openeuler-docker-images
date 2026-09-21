# Quick reference

- The official Lua docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Lua | openEuler
Current Lua docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports several programming styles: procedural, object-oriented, functional, data-driven, and data description. Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics. Lua is dynamically typed, runs by interpreting bytecode on a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

Learn more about Lua on [The Programming Language Lua](https://www.lua.org/).

# Supported tags and respective Dockerfile links
The tag of each `lua` docker image is consist of the version of `lua` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[5.5.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/lua/5.5.1/24.03-lts-sp4/Dockerfile) | lua 5.5.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/lua` image from docker

	```bash
	docker pull openeuler/lua:{Tag}
	```

- Run with an interactive Lua shell

	```bash
	docker run -it --rm openeuler/lua:{Tag}
	```

- Run a Lua script

	Create a file named `hello.lua` with the following content:
	```lua
	print("Hello from " .. _VERSION)
	```
	Then run it inside the container:
	```bash
	docker run --rm -v $(pwd):/workspace openeuler/lua:{Tag} lua /workspace/hello.lua
	```

- Check the container logs

	```bash
	docker run -d --name lua-demo openeuler/lua:{Tag} -e 'while true do print("Lua is running"); io.flush(); os.execute("sleep 5") end'
	docker logs lua-demo
	```

- Exec into the running container

	```bash
	docker exec -it lua-demo lua
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
