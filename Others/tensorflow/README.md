# Quick reference

- The official TensorFlow docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# TensorFlow | openEuler
Current TensorFlow docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

TensorFlow is an end-to-end open source platform for machine learning. It has a comprehensive, flexible ecosystem of tools, libraries, and community resources that lets researchers push the state-of-the-art in ML and developers easily build and deploy ML-powered applications.

Read more on [TensorFlow Website](https://www.tensorflow.org/).

# Supported tags and respective Dockerfile links
The tag of each `tensorflow` docker image is consist of the version of `tensorflow` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.19.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/tensorflow/2.19.0/24.03-lts-sp1/Dockerfile)| TensorFlow 2.19.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/tensorflow` image from docker

	```bash
	docker pull openeuler/tensorflow:{Tag}
	```
 
- Run with an interactive shell

    You can also start the container with an interactive shell to use tensorflow.
    ```
    docker run -it --rm openeuler/tensorflow:{Tag} bash
    ```

- Introduction to Tensorflow with MNIST Example 

    Create a python file named `mnist_example.py` with the following content:
    ```
    import tensorflow as tf
    mnist = tf.keras.datasets.mnist

    (x_train, y_train),(x_test, y_test) = mnist.load_data()
    x_train, x_test = x_train / 255.0, x_test / 255.0

    model = tf.keras.models.Sequential([
      tf.keras.layers.Flatten(input_shape=(28, 28)),
      tf.keras.layers.Dense(128, activation='relu'),
      tf.keras.layers.Dropout(0.2),
      tf.keras.layers.Dense(10, activation='softmax')
    ])

    model.compile(optimizer='adam',
      loss='sparse_categorical_crossentropy',
      metrics=['accuracy'])

    model.fit(x_train, y_train, epochs=5)
    model.evaluate(x_test, y_test)
    ```
  
- Run the file in your terminal:
    ```
    python3 mnist_example.py
    ```

- Expected output(actual numbers may vary slightly):
    ```
    Epoch 1/5
    1875/1875 ━━━━━━━━━━━━━━━━━━━━ 6s 3ms/step - accuracy: 0.8580 - loss: 0.4847     
    Epoch 2/5
    1875/1875 ━━━━━━━━━━━━━━━━━━━━ 5s 3ms/step - accuracy: 0.9551 - loss: 0.1513  
    Epoch 3/5
    1875/1875 ━━━━━━━━━━━━━━━━━━━━ 5s 3ms/step - accuracy: 0.9685 - loss: 0.1068  
    Epoch 4/5
    1875/1875 ━━━━━━━━━━━━━━━━━━━━ 5s 3ms/step - accuracy: 0.9727 - loss: 0.0872  
    Epoch 5/5
    1875/1875 ━━━━━━━━━━━━━━━━━━━━ 5s 3ms/step - accuracy: 0.9773 - loss: 0.0716  
    313/313 ━━━━━━━━━━━━━━━━━━━━ 1s 2ms/step - accuracy: 0.9718 - loss: 0.0870   
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).