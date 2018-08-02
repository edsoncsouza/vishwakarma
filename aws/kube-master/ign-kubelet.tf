resource "aws_security_group_rule" "master_ingress_kubelet_secure" {
  type              = "ingress"
  security_group_id = "${aws_security_group.master.id}"

  protocol  = "tcp"
  from_port = 10255
  to_port   = 10255
  self      = true
}

resource "aws_security_group_rule" "master_ingress_kubelet_secure_from_worker" {
  type              = "ingress"
  security_group_id = "${aws_security_group.master.id}"

  protocol    = "tcp"
  cidr_blocks = ["${data.aws_vpc.master.cidr_block}"]
  from_port   = 10255
  to_port     = 10255
}

module "ignition_kubelet" {
  source = "../../ignitions/kubelet"

  kubelet_flag_cloud_provider       = "aws"
  kubelet_flag_cluster_dns          = "${local.cluster_dns_ip}"
  kubelet_flag_node_labels          = "${join(",", var.kube_node_labels)}"
  kubelet_flag_register_with_taints = "${join(",", var.kube_node_taints)}"

  hyperkube = {
    image_path = "quay.io/coreos/hyperkube"
    image_tag  = "${var.version}_coreos.0"
  }
}
