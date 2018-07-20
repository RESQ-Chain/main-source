#!/bin/bash

set -e

date

#################################################################
# Update Ubuntu and install prerequisites for running renesis   #
#################################################################
sudo apt-get update
#################################################################
# Build renesis from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building renesis           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

# By default, assume running within repo
repo=$(pwd)
file=$repo/src/renesisd
if [ ! -e "$file" ]; then
	# Now assume running outside and repo has been downloaded and named renesis
	if [ ! -e "$repo/renesis/build.sh" ]; then
		# if not, download the repo and name it renesis
		git clone https://github.com/renesisd/source renesis
	fi
	repo=$repo/renesis
	file=$repo/src/renesisd
	cd $repo/src/
fi
make -j$NPROC -f makefile.unix

cp $repo/src/renesisd /usr/bin/renesisd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.renesis
if [ ! -e "$file" ]
then
        mkdir $HOME/.renesis
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | tee $HOME/.renesis/renesis.conf
file=/etc/init.d/renesis
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo renesisd' | sudo tee /etc/init.d/renesis
        sudo chmod +x /etc/init.d/renesis
        sudo update-rc.d renesis defaults
fi

/usr/bin/renesisd
echo "renesis has been setup successfully and is running..."

