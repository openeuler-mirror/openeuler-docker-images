# Quick reference

- The official ansible docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Ansible | openEuler
Current ansible docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Ansible is a radically simple IT automation system. It handles configuration management, application deployment, cloud provisioning, ad-hoc task execution, network automation, and multi-node orchestration. Ansible makes complex changes like zero-downtime rolling updates with load balancers easy.

Learn more on [Ansible Collaborative](https://www.ansible.com/).

# Supported tags and respective Dockerfile links
The tag of each `ansible` docker image is consist of the version of `ansible-core` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.21.4-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/ansible/2.21.4/24.03-lts-sp4/Dockerfile) | ansible-core 2.21.4 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/ansible` image from docker

	```bash
	docker pull openeuler/ansible:{Tag}
	```

- Check the installed Ansible version

	```bash
	docker run --rm openeuler/ansible:{Tag} ansible --version
	```

- Run an Ansible ad-hoc command

	Create an inventory file named `inventory` in the current directory:

	```
	[web]
	192.168.1.10
	```

	Then run:

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/ansible:{Tag} \
	    ansible web -i inventory -m ping
	```

- Run an Ansible playbook

	Create a playbook named `site.yml` in the current directory:

	```yaml
	- name: Ping all hosts
	  hosts: web
	  tasks:
	    - name: Ping
	      ansible.builtin.ping:
	```

	Then run:

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/ansible:{Tag} \
	    ansible-playbook -i inventory site.yml
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-ansible openeuler/ansible:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-ansible
	```

- To get an interactive shell

	```bash
	docker exec -it my-ansible bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
