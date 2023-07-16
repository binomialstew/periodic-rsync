FROM alpine
MAINTAINER Charles Lehnert <Charles@CLLInteractive.com>
ARG VERSION=2.0.0
LABEL version=$VERSION

RUN apk add -U \
  openssh-client \
  rsync \
  tini \
  && rm -rf /var/cache/apk/*

ARG DESTINATION

ENV SCHEDULE="0 * * * *"
ENV DESTINATION=$DESTINATION
ENV VERSION=$VERSION
ENV TARGET=/

VOLUME /data /etc/crontabs

COPY entrypoint.sh rsync.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/crond", "-f", "-d8"]
