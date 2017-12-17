# Ansible Debian

**[TL;DR](#tldr)** | **[Features](#features)** | **[Customization](#customization)** | **[Requirements](#requirements)**

[![travis](https://travis-ci.org/cytopia/ansible-debian.svg?branch=master)](https://travis-ci.org/cytopia/ansible-debian)

Well-tested and customizable [Ansible](https://www.ansible.com) setup to provision your workstation with Debian.

Get your system back under control. Manage packages not provided by default and keep track of repositories as well as of installed software. Any bundled package offers the possibility to fully manage them, i.e. make sure they are installed or removed. Of course you can also simply ignore them, in case you want to manage them yourself.

## TL;DR

##### Provision your system
```
ansible-playbook -i inventory playbook.yml --diff --limit localhost --ask-sudo-pass
```

##### See what would change (dry-run)
```
ansible-playbook -i inventory playbook.yml --diff --limit localhost --ask-sudo-pass --check
```

## Features

* Profiles (via `host_vars/`) can be created for different machines
* Random choices are tested every night via  [travis](https://travis-ci.org/cytopia/ansible-debian) to ensure everything works as expected
* The following packages can be managed (installed or removed) or ignored in case you don't require them

> `chromium` `diff-highlight` `docker` `docker-compose` `font-droid-sans-mono` `font-font-awesome` `font-san-francisco` `font-terminus` `font-ubuntu` `fzf` `hipchat` `i3blocks-modules` `i3-utils-bin` `i3-utils-systemd` `icon-moka` `lxdm` `neovim` `ranger` `skype` `sublime` `sxiv` `theme-arc` `thunar` `xbacklight` `xdg-mime-meta` `xorg` `zathura`

See [roles/](roles/) directory for all available packages. If you are missing one, open up an issue or a pull request.

Additionally you can manage the following:

* Python system default version (Python2 or Python3)
* xdg default applications


## Customization

In order to customize your workstation or Debian infrastructure, you can create profiles for each of your machines. This is achieved by having different `host_vars`.

1. Copy [group_vars/all.yml](group_vars/all.yml) to `host_vars/<name>.yml`
2. Customize `host_vars/<name>.yml`
3. Add `<name>` to the [inventory](inventory) file
4. Run: `ansible-playbook -i inventory playbook.yml --diff --limit <name> --ask-sudo-pass`


##### Enable/Disable Management
Look for the package section and set them to a desired state. `install` or `remove` or any other value to ignore them.
```yml
$ vi host_vars/<name>.yml

...
font_ubuntu:      'install'
diff_highlight:   'install'
docker:           'remove'
docker_compose:   'remove'
skype:            'ignore'
sublime:          'ignore'
hipchat:          'ignore'
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
