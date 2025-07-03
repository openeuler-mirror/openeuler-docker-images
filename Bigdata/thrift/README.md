# Quick reference

- The official thrift docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# thrift | openEuler
Current thrift docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Thrift is a lightweight, language-independent software stack for point-to-point RPC implementation. Thrift provides clean abstractions and implementations for data transport, data serialization, and application level processing. The code generation system takes a simple definition language as input and generates code across programming languages that uses the abstracted stack to build interoperable RPC clients and servers.

For more information about thrift, please visit [https://github.com/apache/thrift](https://github.com/apache/thrift).

# Supported tags and respective Dockerfile links
The tag of each thrift docker image is consist of the version of thrift and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.22.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/thrift/0.22.0/24.03-lts-sp1/Dockerfile)| Thrift 0.22.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Start a thrift instance by following command:
```bash
docker run -it --name thrift openeuler/thrift:latest
```
- Options
```
Usage: thrift [options] file
Options:
  -version    Print the compiler version
  -o dir      Set the output directory for gen-* packages
               (default: current directory)
  -out dir    Set the ouput location for generated files.
               (no gen-* folder will be created)
  -I dir      Add a directory to the list of directories
                searched for include directives
  -nowarn     Suppress all compiler warnings (BAD!)
  -strict     Strict compiler warnings on
  -v[erbose]  Verbose mode
  -r[ecurse]  Also generate included files
  -debug      Parse debug trace to stdout
  --allow-neg-keys  Allow negative field keys (Used to preserve protocol
                compatibility with older .thrift files)
  --allow-64bit-consts  Do not print warnings about using 64-bit constants
  --gen STR   Generate code with a dynamically-registered generator.
                STR has the form language[:key1=val1[,key2[,key3=val3]]].
                Keys and values are options passed to the generator.
                Many options will not require values.
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).