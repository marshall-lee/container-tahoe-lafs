#!/bin/sh

set -e

basedir=$1
if [ -z $basedir ]; then
    echo "Usage: $0 BASEDIR" >&2
    exit 1
fi

furl=$basedir/private/logport.furl

until [ -s $furl ]; do
    echo "Waiting for ${furl} to be created..." >&2
    sleep 0.5
done

exec flogtool tail -c $furl
