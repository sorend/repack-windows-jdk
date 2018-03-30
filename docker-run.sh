#!/bin/bash -e

if [ -z "$1" ]; then
	echo "Syntax: $0 <jdk-exe>"
	exit 10
fi

PN=$(readlink -e $(dirname "$1"))
FN=$(basename "$1")

docker run -it --rm -u $UID -v "${PN}:/work" sorend/pack-jdk-exe "/work/${FN}"
