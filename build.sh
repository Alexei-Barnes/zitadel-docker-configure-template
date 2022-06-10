#!/bin/bash

set -eux

# We're going to build zitadel directly from source, so clone it down
git clone git@github.com:zitadel/zitadel.git || true

# We don't need to run tests or a complete release, so comment out the tests and run the build
pushd ./zitadel
sed -i 's/^[^#]\(.*--target go-codecov.*\)$/#\1/g' ./.goreleaser.yaml
goreleaser build --single-target --snapshot --rm-dist

# goreleaser build sadly can't build docker images, and goreleaser release can't do a specified target
# so instead stitch together the docker build here ourselves
mkdir /tmp/zitadel-build || true
cp -f ./build/Dockerfile /tmp/zitadel-build
cp -f ./.artifacts/goreleaser/zitadel_linux_amd64_v1/zitadel /tmp/zitadel-build
pushd /tmp/zitadel-build
docker build . --platform=linux/amd64 -t ghcr.io/zitadel/zitadel:latest-amd64
popd
popd

# OK, we've built zitadel, now we can configure it
pushd ./image
docker build . -t ghcr.io/zitadel/zitadel:configured-latest-amd64

# And cleanup
rm -rf /tmp/zitadel-build
