#!/bin/sh
#https://otland.net/threads/otclient-problems-compiling-on-ubuntu-20.270236/#post-2605780
#https://hydrogenaud.io/index.php?topic=105684.0
#https://mail.gnome.org/archives/mc-devel/2013-January/msg00009.html
#https://spremi.wordpress.com/2014/06/30/cross-compiling-minidlna/
#https://www.fireflymediaserver.net/forums/topic/svn-1303-configure-error-id3_file_open/
#https://github.com/miniupnp/miniupnp/issues/25

export SRC=$PWD/src/
export OUTPUT=$PWD/output/
export LOGS=$OUTPUT

mkdir -p $OUTPUT $LOGS


{ apk update; apk add alpine-sdk autoconf automake gettext-dev gettext-static libtool pkgconfig zlib-static sqlite-static libjpeg-turbo-static libjpeg-turbo-dev yasm sqlite-dev libid3tag-dev; } >> $LOGS/alpine.log

#Not running in Drone, so we'll need to do the recursive checkout ourselves
if [ -z "${DRONE}" ]; then
	echo Running locally
	apk add git
	mkdir $SRC
	cd $SRC
	git clone --recursive https://github.com/baxterworks-build/docker-minidlna .
fi


cd $SRC/ffmpeg
./configure --disable-programs --disable-doc --enable-gpl --disable-all --enable-static --enable-avcodec --enable-avformat | tee -a $LOGS/ffmpeg.configure.log
{ make -j && make install; } | tee -a $LOGS/ffmpeg.make.log

cd $SRC/libexif
{ autoreconf -i && ./configure --disable-docs --enable-static; } | tee -a $LOGS/libexif.configure.log
{ make -j && make install; } | tee -a $LOGS/libexif.make.log

cd $SRC/ogg
{ ./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking; } | tee -a $LOGS/ogg.configure.log
{ make -j && make install; } | tee -a $LOGS/ogg.make.log

cd $SRC/flac
{ ./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking; } | tee -a $LOGS/flac.configure.log
{ make -j && make install; } | tee -a $LOGS/flac.make.log

cd $SRC/vorbis
{ ./autogen.sh && ./configure --enable-static --disable-shared --disable-dependency-tracking; } | tee -a $LOGS/vorbis.configure.log
{ make -j && make install } | tee -a $LOGS/vorbis.make.log

cd $SRC/minidlna-git
cp -v $SRC/queue.h /usr/include/sys/queue.h
{ autoreconf -i && ./configure --prefix=$OUTPUT --enable-static; } | tee -a $LOGS/minidlna.configure.log
#make dist #How do I generate the changelog that this command requires?
{ make -j && make install; } | tee -a $LOGS/minidlna.make.log

cd $OUTPUT
tar -zvcf $OUTPUT/minidlna-static.tar.gz .
