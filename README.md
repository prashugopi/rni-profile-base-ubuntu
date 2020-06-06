# GVTg instructions

## Prerequisites
These instructions are meant to be executed once you have a fully operation RNI setup

## Configuration file
Edit the file /opt/rni/conf/config.yml

Add the following:
```
  - git_remote_url: https://github.com/sedillo/rni-profile-base-ubuntu.git
    profile_branch: desktop
    profile_base_branch: gvt-base-5.4
    git_username: ""
    git_token: ""
    # This is the name that will be shown on the PXE menu (NOTE: No Spaces)
    name: GVTg_5.4_Ubuntu_18.04_Desktop
    custom_git_arguments: --depth=1
```

Rebuild RNI 
```
./build.sh -s
./run.sh
```
