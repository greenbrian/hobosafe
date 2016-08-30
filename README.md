# hobosafe
Testing Hashicorp Vault with Vagrant

Vagrantfile uses setup/config.yml.sample to setup a multinode environment

setup/ansible_bootstrap.sh bootstraps Ansible on each node for `ansible-local` usage.

setup/playbook.yml is an Ansible playbook that downloads and installs Vault, Consul and Consul-ui.
