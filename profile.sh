#!/bin/bash

# Copyright (C) 2019 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

set -a

#this is provided while using Utility OS
source /opt/bootstrap/functions

# --- Config
ubuntu_bundles="ubuntu-desktop openssh-server"
ubuntu_packages="net-tools vim software-properties-common apt-transport-https wget"

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

# --- Install WLC files ---
run "Installing WLC on Ubuntu ${param_basebranch} ${PROVISIONER}${param_httppath}" \
    "mkdir -p $ROOTFS/opt && \
     cd $ROOTFS/opt && \
     wget -r -np -nH --cut-dirs=3 -R index.html ${param_basebranch}/files/wlc/" \
    ${PROVISION_LOG}

# --- Install qemu files ---
run "Installing qemu on Ubuntu ${param_bootstrapurl} " \
    "mkdir -p $ROOTFS/opt/qemu && \
     cd $ROOTFS/opt/qemu && \
     wget ${param_bootstrapurl}/prebuilt/qemu420.tar.gz && \
     tar xvf qemu420.tar.gz && \
     cd $ROOTFS/opt/qemu/qemu && \
     rsync -av --update * $ROOTFS/usr/ " \
    ${PROVISION_LOG}
