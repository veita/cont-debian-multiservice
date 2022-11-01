#!/bin/bash

set -ex

cd "${0%/*}"

SUITE=${1:-bullseye}
CONT=$(buildah from debian:${SUITE})

buildah copy $CONT etc/ /etc
buildah copy $CONT root/ /root
buildah copy $CONT services/ /services

buildah copy $CONT setup/ /setup
buildah run $CONT /bin/bash /setup/setup.sh
buildah run $CONT rm -rf /setup

buildah config --workingdir '/' $CONT
buildah config --cmd '["/services/init.sh"]' $CONT

buildah config --author "Alexander Veit" $CONT
buildah config --label commit=$(git describe --always --tags --dirty=-dirty) $CONT

buildah commit --rm $CONT localhost/debian-multiservice-${SUITE}:latest

