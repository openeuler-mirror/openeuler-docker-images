# Quick reference

- The official gadget2 docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# gadget2 | openEuler
Gadget is the Globally applicable Area Disaggregated General Ecosystem Toolbox. Gadget is a statistical model of marine ecosystems. Gadget models can be both very data- and computationally- intensive. Gadget can run complicated statistical ecosystem models, which take many features of the ecosystem into account. Gadget works by running an internal model based on many parameters, and then comparing the data from the output of this model to real data to get a goodness-of-fit likelihood score. These parameters can then be adjusted, and the model re-run, until an optimum is found, which corresponds to the model with the lowest likelihood score. Gadget allows you to include a number of features into your model: one or more species (each of which may be split into multiple stocks), multiple areas with migration between areas, predation between and within species, maturation, reproduction and recruitment, and multiple commercial and survey fleets taking catches from the populations.


# Supported tags and respective Dockerfile links
The tag of each gadget2 docker image is consist of the version of gadget2 and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.3.5-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/gadget2/2.3.5/24.03-lts-sp4/Dockerfile) | gadget2 2.3.5 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[2.3.5-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/gadget2/2.3.5/24.03-lts-sp3/Dockerfile) | gadget2 2.3.5 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
Pull the image:
```
docker pull openeuler/gadget2:{Tag}
```

Show the gadget help screen:
```
docker run --rm openeuler/gadget2:{Tag} gadget -h
```

Run a Gadget model by mounting a local model directory into the container. Replace `/path/to/your/model` with the directory that contains your `main` file and parameter inputs:
```
docker run --rm \
    -v /path/to/your/model:/workspace \
    -w /workspace \
    openeuler/gadget2:{Tag} \
    gadget -main main -i params.in -p params.out
```

Perform a single (simulation) model run:
```
docker run --rm \
    -v /path/to/your/model:/workspace \
    -w /workspace \
    openeuler/gadget2:{Tag} \
    gadget -s -main main -i params.in
```

Perform a likelihood (optimising) model run:
```
docker run --rm \
    -v /path/to/your/model:/workspace \
    -w /workspace \
    openeuler/gadget2:{Tag} \
    gadget -l -main main -i params.in -p params.out -o likelihood.out
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
