# Quick reference

- The official rdkit docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# rdkit | openEuler
The RDKit is a collection of cheminformatics and machine-learning software written in C++ and Python.

- Core data structures and algorithms in C++
- Python 3.x wrapper generated using Boost.Python
- Java and C# wrappers generated with SWIG
- 2D and 3D molecular operations
- Descriptor and Fingerprint generation for machine learning
- Molecular database cartridge for PostgreSQL


# Supported tags and respective Dockerfile links
The tag of each rdkit docker image is consist of the version of rdkit and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2026_03_3-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/rdkit/2026_03_3/24.03-lts-sp4/Dockerfile) | rdkit 2026_03_3 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[2026_03_3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/rdkit/2026_03_3/24.03-lts-sp3/Dockerfile) | rdkit 2026_03_3 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the RDKit cheminformatics environment. You can use it for molecular analysis, descriptor calculation, and machine learning tasks.

Start a Python session with RDKit:

```
docker run -it --name rdkit-dev openeuler/rdkit:{Tag} python3
```

Run a Python script with RDKit from a mounted directory:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/rdkit:{Tag} python3 your_script.py
```

Basic RDKit usage in Python:

```python
from rdkit import Chem
from rdkit.Chem import AllChem, Descriptors

mol = Chem.MolFromSmiles('CCO')
print('Molecular weight:', Descriptors.MolWt(mol))
```

Learn more on [RDKit website](https://www.rdkit.org).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
