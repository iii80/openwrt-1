FROM scratch
LABEL maintainer="xtoys <echoless@yeah.net>"

ADD rootfs.tar.gz /
COPY banner /etc/banner

ENTRYPOINT  ["/sbin/init"]