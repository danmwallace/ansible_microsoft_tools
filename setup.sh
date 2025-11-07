#!/bin/bash

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
VENV_DIR="$SCRIPT_DIR/venv"

echo "=========================================="
echo "Ansible Environment Setup"
echo "=========================================="
echo ""

# Step 1: Create Python virtual environment in parent directory
echo "[1/3] Creating Python virtual environment..."
if [ -d "$VENV_DIR" ]; then
    echo "  Virtual environment already exists at: $VENV_DIR"
else
    python3 -m venv "$VENV_DIR"
    echo "  Created virtual environment at: $VENV_DIR"
fi
echo ""

# Step 2: Activate environment and install ansible
echo "[2/3] Activating environment and installing Ansible..."
source "$VENV_DIR/bin/activate"
pip install --upgrade pip > /dev/null 2>&1
pip install ansible
echo "  Ansible installed successfully"
echo ""

# Step 3: Install requirements using ansible-galaxy
echo "[3/3] Installing Ansible Galaxy requirements..."
cd "$SCRIPT_DIR"
ansible-galaxy install -r requirements.yml
echo "  Requirements installed successfully"
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
