![](https://img.shields.io/badge/Stability-Experimental-red.svg)

This terraform code configures a Ubuntu virtual machine on packet and configures BIRD for BGP routing.

This repository is [Experimental](https://github.com/packethost/standards/blob/master/experimental-statement.md) meaning that it's based on untested ideas or techniques and not yet established or finalized or involves a radically new and innovative style! This means that support is best effort (at best!) and we strongly encourage you to NOT use this in production.

### Requirements

- [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
- A Packet Host Account
- Linux host to run Terraform

#### Packet API access

A Packet API key and Project ID is required for Terraform to provision hardare.
Your Packet API key must be available in the `PACKET_AUTH_TOKEN` environment variable
and the Project ID stored in the `PACKET_PROJECT_ID` environment variable.
Alternatively, the Project ID can be saved in vars.tf.

The Packet API key is typically stored outside of the code repo since it is considered secret.
If someone gets this key, they can startup/shutdown hosts in your project!

For more information on how to generate an API key or find your project ID, please see:
https://support.packet.com/kb/articles/api-integrations

For more information about the API, please see:
https://www.packet.com/developers/api/

Example:
```ShellSession
$ export TF_VAR_packet_auth_token="Example-API-Token"
$ export TF_VAR_packet_project_id="Example-Project-ID"
```


Steps
1. Populate vars.tf with your API token and project ID or use environment variables TF_VAR_packet_project_id 
and TF_VAR_packet_auth_token
2. Generate an SSH key named mykey using ssh-keygen -f mykey
3. Copy terraform.tfvars.sample to terraform.tfvars and edit the bgp_md5 value to a random password
4. Set the same bgp_md5 password into your Packet Project 
5. terraform init
6. terraform plan
7. terraform apply
8. Test that request go across all servers with curl <elastic_ip>
