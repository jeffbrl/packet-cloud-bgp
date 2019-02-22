variable "packet_auth_token" {}

variable "packet_project_id" {}

variable "bgp_md5" {}

# sites that currently support global_ip4 - MS1, EWR1, NRT1, and SJC1 

# ewr facility ID - e1e9c52e-a0bc-4117-b996-0fc94843ea09
# sjc1 facility ID - 2b70eb8f-fa18-47c0-aba7-222a842362fd

variable "ewr1_facility" {
  default = "e1e9c52e-a0bc-4117-b996-0fc94843ea09"
}

variable "sjc1_facility" {
  default = "2b70eb8f-fa18-47c0-aba7-222a842362fd"
}

# host count must equal the length of the packet_facility list (refactor later?)
variable "host-count" {
  default = "2"
}
