#!/bin/bash

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

echo "=========================================="
echo "Ansible Environment Setup"
echo "=========================================="
echo ""

# Step 1: Create Python virtual environment in parent directory
echo "[1/4] Creating Python virtual environment..."
if [ -d "$VENV_DIR" ]; then
    echo "  Virtual environment already exists at: $VENV_DIR"
else
    python3 -m venv "$VENV_DIR"
    echo "  Created virtual environment at: $VENV_DIR"
fi
echo ""

# Step 2: Activate environment and install ansible
echo "[2/4] Activating environment and installing Ansible..."
source "$VENV_DIR/bin/activate"
pip install --upgrade pip > /dev/null 2>&1
pip install ansible
echo "  Ansible installed successfully"
echo ""

# Step 3: Install requirements using ansible-galaxy
echo "[3/4] Installing Ansible Galaxy requirements..."
cd "$SCRIPT_DIR"
ansible-galaxy install -r requirements.yml
echo "Ansible Requirements installed successfully"
echo "[4/4] Fetching latest version of Microsoft Defender for Endpoint installation script, placing it in roles/ansible_mde/files/ ..."
if command -v wget > /dev/null 2>&1; then
    wget -q https://raw.githubusercontent.com/microsoft/mdatp-xplat/refs/heads/master/linux/installation/mde_installer.sh -O "$SCRIPT_DIR/roles/ansible_mde/files/mde_installer.sh"
elif command -v curl > /dev/null 2>&1; then
    curl -sSL -o "$SCRIPT_DIR/roles/ansible_mde/files/mde_installer.sh" https://raw.githubusercontent.com/microsoft/mdatp-xplat/refs/heads/master/linux/installation/mde_installer.sh
else
    echo "wget/curl not found, skipping script installation"
    echo "Please download the latest version of mde_installer.sh from: https://raw.githubusercontent.com/microsoft/mdatp-xplat/refs/heads/master/linux/installation/mde_installer.sh"
    echo "and place it in: $SCRIPT_DIR/roles/ansible_mde/files/mde_installer.sh"
fi
echo "  Microsoft Defender for Endpoint installation script placed successfully"
echo ""

echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "To use this environment:"
echo "  1. Activate: source $VENV_DIR/bin/activate"
echo "  2. Run your ansible playbooks"
echo "  3. Deactivate when done: deactivate"
echo ""