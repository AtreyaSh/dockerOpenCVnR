# dockerOpenCVnR

## Docker Implementation

Docker is a useful means of testing containerized applications. Here, we provide this possibility of testing this application in a docker container.

1. To do this, firsty ensure `docker` is installed on your system. Clear instructions are given here: https://docs.docker.com/install/linux/docker-ce/ubuntu/

2. We need to install certain `X Server` dependencies on the host system:

   `$ sudo apt-get install xserver-xorg-core xserver-xorg xorg openbox`

3. Next, within this git repository, navigate to the `/docker` directory and build our docker image from source.

   `$ cd docker && docker build -t atreyash/fastvision . && cd ..`

   Note: This will be a long process with ~9 GB of data to be installed.

4. After building the image, we would then need to run our docker image in a container. Since, we require GUI services within the container, we would need to tweak our container as below. Here, we assume your working directory is the base directory `/fastVision`. 

   `$ docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $(pwd):/home/fastVision:rw  atreyash/fastvision`
   
   Alternatively, if your base directory is elsewhere, please indicate the absolute path to `fastVision`.
   
   `$ docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /path/to/fastVision:/home/fastVision:rw atreyash/fastvision`

   This will run the container and mount the existing local `fastVision` directory into the container. The mounted directory has read and write permissions, meaning you can edit the files within your local machine and these will be reflected within the container. Similarly, after processing the image(s) in the container, the reflected changes will appear in your local machine.

## Developments

1. Secure X11 service for Docker implementation

2. Work on input and output ports for Docker container

## Credits

@schickling for OpenCV Dockerfile template: https://github.com/schickling/dockerfiles

@pkdogcom for Dockerfile template: https://github.com/pkdogcom/opencv-docker

ROS.org Docker Wiki: http://wiki.ros.org/docker/Tutorials/GUI

http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
