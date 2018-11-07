# Ansible Debian (buildfiles)

**[TL;DR](#tldr)** | **[Features](#features)** | **[Custom profiles](#create-custom-profiles)** | **[Test your profile](#test-your-profile)**  | **[Options](#options)** | **[Requirements](#requirements)** | **[Stability](#stability)** | **[Other OS](#other-os)** | **[License](#license)**

[![travis](https://travis-ci.org/cytopia/ansible-debian.svg?branch=master)](https://travis-ci.org/cytopia/ansible-debian)
<img width="24" height="24" style="width:24px; height:24px;" src="https://github.com/cytopia/icons/raw/master/128x128/ansible.png" alt="Ansible" title="Ansible" />
<img width="24" height="24" style="width:24px; height:24px;" src="https://github.com/cytopia/icons/raw/master/128x128/debian.png" alt="Debian" title="Debian" />

Well-tested and customizable **[Ansible](https://www.ansible.com)** setup to provision your workstation with Debian.

Get your system back under control. Manage packages not provided by default and keep track of repositories as well as of installed software. Any bundled package offers the possibility to fully manage them, i.e. make sure they are installed or removed. Of course you can also simply ignore them, in case you want to manage them yourself.

It is designed to be a generic **buildfiles** (as opposed to **[dotfiles](https://github.com/cytopia/dotfiles)**) manager. You can add as many profiles as you want (e.g.: for different hardware on different notebooks) and also have the choice to provision it locally or over the network.

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
    1. [Build the Docker image](#build-the-docker-image)
    1. [Run the Docker container](#run-the-docker-container)
5. **[Options](#options)**
    1. [Enable / Disable Management](#enable--disable-management)
    2. [Package options](#package-options)
6. **[Requirements](#requirements)**
    1. [Install system requirements](#install-system-requirements)
    2. [Sudo permissions](#sudo-permissions)
7. **[Stability](#stability)**
8. **[Other OS](#other-os)**
9. **[Contributing](#contributing)**
10. **[License](#license)**


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

##### Provision only a specific role
```
ansible-playbook -i inventory playbook.yml --diff --limit debian-stretch --ask-become-pass -t i3-gaps
```


## Features

This Ansible repository allows you to provision your Debian machines and keeping them up-to-date. It allows you to create different profiles for different machines and offers packages that are not available by any Debian repository.

This is a base idempotent provisioning with sensible defaults that can be slightly adjusted. It is only meant as a **buildfiles** bootstrap. In order to customize the applications itself, you will still have to apply your personal **[dotfiles](https://github.com/cytopia/dotfiles)** on top of that.

#### Available tools 
<table>
 <thead>
  <tr>
   <th width="200">Tool</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><a href="https://github.com/cytopia/autorunner">autorunner</a></td>
   <td>Configurable and notification aware autostart helper for minimalistic window managers like i3, openbox and others</td>
  </tr>
  <tr>
   <td><a href="https://www.chromium.org/Home">chromium</a></td>
   <td>Sets up Chromium, additional packages as well as specified extensions from Chrome webstore</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cdown/clipmenu">clipmenu</a></td>
   <td>Clipboard manager with <code>dmenu</code> or <code>rofi</code> integration</td>
  </tr>
  <tr>
   <td><a href="https://dbeaver.jkiss.org">dbeaver</a></td>
   <td>Universal SQL Client</td>
  </tr>
  <tr>
   <td><a href="https://github.com/K-Phoen/Config/blob/master/bin/diff-highlight">diff-highlight</a></td>
   <td>Tool for awesome <code>git diff</code> output</td>
  </tr>
  <tr>
   <td><a href="https://docs.docker.com/engine/installation/linux/docker-ce/debian">docker</a></td>
   <td>Docker repo and package and also making sure user is added to <code>docker</code> group</td>
  </tr>
  <tr>
   <td><a href="https://docs.docker.com/compose/install">docker-compose</a></td>
   <td>Downloads latest <code>docker-compose</code> binary</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/ffscreencast">ffscreencast</a></td>
   <td>FFmpeg wrapper for desktop-recording with video overlay and multi monitor support</td>
  </tr>
  <tr>
   <td><a href="https://www.mozilla.org/en-US/firefox/new">firefox</a></td>
   <td>Firefox Quantum</td>
  </tr>
  <tr>
   <td><a href="https://github.com/junegunn/fzf">fzf</a></td>
   <td>Command line fuzzy finder</td>
  </tr>
  <tr>
   <td><a href="https://www.gimp.org">gimp</a></td>
   <td>Gimp with <a href="https://github.com/draekko/gimp-cc-themes">Photoshop theme and keybindings</a></td>
  </tr>
  <tr>
   <td><a href="https://www.hipchat.com/downloads">hipchat</a></td>
   <td>HipChat repo and package</td>
  </tr>
  <tr>
   <td><a href="https://github.com/i3/i3">i3</a></td>
   <td>i3wm</td>
  </tr>
  <tr>
   <td><a href="https://github.com/Airblader/i3">i3-gaps</a></td>
   <td>i3wm on steroids</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/i3-utils-bin">i3-utils-bin</a></td>
   <td>Tools for i3wm</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/i3-utils-systemd">i3-utils-systemd</a></td>
   <td>Systemd files for i3wm</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/i3blocks-modules">i3blocks-modules</a></td>
   <td>Awesome i3blocks modules</td>
  </tr>
  <tr>
   <td><a href="https://www.libreoffice.org/">libreoffice</a></td>
   <td>LibreOffice 6 with <a href="http://www.deviantart.com/art/Office-2013-theme-for-LibreOffice-512127527">MsOffice 2013 Icon theme</a></td>
  </tr>
  <tr>
   <td><a href="https://wiki.archlinux.org/index.php/LXDM">lxdm</a></td>
   <td>Leight-weight login manager</td>
  </tr>
  <tr>
   <td><a href="https://github.com/neovim/neovim">neovim</a></td>
   <td>vim on steroids</td>
  </tr>
  <tr>
  <tr>
   <td><a href="https://wiki.archlinux.org/index.php/NetworkManager">network-manager</a></td>
   <td>Gnome's LAN and WIFI network manager with optional system tray</td>
  </tr>
  <tr>
   <td><a href="https://www.packer.io">packer</a></td>
   <td>HashiCorp's packer to build automated machines</td>
  </tr>
  <tr>
   <td><a href="https://github.com/robbyrussell/oh-my-zsh">oh-my-zsh</a></td>
   <td>A delightful community-driven framework for managing your zsh configuration.</td>
  </tr>
  <tr>
   <td><a href="https://pinta-project.com/pintaproject/pinta">pinta</a></td>
   <td>Open source Paint.Net / MsPaint clone.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/ranger/ranger">ranger</a></td>
   <td>Command line file manager with inline image preview (can also be used as <a href="https://www.everythingcli.org/use-ranger-as-a-file-explorer-in-vim/">vim file manager</a>)</td>
  </tr>
  <tr>
   <td><a href="https://www.skype.com/en/get-skype">skype</a></td>
   <td>Skype repo and package</td>
  </tr>
  <tr>
   <td><a href="https://www.sublimetext.com">sublime</a></td>
   <td>Sublime repo and package</td>
  </tr>
  <tr>
   <td><a href="https://github.com/muennich/sxiv">sxiv</a></td>
   <td>Small, fast and low-dependency image viewer with vim binding</td>
  </tr>
  <tr>
   <td><a href="https://freedesktop.org/wiki/Software/systemd/">systemd</a></td>
   <td>Manage enabled, disabled and masked systemd services</td>
  </tr>
  <tr>
   <td><a href="https://telegram.org">telegram</a></td>
   <td>Telegram desktop repo and package</td>
  </tr>
  <tr>
   <td><a href="https://wiki.archlinux.org/index.php/Thunar">thunar</a></td>
   <td>Thunar and its requirements to handle external disks as well as encrypted disks</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/thunar-custom-actions">thunar-custom-actions</a></td>
   <td>Thunar custom actions</td>
  </tr>
  <tr>
   <td><a href="https://www.mozilla.org/en-US/thunderbird">thunderbird</a></td>
   <td>Thunderbird and globally defined add-ons</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/linux-timemachine">timemachine</a></td>
   <td>OSX like timemachine for the command line</td>
  </tr>
  <tr>
   <td><a href="http://rxvt.sourceforge.net">urxvt</a></td>
   <td>Small, fast and leight-weight 256 color unicode terminal emulator</td>
  </tr>
  <tr>
   <td><a href="https://www.virtualbox.org">virtualbox</a></td>
   <td>VirtualBox upstream repository and packages</td>
  </tr>
  <tr>
   <td><a href="https://github.com/wavexx/acpilight">xbacklight</a></td>
   <td>Modern cross-GPU xbacklight replacement</td>
  </tr>
  <tr>
   <td><a href="https://wiki.archlinux.org/index.php/Default_applications">xdg-mime-meta</a></td>
   <td>Defines default applications for xdg-open</td>
  </tr>
  <tr>
   <td><a href="https://www.x.org/wiki">xorg</a></td>
   <td>Xorg and its dependencies as well as GPU and touchpad configurations</td>
  </tr>
  <tr>
   <td><a href="https://pwmt.org/projects/zathura">zathura</a></td>
   <td>Small, fast and low-dependency pdf viewer with vim bindings</td>
  </tr>
 </tbody>
</table>

#### Fonts / Themes
<table>
 <thead>
  <tr>
   <th width="200">Tool</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><a href="https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/DroidSansMono">font-droid-sans-mono</a></td>
   <td>DroidSansMono Nerdfont with many glyphs and unicode symbols</td>
  </tr>
  <tr>
   <td><a href="http://fontawesome.io/icons">font-font-awesome</a></td>
   <td>FontAwesome as a system font</td>
  </tr>
  <tr>
   <td><a href="https://github.com/supermarin/YosemiteSanFranciscoFont">font-san-francisco</a></td>
   <td>OSX Yosemite San Francisco font</td>
  </tr>
  <tr>
   <td><a href="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Terminus/font-info.md">font-terminus</a></td>
   <td>Terminus Nerdfont with many glyphcs and unicode symbols</td>
  </tr>
  <tr>
   <td><a href="https://design.ubuntu.com/font">font-ubuntu</a></td>
   <td>Ubuntu's official font</td>
  </tr>
  <tr>
   <td><a href="https://snwh.org/moka">icon-moka</a></td>
   <td>Moka icon themes (for thunar or nautilus)</td>
  </tr>
  <tr>
   <td><a href="https://github.com/horst3180/Arc-theme">theme-arc</a></td>
   <td>Arc theme for GTK2, GTK3, Chrome and others</td>
  </tr>
 </tbody>
</table>

See [roles/](roles/) directory for all available packages. If you are missing one, open up an issue or a pull request.

#### Sensible customizations

Additionally you can (but don't have to) manage the following:

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
ansible-playbook -i inventory playbook.yml --diff --limit dell-xps-i3wm --ask-become-pass --check
```
Run the following command to actually apply your profile:
```shell
ansible-playbook -i inventory playbook.yml --diff --limit dell-xps-i3wm --ask-become-pass
```



## Test your profile
Before actually running any new profile on your own system, you can and you should test that beforehand in a **Docker container** in order to see if everything works as expected. This might also be very handy in case you are creating a new role and want to see if it works.

#### Build the Docker image
```
docker build -t ansible-debian .
```
#### Run the Docker container

Before running you should be aware of a few environment variables that can change the bevaviour of the test run. See the table below:

| Variable  | Required | Description |
|-----------|----------|-------------|
| `MY_HOST` | yes      | The inventory hostname (your profile) |
| `verbose` | no       | Ansible verbosity. Valid values: `0`, `1`, `2` or `3` |
| `tag`     | no       | Only run this specific tag (role name) |
| `random`  | no       | When running everything, do it in a random order. Valid values: `0` or `1` |

Run a full test of profile `debian-testing`:
```
docker run --rm -e MY_HOST=debian-testing -t ansible-debian
```
Run a full test of profile `debian-testing` in a random order:
```
docker run --rm -e MY_HOST=debian-testing -e random=1 -t ansible-debian
```
Only runt `i3-gaps` role in profile `debian-stretch`
```
docker run --rm -e MY_HOST=debian-stretch -e tag=i3-gaps -t ansible-debian
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

Many packages also come with options that you can tweak. You can for example define the Python version your system should provide:
```yml
$ vi host_vars/<name>.yml

...
python_2: yes
python_3: yes
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
```
apt-get update
apt-get install --no-install-recommends --no-install-suggests -y \
  python-apt \
  python-dev \
  python-jmespath \
  python-pip \
  python-setuptools \
  sudo

pip install wheel
pip install ansible
```

#### Sudo permissions

Make sure your user is allowed run sudo
```
usermod -aG sudo <username>
```


## Stability

In order to guarantee the most possible stability of this setup, extensive [travis-ci](https://travis-ci.org/cytopia/ansible-debian) checks have been defined which automatically run every night. Those tests are run inside a Docker container. The following test cases have been defined:

* Each run is done randomized and in order as well as for each role separately
* Each run is done for Debian stable and Debian testing
* Each run is done against all defined profiles (repositories: main vs main, extra and non-free)


## Other OS

If you are running a different OS and still want to provision your system with Ansible, have a look at the following similar projects:

* Ubuntu - **[ansible-linux-laptop](https://github.com/dyindude/ansible-linux-laptop)**
* Ubuntu - **[ansible-ubuntu](https://github.com/Benoth/ansible-ubuntu)**
* Fedora - **[laptop_install](https://github.com/e-minguez/laptop_install)**


## Contributing

Please feel free to contribute and add new roles as desired. When doing so have a look at **[CONTRIBUTING.md](CONTRIBUTING.md)** for required best-practices.


## License

[MIT License](LICENSE.md)

Copyright (c) 2017 [cytopia](https://github.com/cytopia)
