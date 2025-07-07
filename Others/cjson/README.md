# Quick reference

- The official cJSON docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# cJSON | openEuler
Current cJSON docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

cJSON aims to be the dumbest possible parser that you can get your job done with. It's a single file of C, and a single header file.

# Supported tags and respective Dockerfile links
The tag of each `cjson` docker image is consist of the version of `cjson` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                               | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|---------------|
| [1.7.18-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/cjson/1.7.18/24.03-lts-sp1/Dockerfile) | cJSON 1.7.18 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/cjson` image from docker

	```bash
	docker pull openeuler/cjson:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to run your own code using cJSON.
    ```
    docker run -it --rm openeuler/cjson:{Tag} bash
    ```
    
- Sample code

    test.c
    ```
    #include <stdio.h>
    #include <stdlib.h>
    #include <cjson/cJSON.h>

    int main() {
        cJSON *root = cJSON_CreateObject();
        cJSON_AddStringToObject(root, "name", "Alice");
        cJSON_AddNumberToObject(root, "age", 25);

        char *json_str = cJSON_Print(root);
        printf("Generated JSON:\n%s\n", json_str);

        cJSON *parsed = cJSON_Parse(json_str);
        cJSON *name = cJSON_GetObjectItem(parsed, "name");
        printf("Parsed name: %s\n", name->valuestring);

        cJSON_Delete(root);
        cJSON_Delete(parsed);
        free(json_str);
    
        return 0;
    }
    ```
    
- Compilation Instructions
    
    Compile the program using GCC:
    ```
    gcc test.c -lcjson -o test_json
    ```
    
- Running the Program

    ```
    ./test_json
    ```
  
    Expected Output:
    ```
    Generated JSON:
    {
        "name": "Alice",
        "age": 25
    }
    Parsed name: Alice
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).