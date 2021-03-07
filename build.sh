#!/bin/sh
#https://otland.net/threads/otclient-problems-compiling-on-ubuntu-20.270236/#post-2605780
#https://hydrogenaud.io/index.php?topic=105684.0
#https://mail.gnome.org/archives/mc-devel/2013-January/msg00009.html
#https://spremi.wordpress.com/2014/06/30/cross-compiling-minidlna/
#https://www.fireflymediaserver.net/forums/topic/svn-1303-configure-error-id3_file_open/
#https://github.com/miniupnp/miniupnp/issues/25

export SRC=/src
mkdir -p $SRC

apk update; apk add alpine-sdk autoconf automake gettext-dev gettext-static libtool pkgconfig git zlib-static sqlite-static libjpeg-turbo-static libjpeg-turbo-dev yasm sqlite-dev libid3tag-dev

cd $SRC
git clone --depth=1 https://github.com/FFmpeg/ffmpeg
cd $SRC/ffmpeg
./configure --disable-programs --disable-doc --enable-gpl --disable-all --enable-static --enable-avcodec --enable-avformat
make -j
make install
cd $SRC

git clone --depth=1 https://github.com/libexif/libexif
cd $SRC/libexif
autoreconf -i
./configure --disable-docs --enable-static
make -j
make install
cd $SRC

git clone --depth=1 https://github.com/xiph/ogg
cd $SRC/ogg
./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking
make -j
make install
cd $SRC

git clone --depth=1 https://github.com/xiph/flac
cd $SRC/flac
./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking
make -j
make install
cd $SRC

git clone --depth=1 https://github.com/xiph/vorbis
cd $SRC/vorbis
./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking
make -j
make install
cd $SRC

git clone https://git.code.sf.net/p/minidlna/git minidlna-git
cd $SRC/minidlna-git
wget -O /usr/include/sys/queue.h https://raw.githubusercontent.com/libevent/libevent/master/compat/sys/queue.h
autoreconf -i
./configure --prefix=/output --enable-static
make -j
#make dist #How do I generate the changelog that this command requires?
make install
cd $SRC

cd /output
tar -zvcf /minidlna-static.tar.gz .