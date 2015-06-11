#!/bin/bash

print_header() {
    echo -e "\n================"
    echo -e $1
    echo -e "================\n"
}

print_header "Updating ubuntu"
sudo apt-get -qq update
sudo apt-get -qq upgrade

print_header "Install ACPID (shutdown)"
sudo apt-get -y install acpid bash-completion

print_header "Blacklisting unused kernel modules"
sudo echo 'blacklist lp' >> /etc/modprobe.d/blacklist.conf
sudo echo 'blacklist parport' >> /etc/modprobe.d/blacklist.conf
sudo echo 'blacklist psmouse' >> /etc/modprobe.d/blacklist.conf
sudo echo 'blacklist floppy' >> /etc/modprobe.d/blacklist.conf
sudo echo 'blacklist ppdev' >> /etc/modprobe.d/blacklist.conf
sudo echo 'blacklist parport_pc' >> /etc/modprobe.d/blacklist.conf
sudo echo 'blacklist rpcsec_gss_krb5' >> /etc/modprobe.d/blacklist.conf

print_header "Commenting out line printer in modules, do you have a line printer?"
sudo sed -e '/lp/ s/^#*/#/' -i /etc/modules

print_header "Time to update initramfs!"
sudo update-initramfs -u

print_header "Configuring grub for faster boot"
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash elevator=noop"' /etc/default/grub

sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/a GRUB_RECORDFAIL_TIMEOUT=2' /etc/default/grub
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/a\# This line prefents from your VM beeing stuck after an unexpected boot.' /etc/default/grub

print_header "Updating grub "
sudo update-grub

print_header "9p and file passthrough"
while true; do
    read -p "Do you wish to use 9p passthrough?" yn
    case $yn in
        [Yy]* ) sudo apt-get -y install linux-image-extra-virtual; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
