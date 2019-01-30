
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
