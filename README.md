# Ansible Debian

---
TODO:
Move to /usr/share/wallpapers/<prefix>-
Change login-background
https://unix.stackexchange.com/questions/364454/unable-to-change-background-in-mate-desktop
```
update-alternatives --install /usr/share/images/desktop-base/login-background.svg desktop-login-background /absolute/path/of/your/image 50
update-alternatives --set desktop-login-background /absolute/path/of/your/image
```
choose i3
sudo update-alternatives --config x-window-manager

choose lxdm
:~$ sudo update-alternatives --config x-session-manager

Lock screen with lxdm:
```
lxdm -c USER_SWITCH
xss-lock -- /usr/bin/lxdm -c USER_SWITCH
```
intel-microcode vs amd64-microcode
firmware-linux
firmware-iwlwifi


TELEGRAM:
 - requires: `pulseaudio`


Make sure GPU suppport is installed:

libva-drm1
libva-glx1
libva-x11-1
libva1


---


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

See [roles/](roles/) directory for all available packages. If you are missing one, open up an issue or a pull request.

## Customization

In order to customize your workstation or Debian infrastructure, you can create profiles for each of your machines
1. Copy [group_vars/all.yml](group_vars/all.yml) to `host_vars/<name>.yml`
2. Customize `host_vars/<name>.yml`
3. Add `<name>` to [inventory](inventory)
4. Run: `ansible-playbook -i inventory playbook.yml --diff --limit <name> --ask-sudo-pass`


##### Enable/Disable Management
Look for the package section and set them to a desired state. `install` or `remove` or any other value to ignore them.
```yml
$ vi group_vars/all.yml

...
font_ubuntu:      'ignore'
diff_highlight:   'ignore'
docker:           'ignore'
docker_compose:   'ignore'
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
