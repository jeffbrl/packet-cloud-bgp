
resource "packet_ssh_key" "ssh-key" {
  name       = "mykey"
  public_key = "${file("mykey.pub")}"
}

resource "packet_reserved_ip_block" "elastic_ip" {
  project_id = "${var.packet_project_id}"
  quantity   = 1
  facility   = "${var.packet_facility}"
}

# Create a device at the first facility
resource "packet_device" "hosts" {
  hostname         = "${format("%s-%02d", var.packet_facility, count.index)}"

  plan             = "t1.small.x86"
  facility         = "${var.packet_facility}"
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  project_id       = "${var.packet_project_id}"
  count            = "${var.host-count}"

  connection {
    user        = "root"
    private_key = "${file("mykey")}"
  }
}
