resource "packet_ssh_key" "ssh-key" {
  name       = "mykey"
  public_key = "${file("mykey.pub")}"
}

resource "packet_reserved_ip_block" "elastic_ip" {
  project_id = "${var.packet_project_id}"
  quantity   = 1
  facility   = "${var.packet_facility}"
}

data "template_file" "configure_network" {
  template = "${file("templates/configure_network.tpl")}"

  vars = {
    elastic_ip = "${cidrhost(packet_reserved_ip_block.elastic_ip.cidr_notation,0)}"
  }
}

# Create a device at the first facility
resource "packet_device" "host" {
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

data "template_file" "interface_lo0" {

    template = <<EOF

auto lo:0
iface lo:0 inet static
   address $${floating_ip}
   netmask $${floating_netmask}
EOF

    vars = {
        floating_ip       = "${packet_reserved_ip_block.elastic_ip-1.address}"
        floating_netmask  = "${packet_reserved_ip_block.elastic_ip-1.netmask}"
    }
}

data "template_file" "enable_bgp" {
    template = "${file("templates/enable_bgp.tpl")}"
    vars = {
      token = "${var.packet_auth_token}"
      device = "${packet_device.host-1.id}"
    }
}

data "template_file" "bird_conf_template" {

    template = <<EOF
filter packet_bgp {
    if net = $${floating_ip}/$${floating_cidr} then accept;
}
router id $${private_ipv4};
protocol direct {
    interface "lo";
}
protocol kernel {
    scan time 10;
    persist;
    import all;
    export all;
}
protocol device {
    scan time 10;
}
protocol bgp {
    export filter packet_bgp;
    local as 65000;
    neighbor $${gateway_ip} as 65530;
    password "$${bgp_password}"; 
}
EOF

    vars = {
        floating_ip    = "${packet_reserved_ip_block.elastic_ip-1.address}"
        floating_cidr  = "${packet_reserved_ip_block.elastic_ip-1.cidr}"
        private_ipv4   = "${packet_device.host-1.network.0.address}"
        gateway_ip     = "${packet_device.host-1.network.0.gateway}"
        bgp_password   = "${var.bgp_md5}"
    }
}

resource "null_resource" "configure_bird" {

    connection {
        type = "ssh"
        host = "${packet_device.host-1.access_public_ipv4}"
        private_key = "${file("mykey")}"
        agent = false
    }

    provisioner "file" {
      content = "${data.template_file.enable_bgp.rendered}"
      destination = "/tmp/enable_bgp.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "apt-get install bird",
            "mv /etc/bird/bird.conf /etc/bird/bird.conf.old",
            "chmod +x /tmp/enable_bgp.sh",
            "/tmp/enable_bgp.sh"
        ]
    }

    triggers = {
        template = "${data.template_file.bird_conf_template.rendered}"
        template = "${data.template_file.interface_lo0.rendered}"
    }

    provisioner "file" {
        content     = "${data.template_file.bird_conf_template.rendered}"
        destination = "/etc/bird/bird.conf"
    }

    provisioner "file" {
        content     = "${data.template_file.interface_lo0.rendered}"
        destination = "/etc/network/interfaces.d/lo0"
    }


    provisioner "remote-exec" {
        inline = [
            "sysctl net.ipv4.ip_forward=1",
            "grep /etc/network/interfaces.d /etc/network/interfaces || echo 'source /etc/network/interfaces.d/*' >> /etc/network/interfaces",
            "ifup lo:0",
            "service bird restart",
        ]
    }

}
