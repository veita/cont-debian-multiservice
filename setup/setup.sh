#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update -qy
apt-get upgrade -qy
apt-get install -qy locales lsb-release curl gnupg2 less vim htop

# global shell configuration
sed -i 's/# "\\e\[5~": history-search-backward/"\\e\[5~": history-search-backward/g' /etc/inputrc
sed -i 's/# "\\e\[6~": history-search-forward/"\\e\[6~": history-search-forward/g' /etc/inputrc

sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd

sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /etc/skel/.bashrc

source /setup/user-bashrc.sh >> /etc/skel/.bashrc

# global vim configuration
sed -i 's/"syntax on/syntax on/g' /etc/vim/vimrc
sed -i 's/"set background=dark/set background=dark/g' /etc/vim/vimrc

# shell settings for root
source /setup/root-bashrc.sh >> /root/.bashrc

# vim settings for root
echo 'set mouse-=a' > /root/.vimrc

cp /etc/skel/configure-git.sh /root/

# set password 'admin' for the root user
echo 'root:admin' | chpasswd

# cleanup
source /setup/cleanup-image.sh
