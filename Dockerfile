FROM ubuntu:22.04 AS build

RUN apt-get update --quiet --yes && \
    apt-get install --quiet --yes --no-install-recommends \
        autoconf automake autopoint pkgconf libtool libjpeg8-dev \
        build-essential libzip-dev gettext libmicrohttpd-dev \
        libavformat-dev libavcodec-dev libavutil-dev libswscale-dev \
        libavdevice-dev && \
    apt-get --quiet --yes autoremove && \
    apt-get --quiet --yes clean

COPY . /opt/app
WORKDIR /opt/app
RUN autoreconf -fiv && \
    ./configure && \
    make && \
    make install

# FROM 
# RUN useradd --system motion
# USER
