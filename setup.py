#!/usr/bin/env python3
"""
Ansible Environment Setup Script
Sets up a Python virtual environment and installs Ansible dependencies.
"""

import os
import sys
import subprocess
from pathlib import Path

# Check if rich is installed, if not install it
try:
    from rich.console import Console
    from rich.panel import Panel
    from rich.progress import Progress, SpinnerColumn, TextColumn
    from rich.markdown import Markdown
except ImportError:
    print("Installing required 'rich' library...")
    subprocess.run([sys.executable, "-m", "pip", "install", "rich"], check=True)
    from rich.console import Console
    from rich.panel import Panel
    from rich.progress import Progress, SpinnerColumn, TextColumn
    from rich.markdown import Markdown

console = Console()


def run_command(cmd, description, cwd=None, capture_output=False):
    """Run a shell command with rich output."""
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console,
    ) as progress:
        task = progress.add_task(description, total=None)

        try:
            result = subprocess.run(
                cmd,
                shell=True,
                check=True,
                cwd=cwd,
                capture_output=capture_output,
                text=True
            )
            progress.update(task, completed=True)
            return result
        except subprocess.CalledProcessError as e:
            progress.update(task, completed=True)
            console.print(f"[red]Error:[/red] {e}")
            sys.exit(1)


def main():
    # Get directories
    script_dir = Path(__file__).parent.resolve()
    parent_dir = script_dir.parent
    venv_dir = parent_dir / "venv"
    requirements_file = script_dir / "requirements.yml"

    # Display header
    console.print(Panel.fit(
        "[bold cyan]Ansible Environment Setup[/bold cyan]",
        border_style="cyan"
    ))
    console.print()

    # Step 1: Create virtual environment
    console.print("[bold][1/3][/bold] Creating Python virtual environment...")
    if venv_dir.exists():
        console.print(f"  [yellow]Virtual environment already exists at:[/yellow] {venv_dir}")
    else:
        run_command(
            f"{sys.executable} -m venv {venv_dir}",
            "Creating virtual environment...",
            capture_output=True
        )
        console.print(f"  [green]Created virtual environment at:[/green] {venv_dir}")
    console.print()

    # Step 2: Install Ansible
    console.print("[bold][2/3][/bold] Installing Ansible...")
    pip_path = venv_dir / "bin" / "pip"

    run_command(
        f"{pip_path} install --upgrade pip",
        "Upgrading pip...",
        capture_output=True
    )

    run_command(
        f"{pip_path} install ansible",
        "Installing Ansible..."
    )
    console.print("  [green]Ansible installed successfully[/green]")
    console.print()

    # Step 3: Install Galaxy requirements
    console.print("[bold][3/3][/bold] Installing Ansible Galaxy requirements...")
    ansible_galaxy_path = venv_dir / "bin" / "ansible-galaxy"

    run_command(
        f"{ansible_galaxy_path} install -r {requirements_file}",
        "Installing Galaxy requirements...",
        cwd=script_dir
    )
    console.print("  [green]Requirements installed successfully[/green]")
    console.print()

    # Success message
    console.print(Panel.fit(
        "[bold green]Setup Complete![/bold green]",
        border_style="green"
    ))
    console.print()

    # Instructions
    instructions = f"""
# Using Your Ansible Environment

## Activate the Environment
```bash
source {venv_dir}/bin/activate
```

## Run Ansible Roles

### Option 1: Run directly with ansible-playbook
```bash
cd {script_dir}
ansible-playbook -i hosts.ini your_playbook.yml
```

### Option 2: Run specific roles
Based on your requirements.yml, you have these roles available:
- **ansible_mde** - Microsoft Defender for Endpoint
- **ansible_azurearc** - Azure Arc integration

### Example Playbook
```yaml
---
- hosts: all
  roles:
    - ansible_mde
    - ansible_azurearc
```

## Deactivate When Done
```bash
deactivate
```

## Useful Commands
- Check Ansible version: `ansible --version`
- List installed roles: `ansible-galaxy list`
- Run with verbose output: `ansible-playbook -vvv playbook.yml`
"""

    console.print(Markdown(instructions))


if __name__ == "__main__":
    main()
