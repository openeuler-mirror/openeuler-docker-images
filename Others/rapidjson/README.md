# Quick reference

- The official rapidjson docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

- Learn more on [RapidJSON: Main Page](http://rapidjson.org/).

# rapidjson | openEuler
Current rapidjson docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

RapidJSON is a JSON parser and generator for C++. It was inspired by RapidXml.

- RapidJSON is **small** but **complete**. It supports both SAX and DOM style API. The SAX parser is only a half thousand lines of code.

- RapidJSON is **fast**. Its performance can be comparable to `strlen()`. It also optionally supports SSE2/SSE4.2 for acceleration.

- RapidJSON is **self-contained** and **header-only**. It does not depend on external libraries such as BOOST. It even does not depend on STL.

- RapidJSON is **memory-friendly**. Each JSON value occupies exactly 16 bytes for most 32/64-bit machines (excluding text string). By default it uses a fast memory allocator, and the parser allocates memory compactly during parsing.

- RapidJSON is **Unicode-friendly**. It supports UTF-8, UTF-16, UTF-32 (LE & BE), and their detection, validation and transcoding internally. For example, you can read a UTF-8 file and let RapidJSON transcode the JSON strings into UTF-16 in the DOM. It also supports surrogates and "\u0000" (null character).

# Supported tags and respective Dockerfile links
The tag of each rapidjson docker image is consist of the version of rapidjson and the version of basic image. The details are as follows

| Tag                                                                                                                            | Currently                            | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|---------------|
|[1.1.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/rapidjson/1.1.0/24.03-lts-sp4/Dockerfile) | rapidjson 1.1.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/rapidjson` image from docker

	```bash
	docker pull openeuler/rapidjson:{Tag}
	```

- Run with an interactive shell

	Start a container with an interactive shell to build and run your own C++ programs with RapidJSON.

	```bash
	docker run -it --rm openeuler/rapidjson:{Tag} bash
	```

- Sample code

	The following simple example is taken from the official `simpledom` example. It parses a JSON string into a document (DOM), makes a simple modification of the DOM, and finally stringifies the DOM to a JSON string.

	test.cpp
	```cpp
	#include "rapidjson/document.h"
	#include "rapidjson/writer.h"
	#include "rapidjson/stringbuffer.h"
	#include <iostream>

	using namespace rapidjson;

	int main() {
	    const char* json = "{\"project\":\"rapidjson\",\"stars\":10}";
	    Document d;
	    d.Parse(json);

	    // 2. Modify it by DOM.
	    Value& s = d["stars"];
	    s.SetInt(s.GetInt() + 1);

	    // 3. Stringify the DOM
	    StringBuffer buffer;
	    Writer<StringBuffer> writer(buffer);
	    d.Accept(writer);

	    // Output {"project":"rapidjson","stars":11}
	    std::cout << buffer.GetString() << std::endl;
	    return 0;
	}
	```

- Compile and run

	```bash
	g++ -std=c++11 test.cpp -o test
	./test
	```

	Expected output:

	```
	{"project":"rapidjson","stars":11}
	```

- Check container logs

	```bash
	docker logs <container>
	```

- Exec into a running container

	```bash
	docker exec -it <container> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
