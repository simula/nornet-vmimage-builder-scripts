VM Image Builder Scripts

<https://github.com/simula/nornet-vmimage-builder-scripts>


# Table of Contents
-   [Introduction](#introduction)
-   [VM Types](#vm-types)
    -   [VirtualBox](#virtualbox)
    -   [Proxmox](#proxmox)
    -   [QEMU](#qemu)
    -   [vSphere](#vsphere)
    -   [Docker](#docker)
-   [Systems](#systems)
    -   [Ubuntu Linux](#ubuntu-linux)
    -   [Debian Linux](#debian-linux)
    -   [Fedora Core Linux](#fedora-core-linux)
    -   [FreeBSD](#freebsd)
-   [Projects](#projects)
    -   [Minimal](#minimal)
    -   [Basic](#basic)
    -   [KDE](#kde)
    -   [Development](#development)
    -   [KDE+Development](#kdedevelopment)
    -   [Further Projects](#further-projects)
        -   [NorNet](#nornet)
        -   [NorNet-Desktop](#nornet-desktop)
        -   [NEAT](#neat)
        -   [RSerPoolDemo](#rserpooldemo)
        -   [SimulaMet-Desktop](#simulamet-desktop)
        -   [5gVINNI](#gvinni)


# Introduction

This repository contains Virtual Machine (VM) image building scripts, to automatically generate freshly installed VM images for different projects and purposes, like minimal servers, development environments, as well as full desktop machines. The scripts use Packer (<https://www.packer.io>).


# VM Types

## VirtualBox

The VirtualBox images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything).

## Proxmox

VMs for usage in Proxmox. They are basically like the VirtualBox variant, with the QEMU Guest Agent installed.

## QEMU

The QEMU images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything). These images are mainly useful for OpenStack, for which the layout should be 1-disk.

## vSphere

VMs for usage in vSphere. They are basically like the VirtualBox variant, with the Open VM Tools installed.

## Docker

Containers for usage in Docker.


# Systems

The following operating systems are provided:
* [Ubuntu Linux](https://ubuntu.com/)
* [Debian Linux](https://www.debian.org/)
* [Fedora Core Linux](https://getfedora.org/de/)
* [FreeBSD](https://www.freebsd.org/)

Details can be found in the directories [installer](https://github.com/simula/nornet-vmimage-builder-scripts/tree/master/installer) and [http](https://github.com/simula/nornet-vmimage-builder-scripts/tree/master/http).

## Ubuntu Linux

General settings:
* Base: Ubuntu Server ISO
* EFI boot
* Using BTRFS for / and /home, with subvolumes @ and @home.
* Added Launchpad PPA dreibh/ppa (<https://launchpad.net/~dreibh/+archive/ubuntu/ppa/+packages>).
* Purged and blocked snapd. To install snapd again, remove /etc/apt/preferences.d/block-snapd.pref!

## Debian Linux

General settings:
* Base: Debian Netinstall ISO
* EFI boot
* Using BTRFS for / and /home, with subvolumes @ and @home.

## Fedora Core Linux

General settings:
* Base: Fedora Core Netinstall ISO
* EFI boot
* Added COPR PPA dreibh/ppa (<https://copr.fedorainfracloud.org/coprs/dreibh/ppa/>).

## FreeBSD

General settings:
* Base: FreeBSD installation ISO
* EFI boot
* Using ZFS for / and /home.


# Projects

Details can be found in the directory [projects](https://github.com/simula/nornet-vmimage-builder-scripts/tree/master/projects).

## Minimal

The minimal installation for the system with the settings described above. This project is meant mainly for testing purposes. In most cases, you want the [Basic](#basic) project instead!

Provided packages:
* Bash (shell)
* cURL (download tool)
* Git (revision management)
* GnuPG (cryptography for signature checks)
* Ping (network connectivity check)
* Sudo (privileged command execution)
* Virt-What (identification of virtualisation environment)

Further properties:
* Bash as default shell
* ECN enabled
* SCTP enabled
* SSH server enabled
* Hardened SSH server and client settings
* UTF-8 character encoding


## Basic

The "Basic" installation is based on the [Minimal](#minimal) installation.

It must contain the following packages:
* Base64 (base64 tool)
* [BWM-NG](https://github.com/vgropp/bwm-ng) (simple bandwidth monitor)
* [BZip2](https://sourceware.org/bzip2/) (compression tool)
* [cURL](https://curl.se/) (download tool)
* [EthTool](https://mirrors.edge.kernel.org/pub/software/network/ethtool/) (Ethernet card configuration tool; on Linux systems only!)
* [Fail2Ban](https://github.com/fail2ban/fail2ban) (prevent brute-force SSH attacks)
* [GDisk](https://sourceforge.net/projects/gptfdisk/) (GPT partitioning tool)
* GrowPart (Partition growing tool; on Linux systems only!)
* [GNU Wget](https://www.gnu.org/software/wget/) (download tool)
* [HiPerConTracer](https://www.nntb.no/~dreibh/hipercontracer/) (high-performance network tracing tool)
* [HTop](https://htop.dev/) (process monitor)
* [Joe](https://joe-editor.sourceforge.io/) (editor)
* [JQ](https://jqlang.github.io/jq/) (JSON editing tool)
* [NMap](https://nmap.org/) (network testing tool)
* Manual page utilities (manual page viewer)
* [NetPerfMeter](https://www.nntb.no/~dreibh/netperfmeter/) (network performance metering tool)
* [NetPlan](https://netplan.io/) (network configuration; on Linux systems only!)
* Ping, Traceroute, ifconfig (basic networking tools)
* PLocate ("locate" command for finding files)
* PwGen (password generator)
* [Python](https://www.python.org/) (Python 3 interpreter)
* [RSPLIB RSerPool](https://www.nntb.no/~dreibh/rserpool/) Tools (RSerPool testing tools)
* [SubNetCalc](https://www.nntb.no/~dreibh/subnetcalc/) (address calculator)
* [System-Tools](https://www.nntb.no/~dreibh/system-tools/) (system information on login)
* Tree (tree view of directory hierachy)
* [T-Shark](https://www.wireshark.org/) (packet sniffer, CLI-version for Wireshark)


## KDE

The "KDE" installation is based on the [Basic](#basic) installation.

It must contain the following packages:
* The KDE Plasma Desktop with Oxygen theme and SDDM
* [Dia](https://wiki.gnome.org/Apps/Dia )(drawing tool)
* [Firefox](https://www.mozilla.org/en-US/firefox/new/) (web browser)
* [FractGen](https://www.nntb.no/~dreibh/fractalgenerator/) (fractal generator)
* [LibreOffice](https://www.libreoffice.org/) (office suite)
* [Gimp](https://www.gimp.org/) (graphics editing tool)
* [Inkscape](https://inkscape.org/) (drawing tool)
* [Kate](https://kate-editor.org/) (editor)
* [Kile](https://kile.sourceforge.io/) (LaTeX editor)
* [Konsole](https://konsole.kde.org/) (console)
* [Okular](https://okular.kde.org/) (file viewer, e.g. for PDF)
* [R](https://www.r-project.org/) (statistical computing suite)
* [Wireshark](https://www.wireshark.org/) (packet sniffer, GUI version)

Further properties:
* Configured KDE and SDDM login manager
* Configured 4 virtual desktops.
* Configured switchable keyboard layout (DE, NO, US).
* Configured Firefox (hardened settings, enhanced privacy settings, as well as some add-ons like NoScript, uBlock Origin, etc.)
* Ubuntu 22.04+: Firefox is installed from PPA mozillateam/ppa (<https://launchpad.net/~mozillateam/+archive/ubuntu/ppa/+packages>), instead of using the Snap package.


## Development

The "Development" installation is based on the [Basic](#basic) installation.

It must contain the following packages:
* BC (arbitrary precision calculator language)
* CLang (CLang C and C++ compilers)
* CMake (build tool)
* ExifTool (EXIF metadata editing tool for images)
* GhostScript (PostScript interpreter and fonts)
* GNU Autoconf/Automake/Libtool (basic build tools)
* GNU Bison (parser generator)
* GNU Flex (lexical analyser generator)
* GNU GCC/G++, GNU Make, GNU Debugger (compilers, debugger and make tool)
* GNU R (statistical computing language)
* GraphicsMagick (image conversion)
* LibTool (build tool for libraries)
* PkgConfig (metainformation about installed libraries)
* Python (Python 3 interpreter, tools and PIP package management)
* ShellCheck (checker tool for shell scripts)
* Valgrind (debugging tool)
* YamlLint (checker tool for YAML)
* RepRepro (DEB repository build tool; on Linux systems only!)
* PBuilder (DEB build tool; on Linux systems only!)

It must contain the following libraries and development files:
* BOOST (portable C++ libraries)
* SCTP

Further properties:
* Password-less sudo calls
  WARNING: Development settings are intended for developers only!
* Source packages enabled from package manager (if available)


## KDE+Development

The "KDE+Development" installation is based on the [KDE](#kde) and [Development](#development) installation.


## Further Projects

### NorNet

Basic for general-purpose server usage, particularly for working with NorNet <https://www.nntb.no> purposes.

### NorNet-Desktop

Basic NorNet VMs for general-purpose desktop usage. They base on the NorNet images, with additional KDE desktop.

### NEAT

Basic for general-purpose desktop usage, particularly for working with NEAT <https://www.neat-project.org>. They base on the NorNet-Desktop images, with NEAT packages and build environment.

Features:
* [NEAT](https://github.com/NEAT-project/neat) installed (NEAT library as well as NEAT sockets API library).
* Source repositories cloned under ~/src. Build dependencies are already installed.

### RSerPoolDemo

Basic for general-purpose desktop usage, particularly for working with RSerPool <https://www.nntb.no/~dreibh/rserpool/>,
based on the [KDE+Development](#kdedevelopment) installation.

Features:
* [RSPLIB](https://www.nntb.no/~dreibh/rserpool/index.html#Download) installed.
* [RSerPoolDemo-Tool](https://www.nntb.no/~dreibh/rserpool/index.html#DemoTool) installed.
* Source repositories cloned under ~/src. Build dependencies are already installed.

### SimulaMet-Desktop

These are SimulaMet desktop VMs, based on the [KDE+Development](#kdedevelopment) installation.

Features:
* SimulaMet-related source repositories already checked out.

### 5gVINNI

Basic for general-purpose desktop usage, particularly for working with [5gVINNI](https://www.5g-vinni.eu/). They base on the NorNet images.
