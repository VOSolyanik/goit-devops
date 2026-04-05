#!/usr/bin/env bash
set -euo pipefail

APT_UPDATED=0

# Print a consistent log line.
log() {
  echo "[install] $*"
}

# Run apt-get update once per script run.
run_apt_update() {
  if [[ "$APT_UPDATED" -eq 0 ]]; then
    log "Running apt-get update"
    sudo apt-get update -y
    APT_UPDATED=1
  fi
}

# Check whether a command exists in PATH.
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Verify Python 3.12+ is available.
python_version_ok() {
  command_exists python3 || return 1
  python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 12) else 1)'
}

# Install Docker from distro packages if missing.
install_docker() {
  if command_exists docker; then
    log "Docker is already installed"
    return
  fi

  log "Installing Docker"
  run_apt_update
  sudo apt-get install -y docker.io
}

# Install Docker Compose from distro packages if missing.
install_docker_compose() {
  if command_exists docker-compose; then
    log "Docker Compose (standalone) is already installed"
    return
  fi

  log "Installing Docker Compose"
  run_apt_update
  sudo apt-get install -y docker-compose
}

# Install Python and ensure it is 3.12+.
install_python() {
  if python_version_ok; then
    log "Python 3.12+ is already installed"
    return
  fi

  log "Installing Python 3 and pip"
  run_apt_update
  sudo apt-get install -y python3 python3-pip

  if python_version_ok; then
    return
  fi

  log "Upgrading to Python 3.12+"
  run_apt_update
  sudo apt-get install -y python3.12 python3.12-venv || true

  if command_exists python3.12; then
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
  fi

  if ! python_version_ok; then
    log "Python 3.12+ is still not available. Please install it manually."
    exit 1
  fi
}

# Install Django inside a local venv.
install_django() {
  if python_version_ok; then
    local venv_dir venv_python
    venv_dir="./venv"
    venv_python="${venv_dir}/bin/python"

    if [[ ! -x "$venv_python" ]]; then
      log "Creating venv at ${venv_dir}"
      run_apt_update
      sudo apt-get install -y python3-venv
      python3 -m venv "$venv_dir"
    fi

    if "$venv_python" -m pip show django >/dev/null 2>&1; then
      log "Django is already installed"
      return
    fi

    log "Installing Django via pip"
    "$venv_python" -m pip install --upgrade pip
    "$venv_python" -m pip install django
  else
    log "Python 3.12+ is required for Django installation"
    exit 1
  fi
}

# Entry point: run installs in order.
main() {
  install_docker
  install_docker_compose
  install_python
  install_django
  log "Done"
}

main "$@"
