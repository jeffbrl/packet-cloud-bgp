variable "packet_auth_token" {}

variable "packet_project_id" {}

variable "bgp_md5" {}

# sites that currently support global_ip4 - MS1, EWR1, NRT1, and SJC1 

variable "sites" {
    default = [ "ewr1", "sjc1", "nrt1" ]
}

