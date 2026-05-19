# Quick reference

- The official ray docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# ray | openEuler
Ray is a unified framework for scaling AI and Python applications. Ray consists of a core distributed runtime and a set of AI libraries for simplifying ML compute:

- Data: Scalable Datasets for ML
- Train: Distributed Training
- Tune: Scalable Hyperparameter Tuning
- RLlib: Scalable Reinforcement Learning
- Serve: Scalable and Programmable Serving

Or more about Ray Core and its key abstractions:

- Tasks: Stateless functions executed in the cluster.
- Actors: Stateful worker processes created in the cluster.
- Objects: Immutable values accessible across the cluster.

Ray runs on any machine, cluster, cloud provider, and Kubernetes, and features a growing ecosystem of community integrations.

Install Ray with: ``pip install ray``.

Learn more about Ray on [Welcome to Ray!](https://docs.ray.io/en/latest/).

# Supported tags and respective Dockerfile links
The tag of each ray docker image is consist of the version of ray and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.55.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/ray/2.55.1/24.03-lts-sp3/Dockerfile) | ray 2.55.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
- Start a Ray head node
  ```
  docker run -d --name ray-head -p 8265:8265 -p 6379:6379 openeuler/ray:2.55.1-oe2403sp3
  ```

- Start a Ray worker connecting to the head node
  ```
  docker run -d --name ray-worker openeuler/ray:2.55.1-oe2403sp3 ray start --address=<head-node-ip>:6379
  ```

- Run a Python script on the Ray cluster
  ```
  docker exec -it ray-head python -c "import ray; ray.init(address='auto'); print(ray.cluster_resources())"
  ```

- Access the Ray Dashboard at `http://localhost:8265`

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).