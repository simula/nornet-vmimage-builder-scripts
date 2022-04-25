VM Image Builder Scripts

<https://github.com/simula/nornet-vmimage-builder-scripts>


# Introduction

This repository contains VM image building scripts, to automatically generate fresh VM images for different projects. The scripts use Packer (<https://www.packer.io>).


# VM Types

## VirtualBox

The VirtualBox images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything).

## QEMU

The QEMU images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything). These images are mainly useful for OpenStack, for which the layout should be 1-disk.

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

Basic for general-purpose server usage, particularly for working with NorNet <https://www.nntb.no> purposes.

## NorNet-Desktop

Basic NorNet VMs for general-purpose desktop usage. They base on the NorNet images, with additional KDE desktop.

## NEAT

Basic for general-purpose desktop usage, particularly for working with NEAT <https://www.neat-project.org>. They base on the NorNet images, with additional KDE desktop, NEAT packages and build environment.

## 5gVINNI

Basic for general-purpose desktop usage, particularly for working with 5gVINNI <https://www.5g-vinni.eu/>. They base on the NorNet images.

## RSerPoolDemo

Basic for general-purpose desktop usage, particularly for working with RSerPool <https://www.uni-due.de/~be0001/rserpool/>. They base on the NorNet images, with additional KDE desktop, RSPLIB packages and build environment.

## SimulaMet-Desktop

These are SimulaMet desktop VMs. They base on the NorNet-Desktop images.
