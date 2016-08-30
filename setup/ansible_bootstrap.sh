#!/bin/bash
# Script will setup Ansible via pip on
# CentOS/RHEL/Debian/Ubuntu systems
# inspired by script here:
#  https://github.com/geerlingguy/JJG-Ansible-Windows/blob/master/windows.sh


if command -v yum >/dev/null 2>&1; then
  echo "Yum package manager found"
  echo "Installing CentOS/RHEL dependencies"
  yum install -y git python python-devel wget vim-enhanced gcc \
    libffi-devel openssl-devel unzip ca-certificates jq
elif command -v apt-get >/dev/null 2>&1; then
  echo "Apt-get package manager found"
  echo "Installing Ubuntu/Debian dependencies"
  apt-get update
  apt-get install -y git python python-dev wget vim-enhanced \
    build-essential libssl-dev libffi-dev
  echo "Neither yum nor apt-get are available."
fi

if command -v wget >/dev/null 2>&1; then
  echo "Installing pip."
  wget https://bootstrap.pypa.io/get-pip.py
  python get-pip.py && rm -f get-pip.py

  echo "Installing required python modules."
  pip install paramiko pyyaml jinja2 markupsafe

  echo "Installing Ansible."
  pip install ansible
fi
