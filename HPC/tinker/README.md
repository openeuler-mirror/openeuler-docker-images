# Quick reference

- The official Tinker docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Tinker | openEuler
Tinker is a complete and general package for molecular mechanics and dynamics, with some special features for biopolymers. Tinker has the ability to use any of several common parameter sets, such as Amber (ff94, ff96, ff98, ff99, ff99SB, ff14SB, ff19SB), CHARMM (19, 22, 27, 36m), Allinger MM (MM2-1991 and MM3-2000), OPLS (OPLS-UA, OPLS-AA, OPLS-AA/L), Merck Molecular Force Field (MMFF94, MMFF94s), Liam Dang's polarizable model, and the AMOEBA, AMOEBA+ and HIPPO polarizable atomic multipole force fields. Parameter sets for other widely-used force fields are under consideration for future releases.

The Tinker software contains a variety of interesting algorithms such as: flexible molecular dynamics (MD) simulation capability, support for atomic multipole-based electrostatics with explicit dipole polarizability, various continuum solvation treatments including several generalized Born (GB/SA) models, generalized Kirkwood implicit solvation for AMOEBA, an interface to APBS for Poisson-Boltzmann calculations, efficient truncated Newton (TNCG) local optimization, fast Alpha shapes-based surface areas and volumes with derivatives, free energy calculations via the Bennett Acceptance Ratio (BAR) method, normal mode vibrational analysis, minimization in Cartesian, torsional or rigid body space, symplectic RESPA multiple time step integration for efficient MD, velocity Verlet stochastic dynamics, several thermostats and barostats for MD temperature and pressure control, pairwise neighbor lists and splined spherical energy cutoff methods, particle mesh Ewald (PME) summation for partial charges and polarizable multipoles, a novel reaction field treatment of long range electrostatics, fast distance geometry metrization with better sampling than standard methods, Elber's reaction path algorithm, potential smoothing and search (PSS) methods for global optimization, Monte Carlo Minimization (MCM) for potential surface scanning, force field parameterization tools for fitting electrostatic potentials, multipole and polarization models to QM-based data, and more.

The force field parameter sets are installed under `/opt/tinker/params`, and the example files are installed under `/opt/tinker/example`.

Learn more on [Tinker Molecular Modeling Package](https://dasher.wustl.edu/tinker/).

# Supported tags and respective Dockerfile links
The tag of each Tinker docker image is consist of the version of Tinker and the version of basic image. The details are as follows:
| Tags | Currently |  Architectures|
|--|--|--|
|[26.1.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/tinker/26.1.2/24.03-lts-sp4/Dockerfile) | Tinker 26.1.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Tinker docker image from DockerHub:
	```docker pull openeuler/tinker:{Tag}```
- Run the Docker container to launch the Tinker environment:
	```docker run -it openeuler/tinker:{Tag}```
- View the logs of a running container:
	```docker logs <container>```
- Open an interactive shell inside a running container:
	```docker exec -it <container> bash```
- Verify the installation inside the container:
	```which analyze```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
