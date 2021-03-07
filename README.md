# docker-minidlna
This is a dockerfile/Drone.io YAML/build.sh that will build a static minidlnad for x86_64.

It's also a *reasonable* example of what needs to be done to go from Git repo to GitHub release on drone.io. 

## TODO

* Support arm/arm64
* Run strip / release both a debug and non-debug build
* Save the git versions of each module/repo/library used.
* Reproducible build?

## Useful info for other builds
* alpine doesn't ship static libraries for all packages, hence needing ffmpeg/libogg/vorbis/flac from source
* There's a stack of links at the start of build.sh for each issue I hit while building this
* musl libc doesn't ship sys/queue.h, so I borrowed it from libevent

