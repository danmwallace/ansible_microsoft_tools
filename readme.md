# Ansible Tools for Microsoft

This repository will help you with setting up an Ansible environment to use roles to configure Microsoft Tools, such as Azure Arc and Microsoft Defender for Endpoint. The repository is meant as a "quick start" environment and was intended for people who are new to Ansible and learn how to use it.

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

# Step 1: Pre-requisites

## Step 1.1: Azure Arc (Role: ansible_azure_arc)

You will need to create a [Service Principal for onboarding](https://learn.microsoft.com/en-us/azure/azure-arc/servers/onboard-service-principal#create-a-service-principal-for-onboarding-at-scale) and collect the necessary variables:
```
service_principal_id: "{{ azure_service_principal_id }}"
service_principal_secret: "{{ azure_service_principal_secret }}"
resource_group: "{{ azure_resource_group }}"
tenant_id: "{{ azure_tenant_id }}"
subscription_id: "{{ azure_subscription_id }}"
location: "{{ azure_location }}"
```

Write down the above as you will use them later. See the *Using the playbooks* section for how to use these.

## Step 1.2: Microsoft Defender for Endpoint on Linux (Role: ansible_mde)

You will need to:
1. Download the onboarding package from Microsoft Defender Security Center. This includes the `mdatp_onboard.json` file which will be used to onboard the device with MDE. 
2. Extract the `mdatp_onboard.json` file from the `WindowsDefenderATPOnboardingPackage.zip` file you downloaded. See [here](https://learn.microsoft.com/en-us/defender-endpoint/linux-install-with-ansible#download-the-onboarding-package-applicable-to-both-the-methods) for more information.

Place the `mdatp_onboard.json` aside for now.

## Step 1.3: Adding your Hosts to hosts.ini

Update the `hosts.ini` file and add your hosts:
```
myserver.example.com ansible_host=myserver.example.com
```
Replace myserver.example.com with the FQDN and `ansible_host=myserver.example.com` can either point to an FQDN or an IP address.

## Step 1.4: Run the setup script

The included `setup.sh` script will set up an environment for you to run Ansible, and will also install the required roles. **It has only been tested on macOS and Linux.**

Run the script via `bash setup.sh` 

It will:
1. Set up a Python virtual environment in a folder named `venv`
2. Install the `roles` via `ansible-galaxy install -r requirements.yml` (roles are on GitHub)
3. Fetch the latest version of the `mde_installer.sh` script and place it within `roles/ansible-mde/files/mde_installer.sh` for use by the `ansible_mde` role.
4. Activate the Python virtual environment so you can run the playbook.

## Step 1.5: Place mdatp_onboard.json in roles/ansible_mde/files/

# Step 2: Set up your service account on the server(s)

The `ansible.cfg` file is assuming you have a user on the target server(s) named `ansible` that will elevate to `root` via `sudo`. If you look at the `ansible.cfg` file:
```
[defaults]
remote_user = ansible

...

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
```

To add a user named `ansible` on the server, you would:
1. Add the user, e.g `sudo adduser ansible`
3. Add the SSH key for the user to their `authorized_keys` file, found in `/home/username/.ssh/authorized_keys`
2. Add the user to `sudo`, e.g `sudo usermod -aG sudo ansible`
3. (Optional, but recommended) Create a file within `/etc/sudoers.d/` named after the user, e.g `/etc/sudoers.d/ansible`, with `NOPASSWD` enabled:
```
ansible ALL=(ALL) NOPASSWD:ALL
```

This is ideal for automation. **If you do not create this file, you will need to pass `--ask-become-pass` while running the playbook.** You will need to modify `install-arc-and-mde.sh` accordingly.


# Step 3: Using the Playbooks

## Installing Azure Arc + DFE (Common use case)

The easiest way to run the playbook is likely to modify the included `install-arc-and-mde.sh` script. There, you can easily modify the variables to suit your specific requirements, then just run the script via `bash install-arc-and-mde.sh`

Alternatively, from the `ansible_microsoft_tools` folder you can run the following command in terminal:
```
ansible-playbook -i hosts.ini playbooks/common.yml --extra-vars \
  "azure_service_principal_id=<service_principal_id> \
  azure_service_principal_secret=<service_principal_secret> \
  azure_resource_group=<name_of_rg> \
  azure_tenant_id=<tenant_id> \
  azure_subscription_id=<subscription_id> \
  azure_location=<location>"
```

Note: The `\` character above is to make the command more readable, simply remove the character if you're running this in one line in terminal.

You could also modify the `playbooks/common.yml` file and replace the variables in quotes, and then run it via `ansible-playbook -i hosts.ini playbooks/common.yml`, however if you're going to do this I highly urge you to look into setting up and using an Ansible Vault for storing the `service_principal_secret`, so that you don't accidentally commit secrets to code.

### Possible Errors

#### Playbook failed on `TASK [ansible_azure_arc : Connect to Azure Arc]` task

Check the error output. If Arc is already installed, you may see an error message such as:
```
level=fatal msg=\"Machine 'myserver.myorg.com' is already onboarded to Microsoft.HybridCompute. If you want to onboard with a different name, run azcmagent disconnect, sudo systemctl restart and then azcmagent connect\""]
```

If this is the case, no action is required by default, and this particular task has `ignore_errors: true` set to allow it to continue. **If you need to onboard the server with another name, you will need to follow the instructions above**. The playbook does not currently support this. If there is a need, I can look into it further.

# Questions

If you get stuck or run into an undocumented error, please create an issue.