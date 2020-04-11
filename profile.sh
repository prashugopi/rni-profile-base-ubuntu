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
    apt install -y tasksel && \
    tasksel install ${ubuntu_bundles} && \
    apt install -y ${ubuntu_packages}\"'" \
    ${PROVISION_LOG}

run "Installing civ " \
    "mkdir -p $ROOTFS/opt/civ && \
     cd $ROOTFS/opt/civ && \
     wget http://${PROVISIONER}${param_httppath}/start_android_qcow2.sh && \
     wget http://${PROVISIONER}${param_httppath}/start_flash_usb.sh && \
     wget http://${PROVISIONER}${param_httppath}/setup_host.sh && \
     wget http://${PROVISIONER}${param_httppath}/auto_switch_pt_usb_vms.sh && \
     chmod +x *.sh && \
     wget http://${PROVISIONER}${param_httppath}/caas-flashfiles-eng.build.zip " \
    ${PROVISION_LOG}

