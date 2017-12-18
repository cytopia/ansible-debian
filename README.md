# Ansible Debian

**[TL;DR](#tldr)** | **[Features](#features)** | **[Custom profiles](#custom-profiles)** | **[Options](#options)** | **[Requirements](#requirements)**

[![travis](https://travis-ci.org/cytopia/ansible-debian.svg?branch=master)](https://travis-ci.org/cytopia/ansible-debian)

Well-tested and customizable [Ansible](https://www.ansible.com) setup to provision your workstation with Debian.

Get your system back under control. Manage packages not provided by default and keep track of repositories as well as of installed software. Any bundled package offers the possibility to fully manage them, i.e. make sure they are installed or removed. Of course you can also simply ignore them, in case you want to manage them yourself.


## TL;DR

Make sure your system meets the **[requirements](#requirements)** before you start.

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
* Xdg default applications
* Custom apt packages can be added per profile


## Custom profiles

In order to customize your workstation or Debian infrastructure, you can create profiles for each of your machines. This is achieved by having different `host_vars`.

The [group_vars/all.yml](group_vars/all.yml) file holds all possible configuration values and will be applied to all hostnames that are added to the [inventory](inventory) file. However [group_vars/all.yml](group_vars/all.yml) has all features disabled by default, so need to create your own **profile**. This is achieved by adding a new *host* to the [inventory](inventory) file and add an appropriate host variable file that you can customize.

##### 1. Create your *profile*

First you will have to think of a name for your profile. The following uses `<name>` as a placeholder for the name you will come up with.

1. Copy [group_vars/all.yml](group_vars/all.yml) to `host_vars/<name>.yml`
2. Add `<name>` to the [inventory](inventory) file:
```ini
[category]
<name>    ansible_connection=local
```

##### 2. Customize your *profile*

Open `host_vars/<name>.yml` see the comments and adjust the file to your needs.

##### 3. Provision your *profile*

Run the following command to see what would happen:
```shell
$ ansible-playbook -i inventory playbook.yml --diff --limit <name> --ask-sudo-pass --check
```
Run the following command to actually apply your profile:
```shell
$ ansible-playbook -i inventory playbook.yml --diff --limit <name> --ask-sudo-pass
```


## Options

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
##### Package options

Many packages also come with options that you can tweak. You can for example define the Python version your system should provide and which one it should use as its default:
```yml
$ vi host_vars/<name>.yml

...
python_2: yes
python_3: yes
python_default: 2
...
```

Another customization could be the default program to use when opening speficif file types:
```yml
$ vi host_vars/<name>.yml

...
xdg_mime_defaults:
  - desktop_file: chromium.desktop
    mime_types:
      - text/html
      - text/xml
      - application/xhtml_xml
      - application/x-mimearchive
      - x-scheme-handler/http
      - x-scheme-handler/https
...
```

Or to set your **DPI** and other options for `lxdm`
```yml
$ vi host_vars/<name>.yml

...
lxdm_dpi: 132
lxdm_gtk_theme: Arc-Darker
lxdm_show_user_list: no
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
