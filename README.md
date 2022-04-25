VM Image Builder Scripts

<https://github.com/simula/nornet-vmimage-builder-scripts>


# Introduction

This repository contains VM image building scripts, to automatically generate fresh VM images for different projects.


# VM Types

## VirtualBox

The VirtualBox images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything).

## QEMU

The QEMU images use optimised settings for display, network and storage. Two disk layouts are available: 3-disks (separate disks for /, /home, and swap) and 1-disk (one disk for everything).

## vSphere

TBD.


# Systems

The following operating systems are provided:
* Ubuntu Linux
* Debian Linux
* Fedora Linux
* FreeBSD

## Ubuntu Linux

General settings:
* Added PPA dreibh/ppa (<https://launchpad.net/~dreibh/+archive/ubuntu/ppa/+packages>)
* Using BTRFS for / and /home, with subvolumes @ and @home.
*


# Projects

## NorNet

Basic for general-purpose server usage, particularly for working with NorNet <https://www.nntb.no> purposes.


## NorNet-Desktop

Basic NorNet VMs for general-purpose desktop usage. They base on the NorNet images, with additional KDE desktop.

## NEAT

Basic for general-purpose desktop usage, particularly for working with NEAT <https://www.neat-project.org>. They base on the NorNet images, with additional KDE desktop, NEAT packages and build environment.
