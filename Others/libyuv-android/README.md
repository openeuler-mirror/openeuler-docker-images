# Quick reference

- The official libyuv-android docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# libyuv-android | openEuler
Current libyuv-android docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

**libyuv** is an open source project that includes YUV scaling and conversion functionality.

* Scale YUV to prepare content for compression, with point, bilinear or box filter.
* Convert to YUV from webcam formats for compression.
* Convert to RGB formats for rendering/effects.
* Rotate by 90/180/270 degrees to adjust for mobile devices in portrait mode.
* Optimized for SSSE3/AVX2 on x86/x64.
* Optimized for Neon/SVE2/SME on Arm.
* Optimized for MSA on Mips.
* Optimized for RVV on RISC-V.

Learn more about libyuv-android on [LibYUV for Android](https://github.com/crow-misia/libyuv-android).

# Supported tags and respective Dockerfile links
The tag of each `libyuv-android` docker image is consist of the version of `libyuv-android` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.44.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/libyuv-android/0.44.0/24.03-lts-sp4/Dockerfile) | libyuv-android 0.44.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/libyuv-android` image from docker

	```bash
	docker pull openeuler/libyuv-android:{Tag}
	```

- Create a file named `example.cpp` with the following content:

	```cpp
	#include <libyuv.h>
	#include <cstdint>
	#include <cstring>
	#include <fstream>
	#include <iostream>

	int main() {
	    const int width = 640;
	    const int height = 480;
	    const int y_size = width * height;
	    const int uv_size = y_size / 2;

	    uint8_t* src_y = new uint8_t[y_size];
	    uint8_t* src_uv = new uint8_t[uv_size];
	    uint8_t* dst_rgb = new uint8_t[width * height * 3];

	    memset(src_y, 0x80, y_size);
	    memset(src_uv, 0x80, uv_size);

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

- Compile the program inside the container

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/libyuv-android:{Tag} g++ /workspace/example.cpp -o /workspace/example -lyuv
	```

- Run the compiled program

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/libyuv-android:{Tag} /workspace/example
	```

- Check the container logs

	```bash
	docker run --rm --name libyuv-android-test -v $(pwd):/workspace openeuler/libyuv-android:{Tag} /workspace/example
	docker logs libyuv-android-test
	```

- Open an interactive shell

	```bash
	docker run -it --rm -v $(pwd):/workspace openeuler/libyuv-android:{Tag} bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
