#!/bin/bash -eu

pushd /minecraft

# Pull the world data
aws s3 cp s3://guydunton-mc-world-data/world.tar.gz ./

# Pull the contents of world.tar.gz into the current directory
mkdir tempdir
tar -C ./tempdir -zxvf ./world.tar.gz
mv tempdir/* .
rm -rf tempdir
rm world.tar.gz

popd