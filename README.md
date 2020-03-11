# About

Simple docker image for [calibre-web](https://github.com/janeczku/calibre-web)

Calibre-Web is a web app providing a clean interface for browsing, reading and downloading eBooks using an existing [Calibre](https://calibre-ebook.com) database.

Several docker images exists for this application, but they rely on a complex structure and a Internet connection at container start (for updating the OS and application). As I was using this application in a shop with intermittent Internet connection, it was not possible to use theses.

## Quick start

1. Create a folder that will store the configuration databases of calibre-web, at first run the image will populate it with default databases
2. Run the container `docker run --rm -d -v /local/path/to/calibre-web/config:/config -v /local/path/to/calibre/library:/books -p 8080:8083 -e PUSER=$(id -u) -e PGROUP=$(id -g) marema31/calibre-web`.
1. Point your browser to `http://localhost:8083` or `http://localhost:8083/opds` for the OPDS catalog

**Default admin login:**\
*Username:* admin\
*Password:* admin123

## Other Docker Images

More complete Pre-built Docker images are available in these Docker Hub repositories:

#### **Technosoft2000 - x64**
+ Docker Hub - [https://hub.docker.com/r/technosoft2000/calibre-web/](https://hub.docker.com/r/technosoft2000/calibre-web/)
+ Github - [https://github.com/Technosoft2000/docker-calibre-web](https://github.com/Technosoft2000/docker-calibre-web) 

 
#### **LinuxServer - x64, armhf, aarch64**
+ Docker Hub - [https://hub.docker.com/r/linuxserver/calibre-web/](https://hub.docker.com/r/linuxserver/calibre-web/)
+ Github - [https://github.com/linuxserver/docker-calibre-web](https://github.com/linuxserver/docker-calibre-web)
+ Github - (Optional Calibre layer) - [https://github.com/linuxserver/docker-calibre-web/tree/calibre](https://github.com/linuxserver/docker-calibre-web/tree/calibre) 

    
   Both the Calibre-Web and Calibre-Mod images are rebuilt automatically on new releases of Calibre-Web and Calibre respectively, and on updates to any included base image packages on a weekly basis if required.
   + The "path to convertertool" should be set to `/usr/bin/ebook-convert`
   + The "path to unrar" should be set to `/usr/bin/unrar`

