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
        "name": "enable-sshd",
        "chroot": true,
        "content": |||
          #!/usr/bin/bash
          systemctl enable sshd.service
        |||
      }
    ]
  }
}
