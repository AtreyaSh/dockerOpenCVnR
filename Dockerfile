FROM ubuntu:16.04
LABEL maintainer="Atreya Shankar"
ARG OPENCV_VERSION="3.3.1"

# update packages and install basics
RUN apt-get update && apt-get install -y \
build-essential checkinstall cmake pkg-config yasm \
git gfortran g++ libjpeg8-dev libjasper-dev libpng12-dev libtiff5-dev

# clone opencv git repos
WORKDIR /tmp
RUN git clone https://github.com/opencv/opencv.git && cd opencv && git checkout $OPENCV_VERSION
RUN git clone https://github.com/opencv/opencv_contrib.git && cd opencv_contrib && git checkout $OPENCV_VERSION

# install opencv dependencies
RUN apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
libxine2-dev libv4l-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
qt5-default libgtk2.0-dev libtbb-dev libatlas-base-dev libfaac-dev libmp3lame-dev libtheora-dev \
libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev \
x264 v4l-utils

# install python dependencies
RUN apt-get install -y apt-utils
RUN apt-get install -y python3-dev python3-pip
RUN pip3 install -U pip numpy scipy matplotlib scikit-image scikit-learn

# install R dependencies
RUN apt-get install -y software-properties-common apt-transport-https
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install -y r-base tesseract-ocr libtesseract-dev imagemagick \
libpoppler-cpp-dev openjdk-8-jdk

# create build folder
WORKDIR /tmp/opencv
RUN mkdir /tmp/opencv/build
WORKDIR /tmp/opencv/build

# build openCV
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules ..
RUN make -j3
RUN make install
RUN sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
RUN ldconfig

# clean up and install remaining dependencies
RUN rm -rf /tmp/*
RUN apt-get install -y libcurl4-openssl-dev libmagick++-dev libleptonica-dev nano
RUN R -e 'install.packages("pdftools"); install.packages("tesseract"); install.packages("png"); install.packages("magick")'
RUN apt-get install -y libcanberra-gtk-module libcanberra-gtk3-module

# change permissions to run via same user as host
WORKDIR /home
RUN export uid=1000 gid=1000 && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home

USER developer
CMD ["bash"]
