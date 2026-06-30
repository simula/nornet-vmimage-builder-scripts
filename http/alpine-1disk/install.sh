#!/bin/ash
#shellcheck shell=dash

# Based on https://github.com/rgl/alpine-vagrant

set -euxo pipefail

DISK_ROOT="sda"
DISK_HOME="sdb"
DISK_SWAP="sdc"

# ====== Partitioning =======================================================
VERSION_ID=$(cut -d. -f1,2 /etc/alpine-release)

echo "https://dl-cdn.alpinelinux.org/alpine/v${VERSION_ID}/main" >/etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/v${VERSION_ID}/community" >>/etc/apk/repositories
apk add parted btrfs-progs dosfstools util-linux

# ------ Root disk ----------------------------------------------------------
parted -s "/dev/${DISK_ROOT}" mklabel gpt
parted -s "/dev/${DISK_ROOT}" mkpart primary fat32 1MiB 63MiB
parted -s "/dev/${DISK_ROOT}" set 1 esp on
parted -s "/dev/${DISK_ROOT}" mkpart primary btrfs 64MiB 100%
mkfs.vfat -F32 "/dev/${DISK_ROOT}1"
mkfs.btrfs -f "/dev/${DISK_ROOT}2"
mount "/dev/${DISK_ROOT}2" /mnt
mkdir -p /mnt/boot/efi
mount "/dev/${DISK_ROOT}1" /mnt/boot/efi

# ------ Home disk ----------------------------------------------------------
parted -s "/dev/${DISK_HOME}" mklabel gpt
parted -s "/dev/${DISK_HOME}" mkpart primary btrfs 1MiB 100%
mkfs.btrfs -f "/dev/${DISK_HOME}1"
mkdir -p /mnt/home
mount "/dev/${DISK_HOME}1" /mnt/home

# ------ Swap disk ----------------------------------------------------------
parted -s "/dev/${DISK_SWAP}" mklabel gpt
parted -s "/dev/${DISK_SWAP}" mkpart primary linux-swap 1MiB 100%
mkswap -f "/dev/${DISK_SWAP}1"
swapon "/dev/${DISK_SWAP}1"

# ====== Setup ==============================================================
cat >answers <<EOF
KEYMAPOPTS="<SET_XKBLAYOUT_HERE> <SET_XKBLAYOUT_HERE>"
HOSTNAMEOPTS="-n alpine"
INTERFACESOPTS="\
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
"
DNSOPTS=""
TIMEZONEOPTS="-z UTC"
PROXYOPTS="none"
APKREPOSOPTS="-1 -c"
USEROPTS="none"
SSHDOPTS="-c openssh"
NTPOPTS="-c openntpd"
DISKOPTS="none"
LBUOPTS="none"
APKCACHEOPTS="none"
EOF
setup-alpine -e -f "$PWD/answers"
BOOTLOADER=grub setup-disk -m sys /mnt

UUID_HOME=$(blkid -o value -s UUID "/dev/${DISK_HOME}1")
UUID_SWAP=$(blkid -o value -s UUID "/dev/${DISK_SWAP}1")
echo "UUID=${UUID_HOME} /home btrfs defaults 0 0" >>/mnt/etc/fstab
echo "UUID=${UUID_SWAP} swap swap defaults 0 0" >>/mnt/etc/fstab

# ====== Basic configuration ================================================

# ------ Configure EFI boot manager -----------------------------------------
apk add efibootmgr
efibootmgr -v
efibootmgr \
   | sed -nE 's,^Boot([0-9A-F]{4}).*,\1,gp' \
   | xargs -I% efibootmgr --quiet --delete-bootnum --bootnum %
efibootmgr \
  -c \
  -d "/dev/${DISK_ROOT}" \
  -p 1 \
  -L Alpine \
  -l '\EFI\alpine\grubx64.efi'

# ====== User ===============================================================
chroot /mnt ash <<EOF
set -euxo pipefail

# ------ Install required packages ------------------------------------------
# NOTE: "shadow" provides usermod
apk add bash btrfs-progs doas shadow sudo virt-what

# ------ Create user --------------------------------------------------------
adduser -D -g '<SET_REALNAME_HERE>' -s /bin/bash -G wheel '<SET_USERNAME_HERE>'
echo '<SET_USERNAME_HERE>':'<SET_PASSWORD_HERE>' | chpasswd

# ------ doas configuration -------------------------------------------------
echo 'permit nopass :wheel' >/etc/doas.d/wheel.conf

# ------ sudo configuration -------------------------------------------------
addgroup sudo
usermod -a -G sudo '<SET_USERNAME_HERE>'
sed -e 's/^# %sudo /%sudo /' -i /etc/sudoers

# ------ Lock the root account ----------------------------------------------
passwd -l root
EOF

# Reboot into the freshly installed system:
reboot
