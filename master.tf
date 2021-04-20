resource "null_resource" "k8s_master" {

	provisioner "local-exec" {
		command = "$PWD/k8sdeploy-scripts/setk8sconfig.sh ${var.clustername}"
  	}


	provisioner "file" {
    		source      = "k8sdeploy-scripts"
    		destination = "/tmp"

    		connection {
    			type        = "ssh"
    			user        = "root"
			host     = var.master
			private_key = file(var.private_key)
  		}
  	}

	provisioner "remote-exec" {
    		inline = [
      		<<EOT
#!/bin/bash
set -e
chmod +x -R /tmp/k8sdeploy-scripts
/usr/sbin/sysctl fs.inotify.max_user_watches=1048576
/tmp/k8sdeploy-scripts/docker-install.sh ${var.redhat_version} ${var.docker_version} && \
/tmp/k8sdeploy-scripts/kubeadm-install.sh ${var.k8s_version} && \

/usr/bin/kubeadm init --config /tmp/k8sdeploy-scripts/setk8sconfig.yaml && \

mkdir -p $HOME/.kube && /bin/cp /etc/kubernetes/admin.conf $HOME/.kube/config && \
chown $(id -u):$(id -g) $HOME/.kube/config && \

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" && \
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml" && \
kubectl apply -f /tmp/k8sdeploy-scripts/clusteradmin.yaml && \
/bin/rm -r /tmp/k8sdeploy-scripts


EOT
    		]
	connection {
                        type        = "ssh"
                        user        = "root"
                        host     = var.master
                        private_key = file(var.private_key)
                }
  	}
	provisioner "local-exec" {
    		command    = "./k8sdeploy-scripts/getkubectl-conf.sh ${var.master}"
  	}
}

data "external" "kubeadm_join" {
  program = ["./k8sdeploy-scripts/kubeadm-token.sh"]

  query = {
    host = var.master
  }
  depends_on = [null_resource.k8s_master]

}
