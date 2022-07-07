FROM ubuntu:22.04 AS base
RUN apt-get update --quiet --quiet --yes && \
    apt-get install --quiet --quiet --yes --no-install-recommends \
        libjpeg8 libzip4 libmicrohttpd12 ffmpeg libsqlite3-0 \
        && \
    apt-get --quiet --quiet --yes autoremove && \
    apt-get --quiet --quiet --yes clean

FROM base AS build
RUN apt-get update --quiet --quiet --yes && \
    apt-get install --quiet --quiet --yes --no-install-recommends \
        autoconf automake autopoint pkgconf libtool build-essential gettext \
        libjpeg8-dev libzip-dev libmicrohttpd-dev \
        libavformat-dev libavcodec-dev libavutil-dev libswscale-dev \
        libavdevice-dev libsqlite3-dev \
        && \
    apt-get --quiet --quiet --yes autoremove && \
    apt-get --quiet --quiet --yes clean
COPY . /opt/app
WORKDIR /opt/app
RUN autoreconf -fiv
RUN ./configure
RUN make
RUN make install

FROM base
COPY --from=build /usr/local/bin/motionplus /usr/local/bin/motionplus
COPY --from=build /usr/local/share/doc/motionplus /usr/local/share/doc/motionplus
COPY --from=build /usr/local/etc/motionplus /usr/local/etc/motionplus

RUN useradd --system motionplus
USER motionplus

# TODO CMD
