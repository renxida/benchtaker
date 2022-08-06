#!/bin/bash
export HOME=/root/
apt update
apt install -y sshpass git
apt install -y build-essential gfortran

# set up the rest
mkdir -p /root/
cd /root/
git clone https://github.com/renxida/benchtaker


set -e # exit on error.
git config --global user.name "Xida Ren"
git config --global user.email "cedar.ren@gmail.com"
apt update
apt install -y cmake gcc ninja-build python3-dev protobuf-compiler g++ libncurses-dev
apt install -y linux-tools-common linux-tools-generic linux-tools-`uname -r`
sed -i.bak "s/GRUB_CMDLINE_LINUX='/GRUB_CMDLINE_LINUX='mitigations=off /" /etc/default/grub
update-grub


# install spec
ssh-keyscan portal.cs.virginia.edu >> ~/.ssh/known_hosts
sshpass -p "Eaaeee3535" scp xr5ry@portal.cs.virginia.edu:/p/csd/SPEC_CPU_2017.tgz ~/

mkdir ~/spec2017_install
tar --directory ~/spec2017_install -xzf ~/SPEC_CPU_2017.tgz
cd ~/spec2017_install
./install.sh -f -d ~/spec2017


cp ~/benchtaker/run_spec2017/benchtaker-4pfc.cfg ~/spec2017/config/

tee ~/spec2017/benchtaker.sh << EOF
cd ~/spec2017
source ./shrc
chmod +x ./benchtaker.sh
for interval in 1 4 16 64 256 1024 4096 16384
do
	./bin/runcpu --define perfinterval=$interval -c benchtaker-4pfc all
done
EOF



tmux new-session -d -s "running" 'cd ~/spec2017 && source ./benchtaker.sh';
