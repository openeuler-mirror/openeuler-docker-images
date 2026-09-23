# Quick reference

- The official Vue docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Vue | openEuler
Current Vue docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Vue (pronounced `/vjuː/`, like view) is a **progressive framework** for building user interfaces. It is designed from the ground up to be incrementally adoptable, and can easily scale between a library and a framework depending on different use cases. It consists of an approachable core library that focuses on the view layer only, and an ecosystem of supporting libraries that helps you tackle complexity in large Single-Page Applications.

Learn more on [Vue.js - The Progressive JavaScript Framework | Vue.js](https://vuejs.org/).

# Supported tags and respective Dockerfile links
The tag of each `vue` docker image is consist of the version of `vue` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[2.7.16-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/vue/2.7.16/24.03-lts-sp4/Dockerfile) | Vue 2.7.16 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/vue` image from docker

	```bash
	docker pull openeuler/vue:{Tag}
	```

- Run with an interactive shell

	You can also start the container with an interactive shell to use Vue.
	```bash
	docker run -it --rm openeuler/vue:{Tag} bash
	```

- Example: Declarative Rendering

	The following example is taken from the official Vue 2 guide. Vue renders the message to the DOM declaratively.

	index.html
	```html
	<div id="app">
	  {{ message }}
	</div>
	```

	app.js
	```js
	var app = new Vue({
	  el: '#app',
	  data: {
	    message: 'Hello Vue!'
	  }
	})
	```

	Open the page in a browser, and it will render.

- Check container logs

	```bash
	docker logs <container>
	```

- Exec into a running container

	```bash
	docker exec -it <container> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
