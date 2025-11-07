# Ansible Tools for Microsoft

This repository will help you with setting up an Ansible environment to use roles to configure Microsoft Tools, such as Azure Arc and Microsoft Defender for Endpoint.

# Quick Start

## macOS / Linux

Run the included bash script on macOS or Linux:
* `setup.sh` Can be run easily with `bash`

These will configure a Python virtual environment for you, install Ansible, and install the included Ansible roles for managing a Microsoft Entra environment. The python script is generally meant for Windows but I haven't tested it yet.

Assuming you're in terminal on macOS, simply:
```
chmod +x setup.sh
./setup.sh
```

## Windows

I'll need to update these instructions but essentially:
* Install Python 3
* Set up a virtual environment, install pip
* Install `ansible` with pip
* Execute `ansible-galaxy install -r requirements.yml` to install the roles

# Pre-requisites

## Azure Arc (Role: ansible_azure_arc)

You will need to create a [Service Principal for onboarding](https://learn.microsoft.com/en-us/azure/azure-arc/servers/onboard-service-principal#create-a-service-principal-for-onboarding-at-scale) and collect the necessary variables:
```
service_principal_id: "{{ azure_service_principal_id }}"
service_principal_secret: "{{ azure_service_principal_secret }}"
resource_group: "{{ azure_resource_group }}"
tenant_id: "{{ azure_tenant_id }}"
subscription_id: "{{ azure_subscription_id }}"
location: "{{ azure_location }}"
```

See the *Running the playbooks* section for how to use these.

## Microsoft Defender for Endpoint on Linux (Role: ansible_mde)

You will need to:
1. Download the onboarding package from Microsoft Defender Security Center. This includes the `mdatp_onboard.json` file which will be used to onboard the device with MDE. 
2. Extract the `mdatp_onboard.json` file from the `WindowsDefenderATPOnboardingPackage.zip` file you downloaded. See [here](https://learn.microsoft.com/en-us/defender-endpoint/linux-install-with-ansible#download-the-onboarding-package-applicable-to-both-the-methods) for more information.
3. Fetch the latest `mde_installer.sh` script, located here:
https://raw.githubusercontent.com/microsoft/mdatp-xplat/refs/heads/master/linux/installation/mde_installer.sh

Place the `mde_installer.sh` and `mdatp_onboard.json` within `roles/ansible_mde/files/`

# Using the Playbooks

## Installing Azure Arc + DFE (Common use case)
From the `ansible_microsoft_tools` folder:
`ansible-playbook -i hosts.ini playbooks/common.yml --extra-vars "service_principal_id=<service_principal_id> service_principal_secret=<service_principal_secret> resource_group=<name_of_rg> tenant_id=<tenant_id> subscription_id=<subscription_id> location=<location>"`

Alternatively, you could also modify the `playbooks/common.yml` file and replace the variables in quotes, and then run it via `ansible-playbook -i hosts.ini playbooks/common.yml`