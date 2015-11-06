Docker container for CubeViz
============================

Prerequisite
-----

To clone the complete repository please install the [Git Large File Storage](https://git-lfs.github.com) extension.  
Afterwards, do `git clone https://github.com/Dockerizing/CubeViz.git` as always.

Usage
-----

Build the docker image with the following command, but first replace `<path/to/project>` with the absolute path to the CubeViz project folder on your host system.

```
cd <path/to/project>
docker build -t cubeviz .

```

To run the docker execute the following command:

```

docker run -d -p 8080:80 -p 8890:8890 -v <path/to/project>CubeViz/data:/var/lib/virtuoso/db cubeviz

```
