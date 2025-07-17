# Quick reference

- The official Caffe docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Caffe | openEuler
Current Caffe docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Caffe is a deep learning framework made with expression, speed, and modularity in mind.

Learn more about on [Caffe Website](https://caffe.berkeleyvision.org/).

# Supported tags and respective Dockerfile links
The tag of each `caffe` docker image is consist of the complete software stack version. The details are as follows

| Tag                                                                                                                    | Currently                            | Architectures |
|------------------------------------------------------------------------------------------------------------------------|--------------------------------------|---------------|
| [1.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/caffe/1.0/24.03-lts-sp1/Dockerfile) | Caffe 1.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/caffe` image from docker

	```
	docker pull openeuler/caffe:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use caffe.
    ```
    docker run -it --rm openeuler/caffe:{Tag} bash
    ```

- How to train LeNet on MNIST with BVLC Caffe (CPU/GPU)

    - Download the MNIST dataset manually(mirror)
  
        In your container, go to mnist directory:
	    ```
	    cd /opt/caffe/data/mnist
	    ```
        
        Download the files from a reliable public mirror:
        ```
        wget https://ossci-datasets.s3.amazonaws.com/mnist/train-images-idx3-ubyte.gz
        wget https://ossci-datasets.s3.amazonaws.com/mnist/train-labels-idx1-ubyte.gz
        wget https://ossci-datasets.s3.amazonaws.com/mnist/t10k-images-idx3-ubyte.gz
        wget https://ossci-datasets.s3.amazonaws.com/mnist/t10k-labels-idx1-ubyte.gz
        ```
      
        Uncompress the files:
        ```
        gzip -d *.gz
        ```
    
    - Convert the dataset to LMDB
    
        Switch to the Caffe root directory and run:
        ```
        cd /opt/caffe
        ./examples/mnist/create_mnist.sh
        ```
        This script converts the raw MNIST files to LMDB format which Caffe uses for training.
  
    - Check the solver configuration
        
        Open the solver prototxt file:
        ```
        vi ./examples/mnist/lenet_solver.prototxt
        ```
        Make sure the last line matches your build:
        ```
        solver_mode: CPU   # For CPU-only Caffe builds
        ```
        or
        ```
        solver_mode: GPU   # For Caffe built with CUDA/cuDNN
        ```
      
    - Train the model
    
        Finally, run the training command:
        ```
        ./build/tools/caffe train --solver=examples/mnist/lenet_solver.prototxt
        ```
        Caffe will start training the LeNet model on the MNIST dataset.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
