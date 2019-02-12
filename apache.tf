
resource "null_resource" "apache" {

    count = "${var.host-count}"

    connection {
        type = "ssh"
        host = "${element(packet_device.hosts.*.access_public_ipv4,count.index)}"
        private_key = "${file("mykey")}"
        agent = false
    }

    provisioner "remote-exec" {
        inline = [
            "apt-get -y update",
            "apt-get -y install apache2",
            "echo `hostname` > /var/www/html/index.html"
        ]
    }
}


