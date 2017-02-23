#!/bin/bash

# Install infernal (cmalign) and selected easel binaries to $prefix/bin

set -e

source $(dirname $0)/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('--version', default='1.1.2', help='version [%(default)s]')
parser.add_argument('--prefix', default='/usr/local',
                    help='base dir for install [%(default)s]')
parser.add_argument('--srcdir',
                    help='directory to download and compile source [PREFIX/src]')
EOF

version="$VERSION"
prefix=$(readlink -f "$PREFIX")

if [[ -z $SRCDIR ]]; then
    srcdir="$prefix/src"
else
    srcdir="$SRCDIR"
fi

pandoc_is_installed(){
    "$prefix/bin/pandoc" -h 2> /dev/null | grep -q "PANDOC $VERSION"
}

if pandoc_is_installed; then
    echo "pandoc $VERSION is already installed"
    exit 0
fi

mkdir -p "$srcdir"
cd "$srcdir"

# http://eddylab.org/infernal/infernal-1.1.2-linux-intel-gcc.tar.gz
# https://hackage.haskell.org/package/pandoc-1.19.2
wget -qO- https://get.haskellstack.org/ | sh

PANDOC=pandoc-${VERSION}
wget -nc https://hackage.haskell.org/package/${PANDOC}.tar.gz

tar xvzf ${PANDOC}.tar.gz


# for binary in cmalign cmconvert esl-alimerge esl-sfetch esl-reformat; do
#     tar xvf "${INFERNAL}.tar.gz" --no-anchored "binaries/$binary"
# done
# cp ${INFERNAL}/binaries/* "$prefix/bin"
# rm -r "${INFERNAL}"

# if ! cmalign_is_installed; then
#     echo "error installing cmalign $VERSION" to "$prefix"
#     exit 1
# fi

