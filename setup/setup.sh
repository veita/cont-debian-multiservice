#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update -qy
apt-get upgrade -qy
apt-get install -qy locales lsb-release curl gnupg2 less vim screen tmux htop tree

# SSH support
apt-get install -y openssh-server

if [ -f /root/.ssh/authorized_keys ]; then
    sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin prohibit-password|g' /etc/ssh/sshd_config
else
    sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|g' /etc/ssh/sshd_config

    # set the root password to admin
    echo 'root:admin' | chpasswd
fi

apt-get purge -qy --allow-remove-essential systemd systemd-sysv systemd-standalone-sysusers
apt-get autoremove -qy

# global shell configuration
sed -i 's|# "\e\[5~": history-search-backward|"\e\[5~": history-search-backward|g' /etc/inputrc
sed -i 's|# "\e\[6~": history-search-forward|"\e\[6~": history-search-forward|g' /etc/inputrc

sed -i 's|SHELL=/bin/sh|SHELL=/bin/bash|g' /etc/default/useradd

sed -i 's|#force_color_prompt=yes|force_color_prompt=yes|g' /etc/skel/.bashrc

source /setup/user-bashrc.sh >> /etc/skel/.bashrc

# global vim configuration
sed -i 's|"syntax on|syntax on|g' /etc/vim/vimrc
sed -i 's|"set background=dark|set background=dark|g' /etc/vim/vimrc

# global screen configuration
sed -i 's|#startup_message off|startup_message off|g' /etc/screenrc
echo 'shell /bin/bash' >> /etc/screenrc

# shell settings for root
source /setup/root-bashrc.sh >> /root/.bashrc

cp /etc/skel/configure-git.sh /root/

# cleanup
rm -f /services/log/.gitignore
source /setup/cleanup-image.sh
