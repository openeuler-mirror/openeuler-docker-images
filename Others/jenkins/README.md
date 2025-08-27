# Quick reference

- The official Jenkins docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Jenkins | openEuler
Current Jenkins docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

Learn more about Jenkins on [Jenkins documentation](https://www.jenkins.io/doc/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `jenkins` docker image is consist of the version of `jenkins` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
|[2.525-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jenkins/2.525/24.03-lts-sp1/Dockerfile) | jenkins 2.525 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [2.502-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jenkins/2.502/24.03-lts-sp1/Dockerfile) | Jenkins 2.502 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [2.523-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jenkins/2.523/24.03-lts-sp1/Dockerfile) | Jenkins 2.523 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [2.524-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jenkins/2.524/24.03-lts-sp2/Dockerfile) | Jenkins 2.524 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Start a jenkins instance

    ```bash
    docker run -d --name my-jenkins -p 8080:8080 openeuler/jenkins:{Tag}
    ```
 
    1. Browse to http://localhost:8080 (or whichever port you configured for Jenkins when installing it) and wait until the Unlock Jenkins page appears.
    2. From the Jenkins console log output, copy the automatically-generated alphanumeric password (between the 2 sets of asterisks).
        ```
        ......
        2025-08-20 01:40:48.403+0000 [id=45]    INFO    jenkins.install.SetupWizard#init: 
    
        *************************************************************
        *************************************************************
        *************************************************************
        
        Jenkins initial setup is required. An admin user has been created and a password generated.
        Please use the following password to proceed to installation:
        
        be31b4b99afe42538822ffce31fa8103
        
        This may also be found at: /root/.jenkins/secrets/initialAdminPassword
        
        *************************************************************
        *************************************************************
        *************************************************************
        
        2025-08-20 01:40:53.216+0000 [id=45]    INFO    jenkins.InitReactorRunner$1#onAttained: Completed initialization
        ......
        ```

- View container running logs

    ```bash
    docker logs -f my-jenkins
    ```

- To get an interactive shell

    ```bash
    docker exec -it my-jenkins bash
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).