#!/bin/bash

# Copyright (C) 2019 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

set -a

#this is provided while using Utility OS
source /opt/bootstrap/functions

# --- Config
ubuntu_bundles="ubuntu-desktop openssh-server"
ubuntu_packages="net-tools vim software-properties-common apt-transport-https wget curl"

# --- Install Extra Packages ---
run "Installing Extra Packages on Ubuntu ${param_ubuntuversion}" \
    "docker run -i --rm --privileged --name ubuntu-installer ${DOCKER_PROXY_ENV} -v /dev:/dev -v /sys/:/sys/ -v $ROOTFS:/target/root ubuntu:${param_ubuntuversion} sh -c \
    'mount --bind dev /target/root/dev && \
    mount -t proc proc /target/root/proc && \
    mount -t sysfs sysfs /target/root/sys && \
    LANG=C.UTF-8 chroot /target/root sh -c \
    \"$(echo ${INLINE_PROXY} | sed "s#'#\\\\\"#g") export TERM=xterm-color && \
    export DEBIAN_FRONTEND=noninteractive && \
    mount ${BOOT_PARTITION} /boot && \
    mount ${EFI_PARTITION} /boot/efi && \
    apt install -y tasksel && \
    tasksel install ${ubuntu_bundles} && \
    apt install -y ${ubuntu_packages}\"'" \
    ${PROVISION_LOG}

run "Installing cic " \
    "mkdir -p $ROOTFS/opt/cic && \
     cd $ROOTFS/opt/cic && \
     wget http://${PROVISIONER}${param_httppath}/cic.tar.gz && \
     tar -xvzf cic.tar.gz" \
    ${PROVISION_LOG}

