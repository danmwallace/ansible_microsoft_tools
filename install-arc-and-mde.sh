#!/bin/bash

set -e  # Exit on error

# Define variables for the playbook
service_principal_id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
service_principal_secret="Your-Service-Principal-Secret-Here"
resource_group="Your-Resource-Group" # This is the Resource Group which the Arc-enabled machines will be placed into
tenant_id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
location="eastus"

if command -v ansible-playbook > /dev/null 2>&1; then
    echo "Confirmed Ansible is installed. Running playbook..."
    ansible-playbook -i hosts.ini playbooks/common.yml --extra-vars \
      "azure_service_principal_id=$service_principal_id \
      azure_service_principal_secret=$service_principal_secret \
      azure_resource_group=$resource_group \
      azure_tenant_id=$tenant_id \
      azure_subscription_id=$subscription_id \
      azure_location=$location"
else
    echo "Ansible is not installed. Please run setup.sh to set up the environment first."
    echo "Note: You may just need to activate the virtual environment via 'source venv/bin/activate'"
    exit 1
fi