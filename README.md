# Ansible Debian (buildfiles)

**[TL;DR](#tldr)** | **[Features](#features)** | **[Create custom profiles](#create-custom-profiles)** | **[Test your profile](#test-your-profile)**  | **[Options](#options)** | **[Requirements](#requirements)** | **[Stability](#stability)** | **[License](#license)**

[![travis](https://travis-ci.org/cytopia/ansible-debian.svg?branch=master)](https://travis-ci.org/cytopia/ansible-debian)
<img width="24" height="24" style="width:24px; height:24px;" src="https://github.com/cytopia/icons/raw/master/128x128/ansible.png" alt="Ansible" title="Ansible" />
<img width="24" height="24" style="width:24px; height:24px;" src="https://github.com/cytopia/icons/raw/master/128x128/debian.png" alt="Debian" title="Debian" />

Well-tested and customizable **[Ansible](https://www.ansible.com)** setup to provision your workstation with Debian.

Get your system back under control. Manage packages not provided by default and keep track of repositories as well as of installed software. Any bundled package offers the possibility to fully manage them, i.e. make sure they are installed or removed. Of course you can also simply ignore them, in case you want to manage them yourself.

It is designed to be a generic **buildfiles** (as opposed to **dotfiles**) manager. You can add as many profiles as you want (e.g.: for different hardware on different notebooks) and also have the choice to provision it locally or over the network.

[![asciicast](https://asciinema.org/a/153924.png)](https://asciinema.org/a/153924)

#### Table of Contents

1. **[TL;DR](#tldr)**
2. **[Features](#features)**
    1. [Available tools](#available-tools)
    2. [Fonts / Themes](#fonts--themes)
    3. [Sensible customizations](#sensible-customizations)
3. **[Create custom profiles](#create-custom-profiles)**
    1. [Assumption](#assumption)
    2. [Add a new profile](#add-a-new-profile)
    3. [Add a profile configuration](#add-a-profile-configuration)
    4. [Customize your profile](#customize-your-profile)
    5. [Provision your profile](#provision-your-profile)
4. **[Test your profile](#test-your-profile)**
    1. [Testing with Python2](#testing-with-python2)
    2. [Testing with Python3](#testing-with-python3)
5. **[Options](#options)**
    1. [Enable / Disable Management](#enable--disable-management)
    2. [Package options](#package-options)
6. **[Requirements](#requirements)**
    1. [Install system requirements](#install-system-requirements)
    2. [Install Python requirements](#install-python-requirements)
    3. [Sudo permissions](#sudo-permissions)
7. **[Stability](#stability)**
8. **[License](#license)**


## TL;DR

Make sure your system meets the **[requirements](#requirements)** before you start.

##### Provision your system
```
ansible-playbook -i inventory playbook.yml --diff --limit debian-stretch --ask-become-pass
```

##### See what would change (dry-run)
```
ansible-playbook -i inventory playbook.yml --diff --limit debian-stretch --ask-become-pass --check
```



## Features

This Ansible repository allows you to provision your Debian machines and keeping them up-to-date. It allows you to create different profiles for different machines and offers packages that are not available by any Debian repository.

This is a base idempotent provisioning with sensible defaults that can be slightly adjusted. It is only meant as a **buildfiles** bootstrap. In order to customize the applications itself, you will still have to apply your personal **dotfiles** on top of that.

#### Available tools 
> [chromium](https://www.chromium.org/Home),
> [clipmenu](https://github.com/cdown/clipmenu),
> [diff-highlight](https://github.com/K-Phoen/Config/blob/master/bin/diff-highlight),
> [docker](https://docs.docker.com/engine/installation/linux/docker-ce/debian),
> [docker-compose](https://docs.docker.com/compose/install),
> [fzf](https://github.com/junegunn/fzf),
> [hipchat](https://www.hipchat.com/downloads),
> [i3-gaps](https://github.com/Airblader/i3),
> [i3-utils-bin](https://github.com/cytopia/i3-utils-bin),
> [i3-utils-systemd](https://github.com/cytopia/i3-utils-systemd),
> [i3blocks-modules](https://github.com/cytopia/i3blocks-modules),
> [lxdm](https://wiki.archlinux.org/index.php/LXDM),
> [neovim](https://github.com/neovim/neovim),
> [packer](https://www.packer.io),
> [ranger](https://github.com/ranger/ranger),
> [skype](https://www.skype.com/en/get-skype),
> [sublime](https://www.sublimetext.com),
> [sxiv](https://github.com/muennich/sxiv),
> [telegram](https://telegram.org),
> [thunar](https://wiki.archlinux.org/index.php/Thunar),
> [timemachine](https://github.com/cytopia/linux-timemachine),
> [xbacklight](https://github.com/wavexx/acpilight),
> [xdg-mime-meta](https://wiki.archlinux.org/index.php/Default_applications),
> [xorg](https://www.x.org/wiki),
> [zathura](https://pwmt.org/projects/zathura)

#### Fonts / Themes
> [font-droid-sans-mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/DroidSansMono),
> [font-font-awesome](http://fontawesome.io/icons),
> [font-san-francisco](https://github.com/supermarin/YosemiteSanFranciscoFont),
> [font-terminus](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Terminus/font-info.md),
> [font-ubuntu](https://design.ubuntu.com/font),
> [icon-moka](https://snwh.org/moka),
> [theme-arc](https://github.com/horst3180/Arc-theme)

See [roles/](roles/) directory for all available packages. If you are missing one, open up an issue or a pull request.

#### Sensible customizations

Additionally you can (but don't have to) manage the following:

* Python default system version (Python2 or Python3)
* [Xdg](https://wiki.archlinux.org/index.php/Default_applications) default applications
* Custom apt packages can be added per profile
* Custom pip packages can be added per profile
* Custom Debian repositories can be added per profile
* Debian distribution (stable or testing)



## Create custom profiles

In order to customize your workstation or Debian infrastructure, you can create profiles for each of your machines. This might be necessary due to different hardware or software preferences. Each **hostname** (real or made up) in the [inventory](inventory) file automatically represents one **profile**.

By the way Ansible works, each profile inherits all settings from [group_vars/all.yml](group_vars/all.yml). This file holds a sane default showing you all available options and with all packages unmanaged.

In order to actually **customize your profile**, you will have to create a file in [host_vars/](host_vars/) by the same name you have specified in [inventory](inventory). You can copy [group_vars/all.yml](group_vars/all.yml) directly or use an already existing profile from `host_vars`, such as [host_vars/debian-stretch.yml](host_vars/debian-stretch.yml).

To better understand how it works, you can follow this step-by-step example for creating a new profile:

#### Assumption
For the sake of this example, let's assume your profile is called `dell-xps-i3wm`.

#### Add a new profile
Add the following line to the bottom of [inventory](inventory):
```
dell-xps-i3wm    ansible_connection=local
```

`ansible_connection=local` defines that your profile should be applied to your local computer. If you want to create a profile for a remote computer, your profile name must be a hostname or IP address by which the remote machine is reachable over the network.

#### Add a profile configuration
As already mentioned earlier, you can copy [group_vars/all.yml](group_vars/all.yml) or an already existing `host_vars` file.

Use group_vars/all.yml as a default template:
```
cp group_vars/all.yml host_vars/dell-xps-i3wm.yml
```
Use an already existing host_vars file as a default template:
```
cp host_vars/debian-stretch.yml host_vars/dell-xps-i3wm.yml
```

#### Customize your profile
Simply edit `host_vars/dell-xps-i3wm.yml` and adjust the values to your needs. If you have copied an already existing file, it will contain comments for all possible configuration options that let's you quickly see what and how to change.

#### Provision your profile
If you want to test your profile in a Docker container prior actually provisioning your own system, skip to the next section, otherwise just run the following commands.

Run the following command to see what would happen:
```shell
$ ansible-playbook -i inventory playbook.yml --diff --limit dell-xps-i3wm --ask-become-pass --check
```
Run the following command to actually apply your profile:
```shell
$ ansible-playbook -i inventory playbook.yml --diff --limit dell-xps-i3wm --ask-become-pass
```



## Test your profile
Before actually running any new profile on your own system, you can and you should test that beforehand in a **Docker container** in order to see if everything works as expected.

Depending on your choice of desired default system Python version (Python2 or Python3), you have to choose the appropriate Docker image.

#### Testing with Python2

First build the Docker image:
```
docker build -t ansible-debian-python2 -f Dockerfile.python2 .
```
Then you can run your profile inside a Docker container.
```
docker run --rm -e MY_HOST=dell-xps-i3wm -t ansible-debian-python2
```

#### Testing with Python3

First build the Docker image:
```
docker build -t ansible-debian-python3 -f Dockerfile.python3 .
```
Then you can run your profile inside a Docker container.
```
docker run --rm -e MY_HOST=dell-xps-i3wm -t ansible-debian-python3
```



## Options

#### Enable / Disable Management

Look for the package section and set them to a desired state. `install` or `remove` or any other value to ignore them.
```yml
$ vi host_vars/<name>.yml

...
i3-gaps:          'install'
font_ubuntu:      'install'
diff_highlight:   'install'
docker:           'remove'
docker_compose:   'remove'
skype:            'ignore'
sublime:          'ignore'
hipchat:          'ignore'
...
```
#### Package options

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

Choose your GPU and touchpad driver:
```yml
$ vi host_vars/<name>.yml

# Supported values: 'amdgpu' 'ati' 'intel' 'modesetting' 'nouveau' 'nvidia' 'radeon'
xorg_gpu: modesetting
# Enable VDPAU_DRIVER=va_gl systemwide
xorg_gpu_vdpau_va_gl_enable: yes

# 'libinput' or 'synaptics'
xorg_touchpad_enable: yes
xorg_touchpad_driver: 'synaptics'
...
```


## Requirements

Before you can start there are a few tools required that must be present on the system. Just copy-paste those commands as root into your terminal.

#### Install system requirements
```shell
apt-get update
apt-get install --no-install-recommends --no-install-suggests -y \
  sudo
```

#### Install Python requirements

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
#### Sudo permissions

Make sure your user is allowed run sudo
```
usermod -aG sudo <username>
```


## Stability

In order to guarantee the most possible stability of this setup, extensive [travis-ci](https://travis-ci.org/cytopia/ansible-debian) checks have been defined which automatically run every night. Those tests are run inside two Docker container. The first one uses Python2 as default and the second one uses Python3. The following test cases have been defined:

* Each run randomizes the order of roles to install
* Each run is done with Python2 and Python3
* Each run is done for Debian stable and Debian testing
* Each run is done against all defined profiles (repositories: main vs main, extra and non-free)


## License

[MIT License](LICENSE.md)

Copyright (c) 2017 [cytopia](https://github.com/cytopia)
