# Quick reference

- The official LibYuv docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# LibYuv | openEuler
Current LibYuv docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

LibYuv is an open source project that includes YUV scaling and conversion functionality.

# Supported tags and respective Dockerfile links
The tag of each `libyuv` docker image is consist of the version of `libyuv` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1915-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/libyuv/1915/24.03-lts-sp1/Dockerfile)| LibYuv 1915 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/libyuv` image from docker

	```
	docker pull openeuler/libyuv:{Tag}
	```

- To run and enter the libyuv container with an interactive shell:

	```
	docker run -it --rm openeuler/libyuv:{Tag} bash
	```
 
- Example Code (example.cpp)
    
    This example demonstrates how to use LibYUV to convert an NV12(YUV420SP) image to RGB24 format and save it as a PPM file.

    ```
	#include <libyuv.h>
    #include <iostream>
    #include <fstream>
    #include <cstring>
    
    int main() {
        const int width = 640;
        const int height = 480;
        const int y_size = width * height;
        const int uv_size = y_size / 2;
        
        uint8_t* src_y = new uint8_t[y_size];
        uint8_t* src_uv = new uint8_t[uv_size];
        uint8_t* dst_rgb = new uint8_t[width * height * 3]; // RGB24
        
        memset(src_y, 0x80, y_size);
        memset(src_uv, 0x80, uv_size);
        
        // NV12 转 RGB24
        libyuv::NV12ToRGB24(
            src_y, width,
            src_uv, width,
            dst_rgb, width * 3,
            width, height
        );
        
        std::ofstream out("output.ppm", std::ios::binary);
        out << "P6\n" << width << " " << height << "\n255\n";
        out.write(reinterpret_cast<char*>(dst_rgb), width * height * 3);
        out.close();
  
        delete[] src_y;
        delete[] src_uv;
        delete[] dst_rgb;
        
        std::cout << "YUV to RGB conversion completed!" << std::endl;
        return 0;
    }
    ```
  
- Compilation Command

    ```
    g++ example.cpp -o example -lyuv
	```
    
- Running the Program

    ```
    ./example
    ```
    After execution, the program will:
    * Create a test gray YUV image
    * Convert it to RGB format
    * Save as `output.ppm` in the current directory
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).