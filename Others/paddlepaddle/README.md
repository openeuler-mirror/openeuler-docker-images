# Quick reference

- The official PaddlePaddle docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# PaddlePaddle | openEuler
Current paddlepaddle docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

PaddlePaddle, as the first independent R&D deep learning platform in China, has been officially open-sourced to professional communities since 2016.

Read more on [PaddlePaddle Website](https://www.paddlepaddle.org.en/).

# Supported tags and respective Dockerfile links
The tag of each `paddlepaddle` docker image is consist of the version of `paddlepaddle` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/paddlepaddle/3.0.0/24.03-lts-sp1/Dockerfile)| PaddlePaddle 3.0.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/paddlepaddle` image from docker

	```bash
	docker pull openeuler/paddlepaddle:{Tag}
	```
 
- Run with an interactive shell

    You can also start the container with an interactive shell to use paddlepaddle.
    ```
    docker run -it --rm openeuler/paddlepaddle:{Tag} bash
    ```

- Introduction to PaddlePaddle with MNIST Example

    This example demonstrates how to use PaddlePaddle to build, train, evaluate, save, and load a simple LeNet-based neural network for the MNIST handwritten digit recognition task.
  
    * Full Example Code
    ```
    import paddle
    import numpy as np
    from paddle.vision.transforms import Normalize

    # 1) Load and transform MNIST dataset
    transform = Normalize(mean=[127.5], std=[127.5], data_format="CHW")
    train_dataset = paddle.vision.datasets.MNIST(mode="train", transform=transform)
    test_dataset = paddle.vision.datasets.MNIST(mode="test", transform=transform)

    # 2) Define the model (LeNet)
    lenet = paddle.vision.models.LeNet(num_classes=10)
    model = paddle.Model(lenet)

    # 3) Configure the training process
    model.prepare(
        paddle.optimizer.Adam(parameters=model.parameters()),
        paddle.nn.CrossEntropyLoss(),
        paddle.metric.Accuracy(),
    )

    # 4) Train the model
    model.fit(train_dataset, epochs=5, batch_size=64, verbose=1)

    # 5) Evaluate the model
    model.evaluate(test_dataset, batch_size=64, verbose=1)

    # 6) Save the trained model
    model.save("./output/mnist")

    # 7) Load the trained model
    model.load("output/mnist")

    # 8) Run inference on a single test image
    img, label = test_dataset[0]
    img_batch = np.expand_dims(img.astype("float32"), axis=0)
    out = model.predict_batch(img_batch)[0]
    pred_label = out.argmax()
    print("True label: {}, Predicted label: {}".format(label[0], pred_label))
    ```

    * Expected output:
    ```
    step 938/938 [==============================] - loss: 0.1575 - acc: 0.9275 - 31ms/step                            
    Epoch 2/5
    step 938/938 [==============================] - loss: 0.0990 - acc: 0.9740 - 32ms/step                            
    Epoch 3/5
    step 938/938 [==============================] - loss: 0.0196 - acc: 0.9792 - 32ms/step                           
    Epoch 4/5
    step 938/938 [==============================] - loss: 0.0052 - acc: 0.9804 - 31ms/step                           
    Epoch 5/5
    step 938/938 [==============================] - loss: 0.0253 - acc: 0.9831 - 32ms/step                               
    Eval begin...
    step 157/157 [==============================] - loss: 3.7890e-04 - acc: 0.9839 - 13ms/step                           
    Eval samples: 10000
    true label: 7, pred label: 7
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).