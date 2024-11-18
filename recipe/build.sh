#!/bin/bash

set -xeuo pipefail

case `uname` in
    Darwin)
	export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib -L$PREFIX/lib"
	;;
    Linux)
	export LDFLAGS="$LDFLAGS -L$PREFIX/lib -liconv"
	;;
esac
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --disable-silent-rules \
	    --enable-jpeg \
	    --enable-png \
	    --enable-xft

make -j${CPU_COUNT} | sed 's|'$PREFIX'|$PREFIX|g'
make check | sed 's|'$PREFIX'|$PREFIX|g'
make DESTDIR=`pwd`/install/ install | sed 's|'$PREFIX'|$PREFIX|g'

mkdir -p $PREFIX/bin
cp -av $SRC_DIR/install/$PREFIX/bin/* $PREFIX/bin
mkdir -p $PREFIX/lib
cp -av $SRC_DIR/install/$PREFIX/lib/* $PREFIX/lib
mkdir -p $PREFIX/include
cp -a $SRC_DIR/install/$PREFIX/include/* $PREFIX/include
mkdir -p $PREFIX/lib
cp -a $SRC_DIR/install/$PREFIX/lib/* $PREFIX/lib
