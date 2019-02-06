
resource "packet_reserved_ip_block" "elastic_ip-2" {
  project_id = "${var.packet_project_id}"
  quantity   = 1
  facility   = "${var.packet_facility2}"
}

data "template_file" "configure_network-2" {
  template = "${file("templates/configure_network.tpl")}"

  vars = {
    elastic_ip = "${cidrhost(packet_reserved_ip_block.elastic_ip-2.cidr_notation,0)}"
  }
}

# Create a device at the second facility
resource "packet_device" "host-2" {
  hostname         = "${var.packet_facility2}"
  plan             = "t1.small.x86"
  facility         = "${var.packet_facility2}"
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  project_id       = "${var.packet_project_id}"
  user_data        = "${file("user_data")}"

  connection {
    user        = "root"
    private_key = "${file("mykey")}"
  }

  provisioner "file" {
    content     = "${data.template_file.bird_conf.rendered}"
    destination = "/tmp/bird.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.configure_network-2.rendered}"
    destination = "/tmp/configure_network.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.configure_bird.rendered}"
    destination = "/tmp/configure_bird.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y update",
      "apt-get -y install bird",
      "chmod +x /tmp/configure_network.sh",
      "/tmp/configure_network.sh",
      "chmod +x /tmp/configure_bird.sh",
      "/tmp/configure_bird.sh",
    ]
  }
}
