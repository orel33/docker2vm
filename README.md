# Make a VM Image from a Docker Image

We propose here a small script to convert a docker image into a VM image (qemu),
based on [libguestfs](https://libguestfs.org) tools for simplicity. This work is
inspired by [iximiuz's
blog](https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/),
also available on [GitHub](https://github.com/iximiuz/docker-to-linux).

## Dependencies

First, you need to install **Docker** and **Qemu**. Then, you need to fulfill
these additional requirements for *libguestfs* or *extlinux*.

```bash
$ sudo apt install qemu-system-x86 qemu-utils
$ sudo apt install guestfs-tools extlinux
```

## Usage

Given a docker container name `docker>`, our script (named `./docker2vm.sh`)
makes an output VM image `<vm.img>` (in raw format), that runs on
`qemu-system-x86_64`. It requires *root* privilege.

```
Usage: ./docker2vm.sh <docker> <vm.img>
```

**Remark**: It is required to install in your container both a linux kernel and
systemd : `sudo apt install -yq linux-image-amd64 systemd-sysv`. While this step
is not useful for the container itself, it will be useful to make a bootable VM
image.

## Demo

Lets's build a *Debian11* VM image based on a basic dockerfile `Dockerfile.debian11`.

```bash
# build docker
$ docker build -f Dockerfile.debian11 -t tmp/debian11 .
# make vm image
$ sudo ./docker2vm.sh tmp/debian11 debian11.img
$ sudo chown $USER:$USER debian11.img
# test vm with Qemu
$ ./run.sh debian11.img
```

Finally, you can convert this raw image in another format for Qemu (qcow2) or
VirtualBox (vdi).

```bash
# convert in qcow2 format for Qemu
$ qemu-img convert -c debian11.img -O qcow2 debian11.qcow2
# convert in vdi format for VirtualBox
$ VBoxManage convertfromraw --format vdi debian11.img debian11.vdi
```

---
<aurelien.esnard@u-bordeaux.fr>
