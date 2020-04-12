#!/bin/bash

# Copyright (C) 2019 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

set -a

#this is provided while using Utility OS
source /opt/bootstrap/functions

# --- Config
ubuntu_bundles="ubuntu-desktop openssh-server"
ubuntu_packages="net-tools vim software-properties-common apt-transport-https wget curl \
	git libfdt-dev libpixman-1-dev libssl-dev vim socat libsdl2-dev libspice-server-dev autoconf libtool xtightvncviewer tightvncserver x11vnc uuid-runtime uuid uml-utilities bridge-utils python-dev liblzma-dev libc6-dev libegl1-mesa-dev libepoxy-dev libdrm-dev libgbm-dev libaio-dev libusb-1.0.0-dev libgtk-3-dev bison libcap-dev libattr1-dev \
	wget mtools ovmf dmidecode python3-usb python3-pyudev \
	uuid-dev nasm acpidump iasl"

# --- Install Extra Packages ---
run "Installing Extra Packages on Ubuntu ${param_ubuntuversion}" \
    "docker run -i --rm --privileged --name ubuntu-installer ${DOCKER_PROXY_ENV} -v /dev:/dev -v /sys/:/sys/ -v $ROOTFS:/target/root ubuntu:${param_ubuntuversion} sh -c \
    'mount --bind dev /target/root/dev && \
    mount -t proc proc /target/root/proc && \
    mount -t sysfs sysfs /target/root/sys && \
    LANG=C.UTF-8 chroot /target/root sh -c \
    \"$(echo ${INLINE_PROXY} | sed "s#'#\\\\\"#g") export TERM=xterm-color && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt install -y tasksel && \
    tasksel install ${ubuntu_bundles} && \
    apt install -y ${ubuntu_packages}\"'" \
    ${PROVISION_LOG}

run "Installing civ " \
    "cd $ROOTFS/opt && \
     git clone https://github.com/sedillo/civ.git && \
     cd $ROOTFS/opt/civ && \
     wget http://${PROVISIONER}${param_httppath}/qemu-4.2.0.tar.xz && \
     wget http://${PROVISIONER}${param_httppath}/caas-flashfiles-eng.build.zip " \
    ${PROVISION_LOG}

