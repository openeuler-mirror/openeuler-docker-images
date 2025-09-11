# Quick reference

- The official strongSwan docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# strongSwan | openEuler
Current strongSwan images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

strongSwan is an OpenSource IPsec-based VPN solution.

Read more on [strongSwan Documentation](https://www.strongswan.org/documentation.html).

# Supported tags and respective dockerfile links
The tag of each `strongSwan` docker image is consist of the version of `strongSwan` and the version of basic image. The details are as follows

| Tag                                                                                                                                | Currently                                   | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
|[6.0.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/strongswan/6.0.2/24.03-lts-sp2/Dockerfile) | strongswan 6.0.2 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
| [6.0.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/strongswan/6.0.1/24.03-lts-sp1/Dockerfile) | strongSwan 6.0.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/strongswan` image from docker

	```
	docker pull openeuler/strongswan:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use strongSwan.
    ```
    docker run -it --rm --privileged openeuler/strongswan:{Tag} bash
    ```
    **Note:** The `--privileged` flag is required to allow strongSwan to create and manage network interfaces inside the container.
  
- Create your VPN configuration file
  
    Create or edit `/usr/local/etc/swanctl/swanctl.conf` with the following content(replace IPs and secret as needed):
    ```
    connections {
      myvpn {
        local_addrs  = 192.0.2.1
        remote_addrs = 198.51.100.1
    
        local {
          auth = psk
          id = 192.0.2.1
        }
        remote {
          auth = psk
          id = 198.51.100.1
        }
    
        children {
          net {
            local_ts  = 0.0.0.0/0
            remote_ts = 0.0.0.0/0
          }
        }
    
        version = 2
        proposals = aes256-sha256-modp2048
      }
    }
    
    secrets {
      ike-myvpn {
        id-1 = 192.0.2.1
        id-2 = 198.51.100.1
        secret = "mysecret"
      }
    }
    ```

- Start the strongSwan IKEv2 daemon(charon)
   
    In the container, run `charon` in the background with debugging enabled:
    ```   
    /usr/local/libexec/ipsec/charon --debug-dmn 2 --debug-ike 3 &
    ```
    * `--debug-dm 2`: Sets daemon debug level to info.
    * `--debug-ike 3`: Sets IKE protocol debug level to detailed. 
    
- Load the configuration

    Run:
    ```
    swanctl --load-all
    ```
    
    Expected output:
    ```
    ......
    successfully loaded 1 connections, 0 unloaded
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).