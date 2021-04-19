#!/usr/bin/env bash

set -e

REDHAT_VERSION=$1
DOCKER_VERSION=$2

yum -q list installed  yum-utils  &>/dev/null && echo "Installed" ||yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --setopt="docker-ce-stable.baseurl=https://download.docker.com/linux/centos/$REDHAT_VERSION/x86_64/stable" --save

yum -q list installed slirp4netns &>/dev/null && echo "Installed" || yum install -y  http://mirror.centos.org/centos/$REDHAT_VERSION/extras/x86_64/Packages/slirp4netns-0.4.3-4.el7_8.x86_64.rpm 
yum -q list installed fuse3-libs &>/dev/null && echo "Installed" || yum  install -y install http://mirror.centos.org/centos/$REDHAT_VERSION/extras/x86_64/Packages/fuse3-libs-3.6.1-4.el7.x86_64.rpm 
yum -q list installed fuse3-devel &>/dev/null && echo "Installed" || yum  install -y http://mirror.centos.org/centos/$REDHAT_VERSION/extras/x86_64/Packages/fuse3-devel-3.6.1-4.el7.x86_64.rpm 
yum -q list installed fuse3 &>/dev/null && echo "Installed" || yum  install -y http://mirror.centos.org/centos/$REDHAT_VERSION/extras/x86_64/Packages/fuse3-3.6.1-4.el7.x86_64.rpm 
yum -q list installed fuse-overlayfs &>/dev/null && echo "Installed" || yum  install -y http://mirror.centos.org/centos/$REDHAT_VERSION/extras/x86_64/Packages/fuse-overlayfs-0.7.2-6.el7_8.x86_64.rpm 
yum -q list installed  container-selinux  &>/dev/null && echo "Installed" || yum install -y  http://mirror.centos.org/centos/$REDHAT_VERSION/extras/x86_64/Packages/container-selinux-2.119.2-1.911c772.el7_8.noarch.rpm 
yum -q list installed containerd.io &>/dev/null && echo "Installed" || yum install -y https://download.docker.com/linux/centos/$REDHAT_VERSION/x86_64/stable/Packages/containerd.io-1.4.3-3.1.el7.x86_64.rpm 

yum install -y docker-ce-${DOCKER_VERSION} 

mkdir -p /etc/docker
/bin/cp /tmp/k8sdeploy-scripts/daemon.json /etc/docker
/usr/bin/systemctl enable docker.service 
/usr/bin/systemctl restart docker

