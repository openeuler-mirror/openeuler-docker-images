# Kubernetes

## Quick reference

- The official Kubernetes docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

## Build reference

```shell
docker buildx build -t openeuler2k8s/kube-apiserver:v1.20.2-openEuler2109 --build-arg KUBE_BINARY=kube-apiserver --platform=linux/arm64,linux/amd64 . --push
docker buildx build -t openeuler2k8s/kube-controller-manager:v1.20.2-openEuler2109 --build-arg KUBE_BINARY=kube-controller-manager --platform=linux/arm64,linux/amd64 . --push
docker buildx build -t openeuler2k8s/kube-scheduler:v1.20.2-openEuler2109 --build-arg KUBE_BINARY=kube-scheduler --platform=linux/arm64,linux/amd64 . --push
docker buildx build -t openeuler2k8s/kube-proxy:v1.20.2-openEuler2109 --build-arg KUBE_BINARY=kube-proxy --platform=linux/arm64,linux/amd64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

## Deploy Kubernetes

> Kubernetes v1.20.2 on openEuler 21.09 Testing Report

### Before you begin

- Start 3 x86_64 servers and 3 aarch64 servers on HUAWEI CLOUD
- [Install Docker Engine](https://docs.docker.com/engine/install/)
- [Install Kubeadm v1.20.2](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

### Testing Env Table

|       Arch     |  Hostname  | Specification |      EIP       |  Private IP   |
|      :----:    |   :----:   |    :----:     |     :----:     |    :----:     |
| x86_64(amd64)  | amd64-k8s0 |  c6s.large.2  | 116.63.177.179 | 192.168.0.47  |
| x86_64(amd64)  | amd64-k8s1 |  c6s.large.2  | 122.9.153.240  | 192.168.0.28  |
| x86_64(amd64)  | amd64-k8s2 |  c6s.large.2  | 116.63.161.162 | 192.168.0.127 |
| aarch64(arm64) | arm64-k8s0 |  kc1.large.2  | 122.9.151.115  | 192.168.0.2   |
| aarch64(arm64) | arm64-k8s1 |  kc1.large.2  | 139.9.158.136  | 192.168.0.31  |
| aarch64(arm64) | arm64-k8s2 |  kc1.large.2  | 116.63.184.18  | 192.168.0.150 |

### x86_64: Deploy Control Plane

- Hostname: amd64-k8s0

```shell
kubeadm init --image-repository openeuler2k8s --kubernetes-version v1.20.2-openEuler2109
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### x86_64: Deploy Work Plane

- Hostname: amd64-k8s1/amd64-k8s2

```shell
kubeadm join 192.168.0.47:6443 --token 6tcun6.89trlh4tioxkyv3o --discovery-token-ca-cert-hash sha256:cc71b5eeef33f839df3f3eb1242ae7de80247a83bae9698be3c6bf86f8c22433
```

### x86_64: Attach Network Addon

- Hostname: amd64-k8s0

```shell
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.11.1 --namespace kube-system
```

### x86_64: Verify Nodes Status to Ready

- Hostname: amd64-k8s0

```shell
$ kubectl get nodes
NAME          STATUS   ROLES                  AGE    VERSION
amd64-k8s0    Ready    control-plane,master   3m6s   v1.20.2
amd64-k8s1    Ready    <none>                 69s    v1.20.2
amd64-k8s2    Ready    <none>                 49s    v1.20.2
```

### aarch64: Deploy Control Plane

- Hostname: arm64-k8s0

```shell
kubeadm init --image-repository openeuler2k8s --kubernetes-version v1.20.2-openEuler2109
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### aarch64: Deploy Work Plane

- Hostname: arm64-k8s1/arm64-k8s2

```shell
kubeadm join 192.168.0.2:6443 --token lht0xh.6xdhjvqu47ifye1p --discovery-token-ca-cert-hash sha256:7ba9fda1b472596d5ae1521a401af54f7c6daf99b706b02bbffbd8b08e9d0fb7
```

### aarch64: Attach Network Addon

- Hostname: arm64-k8s0

```shell
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.11.1 --namespace kube-system
```

### aarch64: Verify Nodes Status to Ready

- Hostname: arm64-k8s0

```shell
$ kubectl get nodes
NAME            STATUS   ROLES                  AGE     VERSION
aarch64-host0   Ready    control-plane,master   3m36s   v1.20.2
aarch64-host1   Ready    <none>                 2m3s    v1.20.2
aarch64-host2   Ready    <none>                 104s    v1.20.2
```

## Supported tags and respective Dockerfile links

  | Tag                                                                                                                                  | Currently                                    | Architectures |
  |--------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|---------------|
  | [1.20.2-oe2109](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/kubernetes/1.20.2/21.09/Dockerfile)            | kubernetes 1.20.2 on openEuler 21.09         | amd64, arm64  |
  | [1.33.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/kubernetes/1.33.1/24.03-lts-sp1/Dockerfile) | kubernetes 1.33.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

## Operating System

Linux/Unix, aarch64(arm64) or x86_64(amd64) architecture.
