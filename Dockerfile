#originally build.sh was this dockerfile, but making it another file allows me to build and publish from cloud.drone.io

FROM alpine:latest
COPY build.sh /tmp/
RUN chmod +x /tmp/build.sh; sh /tmp/build.sh
