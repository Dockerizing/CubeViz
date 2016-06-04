# Docker container for CubeViz

That is a Docker container for [CubeViz](https://github.com/AKSW/cubeviz.ontowiki) and the source repository for the following [Docker-Hub Repo](https://hub.docker.com/r/aksw/dld-present-cubeviz/).

Its based on [OntoWik](https://hub.docker.com/r/aksw/dld-present-ontowiki/) and installs the CubeViz extension and [Virtuoso 7](http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main) as triplestore.

## Build

Build the docker image with the following command, but first replace `<path/to/project>` with the absolute path to the CubeViz project folder on your host system.

```
cd <path/to/project>
docker build -t aksw/dld-present-cubeviz .
```

## Run

To run the docker execute the following command:

```
docker run -d -p 8080:80 -p 8890:8890 aksw/dld-present-cubeviz
```

With that you publish the Apache port 80 and the Virtuoso port 8890.

In case you want to override the virtuoso db folder, you can use:

```
docker run -d -p 8080:80 -p 8890:8890 -v <path/to/project>CubeViz/data:/var/lib/virtuoso/db aksw/dld-present-cubeviz
```

## Access

After running the container you can access CubeViz in your browser on http://localhost:8080/