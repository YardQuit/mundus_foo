#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install --skip-unavailable -y $(cat /ctx/rpm_packages)

# this installs package from copr repos
dnf5 -y copr enable atim/starship
dnf5 -y copr enable pennbauman/ports

dnf5 -y install starship
dnf5 -y install lf

dnf5 -y copr disable atim/starship
dnf5 -y copr disable pennbauman/ports

#### Example for enabling a System Unit File
systemctl enable tuned.service
systemctl enable podman.socket
systemctl enable fstrim.timer
systemctl enable firewalld.service
systemctl enable tailscaled.service

### Change default firewalld zone
cp /etc/firewalld/firewalld-workstation.conf /etc/firewalld/firewalld-workstation.conf.bak
sed -i 's/DefaultZone=FedoraWorkstation/DefaultZone=drop/g' /etc/firewalld/firewalld-workstation.conf

### Create missing dirs
mkdir -p /var/spool/anacron
