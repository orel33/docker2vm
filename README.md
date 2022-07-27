# Make a VM Image from a Docker Image

We propose here a small script to convert a docker image into a VM image (qemu),
based on [libguestfs](https://libguestfs.org) tools for simplicity. This work is
inspired by [iximiuz's
blog](https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/),
also available on [GitHub](https://github.com/iximiuz/docker-to-linux).

## Dependencies

First, you need to install **Docker** and **Qemu**. Then, you need to fulfill
these sdditional requirements:

```bash
$ sudo apt install guestfs-tools extlinux
```

## Sample

```bash
# build docker
$ docker build -f Dockerfile.debian11 -t tmp/debian11 .
# build vm
$ sudo ./docker2vm.sh tmp/debian11 debian11.img
$ sudo chown $USER:$USER debian11.img
# test vm
$ ./run.sh debian11.img
```

---
<aurelien.esnard@u-bordeaux.fr>
