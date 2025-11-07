# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is an Ansible project focused on tools for Microsoft platforms. The project is Python-based and follows standard Python development practices.

## Development Commands

### Environment Setup
```bash
# Create virtual environment
python3 -m venv .venv

# Activate virtual environment (macOS/Linux)
source .venv/bin/activate

# Install dependencies (once created)
pip install -r requirements.txt

# Install development dependencies (once created)
pip install -r requirements-dev.txt
```

### Testin
```bash
# Run all tests (typical for Python projects)
pytest

# Run tests with coverage
pytest --cov

# Run specific test file
pytest tests/test_<module>.py

# Run specific test function
pytest tests/test_<module>.py::test_<function_name>

# Run tests in verbose mode
pytest -v
```

### Code Quality
```bash
# Format code with black (if adopted)
black .

# Lint with ruff
ruff check .

# Fix auto-fixable issues with ruff
ruff check --fix .

# Type checking with mypy (if adopted)
mypy .
```

### Ansible-Specific Commands
```bash
# Test playbook syntax
ansible-playbook --syntax-check <playbook>.yml

# Run playbook in check mode (dry run)
ansible-playbook <playbook>.yml --check

# Run playbook
ansible-playbook <playbook>.yml

# Test with ansible-lint (if adopted)
ansible-lint <playbook>.yml
```

## Architecture Notes

### Expected Project Structure
- **roles/**: Ansible roles for Microsoft platform automation
- **playbooks/**: Ansible playbooks orchestrating Microsoft tools
- **library/**: Custom Ansible modules (Python-based)
- **plugins/**: Ansible plugins (filters, callbacks, etc.)
- **tests/**: Unit and integration tests
- **docs/**: Project documentation

### Development Patterns
- Python modules for Ansible should follow Ansible module development guidelines
- Custom modules should include proper documentation strings with EXAMPLES, RETURN, and DOCUMENTATION sections
- All Python code should be compatible with the Python versions supported by target Ansible versions
- Windows-specific modules should handle PowerShell execution when necessary
