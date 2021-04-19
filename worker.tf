
resource "null_resource" "k8s_worker" {

for_each = toset(var.worker)
    
    provisioner "file" {
    source      = "k8sdeploy-scripts"
    destination = "/tmp"

    connection {
        type        = "ssh"
        user        = "root"
        host     = each.value 
	private_key = file(var.private_key)
        }
  }

  provisioner "remote-exec" {
    inline = [
      <<EOT1
#!/bin/bash
set -e
chmod +x -R /tmp/k8sdeploy-scripts

/usr/sbin/sysctl fs.inotify.max_user_watches=1048576
/tmp/k8sdeploy-scripts/docker-install.sh ${var.redhat_version} ${var.docker_version} && \
/tmp/k8sdeploy-scripts/kubeadm-install.sh ${var.k8s_version} && \
${data.external.kubeadm_join.result.command} && \

mkdir -p $HOME/.kube && scp root@${var.master}:$HOME/.kube/config $HOME/.kube && \
chown $(id -u):$(id -g) $HOME/.kube/config && \
/bin/rm -r /tmp/k8sdeploy-scripts
/usr/bin/kubectl label node ${each.value} node-role.kubernetes.io/worker=worker
/usr/bin/kubectl get nodes

EOT1
    ]
   connection {
                        type        = "ssh"
                        user        = "root"
                        host     = each.value 
                        private_key = file(var.private_key)
                }	
  }
}

