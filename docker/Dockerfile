FROM scratch
LABEL maintainer="xtoys <echoless@yeah.net>"

ADD rootfs.tar.gz /
COPY ./banner /etc/

ENTRYPOINT  ["/sbin/init"]