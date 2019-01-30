This terraform code configures a Ubuntu virtual machine on packet and configures BIRD for BGP routing.

Steps
1. Populate vars.tf with your API token and project ID or use environment variables TF_VAR_packet_project_id 
and TF_VAR_packet_auth_token
2. Generate an SSH key named mykey using ssh-keygen -f mykey
3. terraform init
4. terraform plan
5. terraform apply
