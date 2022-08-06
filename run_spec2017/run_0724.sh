#!/bin/bash
export HOME=/root/
apt update
apt install -y sshpass git
apt install -y build-essential gfortran




# set up the rest
mkdir -p /root/
cd /root/

# install spec
ssh-keyscan portal.cs.virginia.edu >> ~/.ssh/known_hosts
sshpass -p "Eaaeee3535" scp xr5ry@portal.cs.virginia.edu:/p/csd/SPEC_CPU_2017.tgz ~/

mkdir ~/spec2017
tar --directory ~/spec2017_install -xzf ~/SPEC_CPU_2017.tgz
cd ~/spec2017_install
./install.sh -f -d ~/spec2017

cp ./benchtaker.cfg ~/spec2017/config/

tee ~/spec2017/benchtaker.sh << EOF
for interval in 1 4 16 64 256 1024 4096 16384
do
	./bin/runcpu --define perfinterval=$interval -c perfinterval all
done
EOF

cd ~/spec2017
source ./shrc
chmod +x ./benchtaker.sh
source ./benchtaker.sh
