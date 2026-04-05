# Homework: Linux Administration

This homework covers basic Bash automation for installing common DevOps tools on Debian/Ubuntu.

## What the script does

- Installs Docker using the distro package (`docker.io`).
- Installs Docker Compose using the `docker-compose` package.
- Ensures Python 3.12+ is available.
- Installs Django inside a local virtual environment (`./venv`) to avoid system-wide pip installs (PEP 668) and keep packages isolated.
- Skips installs when tools are already present.

## How to run

```bash
chmod u+x install_dev_tools.sh
./install_dev_tools.sh
```

## Script test result

The script was tested inside a Docker container based on `ubuntu:24.04`.
