# Ansible Debian

**[TL;DR](#tldr)** | **[Features](#features)** | **[Customization](#customization)** | **[Requirements](#requirements)**

[![travis](https://travis-ci.org/cytopia/ansible-debian.svg?branch=master)](https://travis-ci.org/cytopia/ansible-debian)

Well-tested and customizable [Ansible](https://www.ansible.com) setup to provision your workstation with Debian.

Get your system back under control. Manage packages not provided by default and keep track of repositories as well as of installed software. Any bundled package offers the possibility to fully manage them, i.e. make sure they are installed or removed. Of course you can also simply ignore them, in case you want to manage them yourself.

## TL;DR

##### Provision your system
```
ansible-playbook -i inventory playbook.yml --diff --ask-sudo-pass
```

##### See what would change (dry-run)
```
ansible-playbook -i inventory playbook.yml --diff --check --ask-sudo-pass
```

## Features

See [roles/](roles/) directory for all available packages. If you are missing one, open up an issue or a pull request.

## Customization

In order to customize your workstation or Debian infrastructure, you can edit `group_vars/all.yml`, which will affect all managed hosts, or simply copy it to `host_vars/<hostname>`.

##### Enable/Disable Management
Look for the package section and set them to a desired state. `install` or `remove` or any other value to ignore them.
```yml
$ vi group_vars/all.yml

...
font_ubuntu:      'install'
diff_highlight:   'install'
docker:           'install'
docker_compose:   'install'
skype:            'install'
sublime:          'install'
hipchat:          'install'
...
```

## Requirements

Before you can start there are a few tools required that must be present on the system. Just copy-paste those commands as root into your terminal.

##### 1. Install system requirements
```shell
apt-get update
apt-get install --no-install-recommends --no-install-suggests -y \
  sudo
```

##### 2. Install Python requirements

Either go with Python2
```
apt-get install --no-install-recommends --no-install-suggests -y \
  python-apt \
  python-dev \
  python-jmespath \
  python-pip \
  python-setuptools \
pip install wheel
pip install ansible
```
Or go with Python3
```
apt-get install --no-install-recommends --no-install-suggests -y \
  python3-apt \
  python3-dev \
  python3-jmespath \
  python3-pip \
  python3-setuptools \
pip3 install wheel
pip3 install ansible
```
##### 3. Sudo permissions

Make sure your user is allowed run sudo
```
usermod -aG sudo <username>
```
