# Ansible Debian

[![travis](https://travis-ci.org/cytopia/ansible-debian.svg?branch=master)](https://travis-ci.org/cytopia/ansible-debian)

Ansible setup to provision your workstation.

## Prepare

### Install requirements
```shell
sudo apt-get update
sudo apt-get install --no-install-recommends --no-install-suggests -y \
  apt-transport-https \
  git \
  gnupg \
  python-dev \
  python-pip \
  python-setuptools \
  sudo

sudo pip install wheel
sudo pip install ansible
```
### Sudo permissions

Make sure your user is allowed run sudo
```
usermod -aG sudo <username>
```

### Clone repository
```
git clone https://github.com/cytopia/ansible-debian
```

## Setup

### Customize
```
cd  ansible-debian
vi group_vars/all.yml
```

### Run
```shell
ansible-playbook -i inventory playbooks/provisioning.yml --diff --ask-sudo-pass
```
