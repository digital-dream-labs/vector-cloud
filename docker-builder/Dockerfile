FROM golang:buster

RUN dpkg --add-architecture armel

RUN apt-get update && apt-get install -y \
	g++-arm-linux-gnueabi \
	gcc-arm-linux-gnueabi \
	libc6-dev-armhf-cross \
	libopus-dev:armel \
	libogg-dev:armel \
	android-liblog-dev:armel android-liblog:armel \
	upx

ENV GOPATH=/go
ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=7
ENV CGO_ENABLED=1
ENV CC=arm-linux-gnueabi-gcc
#ENV CC=arm-linux-gnueabihf-gcc
ENV PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabi/pkgconfig
ENV CXX="arm-linux-gnueabi-g++-8"
ENV GOCACHE=/tmp