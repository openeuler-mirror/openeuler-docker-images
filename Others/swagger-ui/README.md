# Quick reference

- The official Swagger UI docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Swagger UI | openEuler
Current Swagger UI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Swagger UI is a collection of HTML, JavaScript, and CSS assets that dynamically generate beautiful documentation from a Swagger-compliant API.

Learn more on [Swagger UI Website](https://swagger.io/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `swagger-ui` docker image is consist of the version of `swagger-ui` and the version of basic image. The details are as follows

| Tag                                                                                                                                   | Currently                                    | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|---------------|
| [5.21.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/swagger-ui/5.21.0/24.03-lts-sp1/Dockerfile) | Swagger UI 5.21.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/swagger-ui` image from docker

	```bash
	docker pull openeuler/swagger-ui:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use swagger-ui.
    ```
    docker run -it --rm openeuler/swagger-ui:{Tag} bash
    ```

- Quick Start Example (HTML Local Version)
    
    1. Prepare a swagger.json
    ```
    {
      "openapi": "3.0.0",
      "info": {
        "title": "Simple API",
        "version": "1.0.0"
      },
      "paths": {
        "/hello": {
          "get": {
            "summary": "Say hello",
            "responses": {
              "200": {
                "description": "Successful response",
                "content": {
                  "application/json": {
                    "example": {
                      "message": "Hello, World!"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    ```
  
    2. Prepare an index.html
    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Swagger UI Example</title>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui.css" />
    </head>
    <body>
      <div id="swagger-ui"></div>
      <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
      <script>
        SwaggerUIBundle({
          url: "./swagger.json", // Point to your OpenAPI file
          dom_id: "#swagger-ui"
        });
      </script>
    </body>
    </html>
    ```
  
    3. Start a static server (optional)
    ```
    python3 -m http.server 8080
    ```
    Then visit:
    ```
    http://localhost:8080/
    ```
    You'll see the interactive Swagger UI page. Click /hello → GET → Try it out → Execute, and it will show the example response.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).