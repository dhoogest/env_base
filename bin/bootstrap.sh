#!/bin/bash

# Usage: [PYTHON=/path/to/python] bootstrap.sh [virtualenv-name]
#
# Create a virtualenv and install requirements to it
#
# Specify a python interpreter using 'PYTHON=path/to/python boostrap.sh
#
# see bootstrap.sh in genomic_strain_typing repo for example with addl installs
##

# NOTE: If changing compiler options and recompiling, you will likely need to remove existing src
# directories or run `make clean` or something first.
set -e

if [[ -z $1 ]]; then
    venv=env
else
    venv=$1
fi

if [[ -z $PYTHON ]]; then
    PYTHON=$(which python)
fi

src=$venv/src
mkdir -p $src

# Create a virtualenv using a specified version of the virtualenv
# source.  This also provides setuptools and pip.

MKVENV_URL='https://raw.githubusercontent.com/nhoffman/mkvenv/0.1.6/mkvenv/mkvenv.py'

# Download mkvenv source if necessary
if [ ! -f $src/mkvenv.py ]; then
    (cd $src && \
        wget -N $MKVENV_URL)
fi

# Create virtualenv if necessary
if [ ! -f $venv/bin/activate ]; then
    $PYTHON $src/mkvenv.py virtualenv $venv
else
    echo "found existing virtualenv $venv"
fi

source $venv/bin/activate

# full path; set by activate
venv=$VIRTUAL_ENV

# Some dependencies are version-specific and setuptools doesn't play well with them
if [[ -f requirements.txt ]]; then
    pip install -r requirements.txt
fi

# Install R libraries
if [[ -d $venv/lib/python2.7/site-packages/rvenv && -f r_packages.txt ]]; then
    packages=$(<r_packages.txt)
    echo "installing R packages: $packages"
    rvenv $packages
fi


### EXAMPLE LOCAL INSTALL
# # install R locally from source
# if [ ! -f $venv/bin/R ]; then
#     (cd $src && \
#     wget http://cran.fhcrc.org/src/base/R-3/R-3.1.1.tar.gz && \
#     tar -xf R-3.1.1.tar.gz && \
#     cd R-3.1.1 && \
#     ./configure --prefix=$venv --enable-R-shlib && \
#     make && \
#     make install
#     )
# fi

# # install special R packages to the virtualenv
# bin/install_packages.R $venv/lib64/R/library
