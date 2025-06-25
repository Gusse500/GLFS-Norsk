#!/bin/sh
bs_version=$(cat NVIDIA-sysv-bootscripts/version)
cp -vR NVIDIA-sysv-bootscripts{,-$bs_version}
tar -cJvf ./NVIDIA-sysv-bootscripts-$bs_version.tar.xz \
            NVIDIA-sysv-bootscripts-$bs_version
rm -rf NVIDIA-sysv-bootscripts-$bs_version
