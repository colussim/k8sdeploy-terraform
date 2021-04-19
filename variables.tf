variable "redhat_version" {
  default = "7"
  description = "RedHat Version" 
}

variable "docker_version" {
  default     = "20.10.6-3.el7"
  description = "Docker Version"
}

variable "k8s_version" {
  default = "1.21.0-0.x86_64"
  description = "kubernetes version"
}

variable "master" {
  default = "bandol"
  description = "Hostname master node"
}

variable "nodes" {
  default = 2
  description = "Number of Worker"
}

variable "worker" {
    type = list
    default = ["cabernet1", "sauvignon"]
    description = "Hostname for worker node"
}

variable "clustername" {
  default = "epc-eco"
  description = "K8S Cluster name"
}

variable "user" {
  default = "root"
  description = "Default User for ssh connexion"
}

variable "private_key" {
  type        = string
  default     = "/root/.ssh/id_rsa"
  description = "The path to your private key"
}

