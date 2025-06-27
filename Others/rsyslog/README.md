# Quick reference

- The official rsyslog docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# rsyslog | openEuler
Current rsyslog docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Rsyslog is a rocket-fast system for log processing.

Learn more about rsyslog on [rsyslog Website](https://www.rsyslog.com)⁠.

# Supported tags and respective Dockerfile links
The tag of each `rsyslog` docker image is consist of the version of `rsyslog` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[8.2504.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/rsyslog/8.2504.0/24.03-lts-sp1/Dockerfile)| rsyslog 8.2504.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/rsyslog` image from docker

	```bash
	docker pull openeuler/rsyslog:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use rsyslog. 
    ```
    docker run -it --rm openeuler/rsyslog:{Tag} bash
    ```

- Basic configration
    
    Run the following command to generate a minimal working configuration.
    ```
    tee /etc/rsyslog.conf <<EOF
    # Basic configuration
    \$ModLoad imuxsock       # Support for local system logging
    \$ModLoad imjournal      # Optional: Support for systemd journal (if used)

    # Log storage paths
    *.info;mail.none;authpriv.none;cron.none  /var/log/messages
    authpriv.*                                /var/log/secure
    mail.*                                    -/var/log/maillog  # `-` for async writing
    cron.*                                    /var/log/cron
    *.emerg                                   :omusrmsg:*        # Broadcast emergency messages

    # Enable modules
    module(load="imfile" PollingInterval="10") # Monitor log files
    EOF
    ```

- Running Rsyslog in debug mode:
    
    To troubleshoot issues, run Rsyslog in debug mode (-dn):
    ```
    rsyslog -dn
    ```
    Debug mode flags:
    * `-d`: Enables debug output.
    * `-n`: Runs in foreground(no daemon mode), showing real-time logs in terminal.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).