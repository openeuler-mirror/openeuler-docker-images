# Quick reference

- The official React docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# React | openEuler
Current React docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

React is a JavaScript library for creating user interfaces.

Learn more on [react Documentation](https://react.dev/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `react` docker image is consist of the version of `react` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                               | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|---------------|
|[19.1.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/react/19.1.1/24.03-lts-sp2/Dockerfile) | react 19.1.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
| [19.1.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/react/19.1.0/24.03-lts-sp1/Dockerfile) | React 19.1.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/react` image from docker

	```bash
	docker pull openeuler/react:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use React.
    ```
    docker run -it --rm openeuler/react:{Tag} bash
    ```

- Example: A Simple React Counter
    
    This code demonstrates a basic React counter component that:
    * Tracks a numeric count value
    * Provides a button to increment the count
    * Displays the current count value
    ```
    import { useState } from 'react';
    import { createRoot } from 'react-dom/client';
    
    function Counter() {
      const [count, setCount] = useState(0);
      return (
        <>
          <h1>{count}</h1>
          <button onClick={() => setCount(count + 1)}>
            Increment
          </button>
        </>
      );
    }
    
    const root = createRoot(document.getElementById('root'));
    root.render(<Counter />);
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).