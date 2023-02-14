VM Image Builder Scripts

<https://github.com/simula/nornet-vmimage-builder-scripts>


# Introduction

This repository contains VM image building scripts, to automatically generate fresh VM images for different projects. The scripts use Packer (<https://www.packer.io>).


# VM Types

## VirtualBox

The VirtualBox images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything).

## QEMU

The QEMU images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything). These images are mainly useful for OpenStack, for which the layout should be 1-disk.

## Docker

TBD.

## vSphere

TBD.


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


# Projects

Details can be found in the directory [projects](https://github.com/simula/nornet-vmimage-builder-scripts/tree/master/projects).

## Minimal

Basic minimal installation.

## NorNet

Basic for general-purpose server usage, particularly for working with NorNet <https://www.nntb.no> purposes. Features (see also directory [user-settings](https://github.com/simula/nornet-vmimage-builder-scripts/blob/master/scripts/user-settings)):
* OpenSSH installed.
* Joe editor installed.
* [System-Tools](https://www.nntb.no/~dreibh/system-tools/) installed.
* NorNet tools, particularly also including up-to-date [NetPerfMeter](https://www.nntb.no/~dreibh/netperfmeter/), [HiPerConTracer](https://www.nntb.no/~dreibh/hipercontracer/index.html), [SubNetCalc](https://www.nntb.no/~dreibh/subnetcalc/index.html), installed.
* Localisation files for some English variants, German, Norwegian and Chinese installed.
* Sysctl: Explicit Congestion Notification (ECN) enabled.

## NorNet-Desktop

Basic NorNet VMs for general-purpose desktop usage. They base on the NorNet images, with additional KDE desktop. Features (see also directory [user-settings](https://github.com/simula/nornet-vmimage-builder-scripts/blob/master/scripts/user-settings)):
* Configured switchable keyboard layout (DE, NO, US).
* Configured 4 virtual desktops.
* Configured Firefox with enhanced privacy settings (delete cookies and history on close, "phone-home" anti-features disabled, etc.) as well as NoScript and uBlock Origin add-ons.
* Ubuntu 22.04+: Firefox is installed from PPA mozillateam/ppa (<https://launchpad.net/~mozillateam/+archive/ubuntu/ppa/+packages>), instead of using the Snap package.

## NEAT

Basic for general-purpose desktop usage, particularly for working with NEAT <https://www.neat-project.org>. They base on the NorNet-Desktop images, with NEAT packages and build environment. Features (see also directory [user-settings](https://github.com/simula/nornet-vmimage-builder-scripts/blob/master/scripts/user-settings)):
* [NEAT](https://github.com/NEAT-project/neat) installed (NEAT library as well as NEAT sockets API library).
* Source repositories cloned under ~/src. Build dependencies are already installed.

## RSerPoolDemo

Basic for general-purpose desktop usage, particularly for working with RSerPool <https://www.nntb.no/~dreibh/rserpool/>. They base on the NorNet-Desktop images, with RSPLIB packages and build environment. Features (see also directory [user-settings](https://github.com/simula/nornet-vmimage-builder-scripts/blob/master/scripts/user-settings)):
* [RSPLIB](https://www.nntb.no/~dreibh/rserpool/index.html#Download) installed.
* [RSerPoolDemo-Tool](https://www.nntb.no/~dreibh/rserpool/index.html#DemoTool) installed.
* Source repositories cloned under ~/src. Build dependencies are already installed.

## SimulaMet-Desktop

These are SimulaMet desktop VMs. They base on the NorNet-Desktop images.

## 5gVINNI

Basic for general-purpose desktop usage, particularly for working with 5gVINNI <https://www.5g-vinni.eu/>. They base on the NorNet images.
