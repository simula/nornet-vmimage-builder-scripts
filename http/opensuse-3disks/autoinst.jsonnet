{
  "product": {
    "id": "Tumbleweed"
  },
  "localization": {
    "keyboard": "<SET_XKBLAYOUT_HERE>",
    "timezone": "UTC"
  },
  "storage": {
    "boot": {
      "configure": true
    },
    "drives": [
      {
        "partitions": [
          {
            "filesystem": {
              "label": "EFI",
              "mountOptions": [],
              "path": "/boot/efi",
              "reuseIfPossible": false,
              "type": "vfat"
            },
            "id": "esp",
            "size": "128 MiB"
          },
          {
            "filesystem": {
              "label": "Root",
              "mountOptions": [],
              "path": "/",
              "reuseIfPossible": false,
              "type": {
                "btrfs": {
                  "snapshots": true
                }
              }
            }
          },
          {
            "delete": true,
            "search": {
              "ifNotFound": "skip"
            }
          }
        ],
        "search": {
          "condition": {
            "name": "/dev/sda"
          },
          "ifNotFound": "error"
        }
      },
      {
        "partitions": [
          {
            "filesystem": {
              "label": "Home",
              "mountOptions": [],
              "path": "/home",
              "reuseIfPossible": false,
              "type": {
                "btrfs": {
                  "snapshots": false
                }
              }
            }
          },
          {
            "delete": true,
            "search": {
              "ifNotFound": "skip"
            }
          }
        ],
        "search": {
          "condition": {
            "name": "/dev/sdb"
          },
          "ifNotFound": "error"
        }
      },
      {
        "partitions": [
          {
            "filesystem": {
              "label": "Swap",
              "mountOptions": [],
              "path": "swap",
              "reuseIfPossible": false
            }
          },
          {
            "delete": true,
            "search": {
              "ifNotFound": "skip"
            }
          }
        ],
        "search": {
          "condition": {
            "name": "/dev/sdc"
          },
          "ifNotFound": "error"
        }
      }
    ],
    "mdRaids": [],
    "volumeGroups": []
  },
  "user": {
    "fullName": "<SET_REALNAME_HERE>",
    "password": "<SET_PASSWORD_HERE>",
    "hashedPassword": false,
    "userName": "<SET_USERNAME_HERE>",
    "sshPublicKeys": []
  },
  "software": {
    "packages": ["openssh-server", "virt-what"],
    "onlyRequired": false
  },
  "scripts": {
    "post": [
      {
        "chroot": true,
        "source": |||
          #!/usr/bin/bash
          localectl set-xkb-map "<SET_XKBLAYOUT_HERE>" "<SET_XKBMODEL_HERE>" "<SET_XKBVARIANT_HERE>"
          systemctl enable sshd
          if command -v firewall-offline-cmd &> /dev/null ; then
            firewall-offline-cmd --add-service=ssh
          fi
          usermod -a -G wheel "<SET_USERNAME_HERE>"
          echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
          echo "Defaults !targetpw" >>/etc/sudoers.d/wheel
          chmod 0440 /etc/sudoers.d/wheel
        |||
      }
    ]
  }
}
