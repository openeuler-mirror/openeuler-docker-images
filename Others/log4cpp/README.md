# Quick reference

- The official log4cpp docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

- Learn more on [Log for C++ Project](http://log4cpp.sourceforge.net/).

# log4cpp | openEuler
Current log4cpp docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Log4cpp is library of C++ classes for flexible logging to files, syslog, IDSA and other destinations. It is modeled after the Log4j Java library, staying as close to their API as is reasonable.

# Supported tags and respective Dockerfile links
The tag of each `log4cpp` docker image is consist of the version of `log4cpp` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                  | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|---------------|
| [2.9.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/log4cpp/2.9.1/24.03-lts-sp4/Dockerfile) | log4cpp 2.9.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/log4cpp` image from docker

	```bash
	docker pull openeuler/log4cpp:{Tag}
	```

- Run with an interactive shell

	Start a container with an interactive shell to build and run your own C++ programs with log4cpp.

	```bash
	docker run -it --rm openeuler/log4cpp:{Tag} bash
	```

- Sample code

	The following simple example is taken from the official website. It logs onto the console and into the file `program.log`.

	main.cpp
	```cpp
	// main.cpp

	#include "log4cpp/Category.hh"
	#include "log4cpp/Appender.hh"
	#include "log4cpp/FileAppender.hh"
	#include "log4cpp/OstreamAppender.hh"
	#include "log4cpp/Layout.hh"
	#include "log4cpp/BasicLayout.hh"
	#include "log4cpp/Priority.hh"

	int main(int argc, char** argv) {
		log4cpp::Appender *appender1 = new log4cpp::OstreamAppender("console", &std::cout);
		appender1->setLayout(new log4cpp::BasicLayout());

		log4cpp::Appender *appender2 = new log4cpp::FileAppender("default", "program.log");
		appender2->setLayout(new log4cpp::BasicLayout());

		log4cpp::Category& root = log4cpp::Category::getRoot();
		root.setPriority(log4cpp::Priority::WARN);
		root.addAppender(appender1);

		log4cpp::Category& sub1 = log4cpp::Category::getInstance(std::string("sub1"));
		sub1.addAppender(appender2);

		// use of functions for logging messages
		root.error("root error");
		root.info("root info");
		sub1.error("sub1 error");
		sub1.warn("sub1 warn");

		// printf-style for logging variables
		root.warn("%d + %d == %s ?", 1, 1, "two");

		// use of streams for logging messages
		root << log4cpp::Priority::ERROR << "Streamed root error";
		root << log4cpp::Priority::INFO << "Streamed root info";
		sub1 << log4cpp::Priority::ERROR << "Streamed sub1 error";
		sub1 << log4cpp::Priority::WARN << "Streamed sub1 warn";

		// or this way:
		root.errorStream() << "Another streamed error";

		return 0;
	}
	```

- Compile and run

	The headers are installed under `/usr/include/orocos` and the shared library name is `orocos-log4cpp`.

	```bash
	g++ main.cpp -I/usr/include/orocos -lorocos-log4cpp -o main
	./main
	```

	Console output for that example:

	```
	1352973121 ERROR  : root error
	1352973121 ERROR sub1 : sub1 error
	1352973121 WARN sub1 : sub1 warn
	1352973121 WARN  : 1 + 1 == two ?
	1352973121 ERROR  : Streamed root error
	1352973121 ERROR sub1 : Streamed sub1 error
	1352973121 WARN sub1 : Streamed sub1 warn
	1352973121 ERROR  : Another streamed error
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
