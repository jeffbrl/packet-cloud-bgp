provider "packet" {
  auth_token = "${var.packet_auth_token}"
}

resource "packet_ssh_key" "ssh-key" {
  name       = "mykey"
  public_key = "${file("mykey.pub")}"
}

# Create a device
resource "packet_device" "anycast" {
  hostname         = "tfserver"
  plan             = "t1.small.x86"
  facility         = "${var.packet_facility}"
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
    content     = "${data.template_file.configure_network.rendered}"
    destination = "/tmp/configure_network.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.configure_bird.rendered}"
    destination = "/tmp/configure_bird.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configure_network.sh",
      "/tmp/configure_network.sh",
      "chmod +x /tmp/configure_bird.sh",
      "/tmp/configure_bird.sh",
    ]
  }
}

resource "packet_ip_attachment" "attach_ip" {
  device_id     = "${packet_device.anycast.id}"
  cidr_notation = "${cidrhost(packet_reserved_ip_block.elastic_ip.cidr_notation,0)}/32"
}
