#https://otland.net/threads/otclient-problems-compiling-on-ubuntu-20.270236/#post-2605780
#https://hydrogenaud.io/index.php?topic=105684.0
#https://mail.gnome.org/archives/mc-devel/2013-January/msg00009.html
#https://spremi.wordpress.com/2014/06/30/cross-compiling-minidlna/
#https://www.fireflymediaserver.net/forums/topic/svn-1303-configure-error-id3_file_open/
#https://github.com/miniupnp/miniupnp/issues/25

FROM alpine:latest

RUN apk update; apk add alpine-sdk autoconf automake gettext-dev gettext-static libtool pkgconfig git zlib-static sqlite-static libjpeg-turbo-static libjpeg-turbo-dev yasm sqlite-dev libid3tag-dev

WORKDIR /
RUN git clone --depth=1 https://github.com/FFmpeg/ffmpeg
WORKDIR /ffmpeg
RUN ./configure --disable-programs --disable-doc --enable-gpl --disable-all --enable-static --enable-avcodec --enable-avformat
RUN make -j
RUN make install

WORKDIR /
RUN git clone --depth=1 https://github.com/libexif/libexif
WORKDIR /libexif
RUN autoreconf -i
RUN ./configure --disable-docs --enable-static
RUN make -j
RUN make install

WORKDIR /
RUN git clone --depth=1 https://github.com/xiph/ogg
WORKDIR /ogg
RUN ./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking
RUN make -j
RUN make install

WORKDIR /
RUN git clone --depth=1 https://github.com/xiph/flac
WORKDIR /flac
RUN ./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking
RUN make -j
RUN make install

WORKDIR /
RUN git clone --depth=1 https://github.com/xiph/vorbis
WORKDIR /vorbis
RUN ./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking
RUN make -j
RUN make install

WORKDIR /
RUN git clone https://git.code.sf.net/p/minidlna/git minidlna-git
WORKDIR /minidlna-git
RUN wget -O /usr/include/sys/queue.h https://raw.githubusercontent.com/libevent/libevent/master/compat/sys/queue.h
RUN autoreconf -i
RUN ./configure --prefix=/output --enable-static
RUN make -j
#RUN make dist
RUN make install
WORKDIR /output
RUN tar -zvcf /minidlna-static.tar.gz .
