#!/bin/bash

## Example Usage `SetupHosts`
read -p 'Enter the Window Server IP: ' winServerIp

## This goes in /etc/ansible/hosts
setup_hosts ()
{
echo -e "\n
[windows]
winsrv19 ansible_host=$winServerIp
    
[windows:vars]
ansible_user=administrator
ansible_password=Password123
ansible_connection=winrm
ansible_winrm_transport=basic
ansible_port=5985" >> /etc/ansible/hosts
}

setup_hosts

# Test to make sure we can hit the windows host we defined above
ansible windows -m win_ping