# Ansible Tools for Microsoft

This repository will help you with setting up an Ansible environment to use roles to configure Microsoft Tools, such as Azure Arc and Microsoft Defender for Endpoint.

# Quick Start

There are (2) scripts to get you started:
* `setup.sh` Can be run easily with `bash`
* `setup.py` Can be run easily with `python`

These will configure a Python virtual environment for you, install Ansible, and install the included Ansible roles for managing a Microsoft Entra environment. The python script is generally meant for Windows but I haven't tested it yet.

## Running the bash script

Assuming you're in terminal on macOS, simply:
```
chmod +x setup.sh
./setup.sh
```

