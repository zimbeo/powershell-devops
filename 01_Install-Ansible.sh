#!/bin/bash

## Run this script on the CentOS host that will be the Ansible control node
sudo yum update

# Make sure we have the repo we need as a package source
sudo yum install epel-release

# Install the ansible binaries
sudo yum install ansible

## Install
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py

## Install Python WinRM support to contact Windows hosts
sudo pip install "pywinrm>=0.3.0"