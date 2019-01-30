
resource "packet_reserved_ip_block" "elastic_ip" {
  project_id = "${var.packet_project_id}"
  quantity   = 1
}

data "template_file" "configure_network" {
  template = "${file("templates/configure_network.tpl")}"

  vars = {
    elastic_ip = "${cidrhost(packet_reserved_ip_block.elastic_ip.cidr_notation,0)}"
  }
}

data "template_file" "bird_conf" {
  template = "${file("templates/bird.tpl")}"

  vars = {
    MD5 = "${var.bgp_md5}"
  }
}

data "template_file" "configure_bird" {
  template = "${file("templates/configure_bird.tpl")}"

  vars = {
    token = "${var.packet_auth_token}"
  }
}
