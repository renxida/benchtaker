#!/bin/bash 
# This script uses scripts in util to quickly build mlir and onnx-mlir in the workding directory.
# the workding directory is always the parent directory of onnx-mlir.
# This script is designed to be used interactively.
#
# Common issues include:
#   - protobuf compiler not found: run `sudo apt install -y protobuf-compiler`
#   - curses not found: run `sudo apt install -y libncurses-dev`
set -e # exit on error.
git config --global user.name "Xida Ren"
git config --global user.email "cedar.ren@gmail.com"
sudo apt update
sudo apt install -y cmake gcc ninja-build python3-dev protobuf-compiler g++ libncurses-dev
sudo apt install -y linux-tools-common linux-tools-generic linux-tools-`uname -r`
cd safeside
sed -i.bak "s/GRUB_CMDLINE_LINUX='/GRUB_CMDLINE_LINUX='mitigations=off /" /etc/default/grub
sudo update-grub
sudo reboot
#./run01_all_intervals.sh
