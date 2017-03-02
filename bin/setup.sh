#!/bin/bash
# Usage: bin/setup.sh

# Create a virtualenv, and install requirements to it.

# options configurable from the command line
GREP_OPTIONS=--color=never

VENV=$(basename $(pwd))-env
TOPDIR=$(cd $(dirname $BASH_SOURCE) && cd .. && pwd)
PYTHON=$(which python)
REQFILE=$TOPDIR/requirements.txt

if [[ $1 == '-h' || $1 == '--help' ]]; then
    echo "Create a virtualenv and install all pipeline dependencies"
    echo "Options:"
    echo "--venv            - path of virtualenv [$VENV]"
    echo "--python          - path to an alternative python interpreter [$PYTHON]"
    echo "--no-python-deps  - skip installation of python dependencies"
    exit 0
fi

while true; do
    case "$1" in
	--venv ) VENV="$2"; shift 2 ;;
	--python ) PYTHON="$2"; shift 2 ;;
	--no-python-deps ) PYTHON_DEPS=no; shift 1 ;;
	* ) break ;;
    esac
done

set -e

mkdir -p src
test -d $VENV || virtualenv $VENV

source $VENV/bin/activate

# use the absolute path to the virtualenv
VENV=$VIRTUAL_ENV

if [[ -n $PYTHON_DEPS ]]; then
    echo "skipping installation of python dependencies"
else
    # install packages in $REQFILE as well as the virtualenv package
    pip install -U pip virtualenv
    pip install -r "$REQFILE"
    # $VENV/bin/virtualenv -q --relocatable "$VENV"
fi

# Install R libraries
if [[ -f r_packages.txt ]]; then
    packages=$(<r_packages.txt)
    echo "installing R packages: $packages"
    set +e
    rvenv $packages
    set -e
fi

# bin/install_bioc_packages.R
# bin/install_pandoc.sh --prefix $VIRTUAL_ENV --srcdir src --version 1.19.2
