# dockerOpenCVnR

Docker is a useful means of testing containerized applications. Here, we provide this possibility of testing our `fastVision` application (https://github.com/AtreyaSh/fastVision) within a docker container. Some benefits of this are that one can avoid long, tedious and space-consuming installations into their root folders. A user can then test this application to check if it is of use to them.

The Docker image proposed here contains installations of `OpenCV 3.3.1` and `R`, with useful CRAN packages such as `pdftools`, `png`, `magick` and `tesseract` pre-built and installed.

## Docker Implementation for Ubuntu 16.04

1. Firstly ensure `docker` is installed on your system. Clear instructions are given here: https://docs.docker.com/install/linux/docker-ce/ubuntu/

2. We need to install certain `X Server` dependencies on the host system:

   `$ sudo apt-get install xserver-xorg-core xserver-xorg xorg openbox`
   
3. Clone our `fastVision` and `dockerOpenCVnR` repositories.

   `$ git clone https://github.com/AtreyaSh/fastVision && git clone https://github.com/AtreyaSh/dockerOpenCVnR`

3. Navigate to `/dockerOpenCVnR` and build our docker image from source.

   `$ cd dockerOpenCVnR && docker build -t atreyash/fastvision . && cd ..`

   Note: This will be a long process with ~9 GB of data to be installed.

4. After building the image, we would then need to run our docker image in a container. Since we require GUI services within the container, we have tweaked our container build to assume the same user ID as your current user ie. `uid=1000` and `gid=1000`.  This allows the container to access local X11 services. Here, we assume your working directory contains both cloned git repositories.

   ```
   $ docker run -it --rm \
     -e DISPLAY=$DISPLAY \
     -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
     -v $(pwd)/fastVision:/home/fastVision:rw \
     atreyash/fastvision
   ```
   
   Alternatively, if your working directory is elsewhere, please indicate the absolute path `/path/to/fastVision` to the cloned `/fastVision` directory.
   
   ```
   $ docker run -it --rm \
     -e DISPLAY=$DISPLAY \
     -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
     -v /path/to/fastVision:/home/fastVision:rw \
     atreyash/fastvision
   ```

   This will run the container and mount the existing local `fastVision` directory into the container. The container has read and write permissions for the mounted `/fastVision` directory, meaning you can edit the files within your local machine and these changes will be reflected within the container. Similarly, after processing the image(s) within the container, the reflected changes will appear in your local machine.
   
Happy developing!

## Credits

@schickling for OpenCV Dockerfile template: https://github.com/schickling/dockerfiles

@pkdogcom for Dockerfile template: https://github.com/pkdogcom/opencv-docker

Fabio Rehm's blogpost on GUIs for Docker Containers: http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/

ROS.org Docker Wiki: http://wiki.ros.org/docker/Tutorials/GUI
