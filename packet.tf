provider "packet" {
  auth_token = "${var.packet_auth_token}"
}

resource "packet_ssh_key" "ssh-key" {
  name       = "mykey"
  public_key = "${file("mykey.pub")}"
}
