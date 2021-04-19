#!/usr/bin/env bash

K8_VERSION=${1}

set -e
/bin/cp /tmp/k8sdeploy-scripts/kubernetes.repo  /etc/yum.repos.d
yum install -y kubelet-${K8_VERSION} kubeadm-${K8_VERSION} kubectl-${K8_VERSION} 
/usr/bin/systemctl enable kubelet.service
/usr/bin/systemctl restart kubelet 

