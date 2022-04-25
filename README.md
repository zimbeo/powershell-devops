# powershell devops
This repository stores files and scripts used to configure a POC environment for managing and deploying apps/services to Windows Servers via Ansible.

## Environment## 
- CentOS 7.5 (Control Node)
- Windows Server 2019 (Managed Node)
- Windows 10 Box (Management Box for accessing above nodes)

## Setup ##
1. Begin by running the `01_Install-Ansible.sh` script on the CentOS host. This installs the ansible package and also ensures you have the Python WinRM module installed.
2. Next, run the `02_Configure-Server.ps1` script from your management host. This ensures we can talk on te WinRM service to the Windows Server host. If this communication is sucessful it will open a new Remote PowerShell session and configure the server for remote management with Ansible using this [script](https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)
3. Now that Ansible is installed and the Windows Server should be capable of speaking with the control node, we need to configure the host on the control node. Do this by running `03_Setup_Hosts.sh` on the CentOS host. This will create a group in the /etc/ansible/hosts file and add our server to it. It will also add some plaintext username/pw information so make sure to setup your own credentials before running it.
   1. After the host is configured in /etc/ansible/hosts - the script will also confirm it can speak with Managed Node. The output should be as follows.
    ```
    winsrv19 | SUCCESS => {
    "changed": false,
    "ping": "pong"
    }
    ```
4. Next, we want to take the iissetup.yml playbook file and move it to /etc/ansible/playbooks on the CentOS host, and also take the iissetup.ps1 script and move it to /etc/ansible/scripts. 
5. The playbook is now ready to be executed on the control node which will in turn execute the steps on the Managed Windows Server host. The playbook will configure the site files/directory and also disable the default site and create our own custom one. Finally, the playbook looks copies over the iissetup.ps1 file which enables certain services & features needed for IIS to run. Invoke the playbook using the below
   `ansible-playbook /etc/ansible/playbooks/iissetup.yml -vv`
6. Once the playbook has ran you can navigate to `http://windowsServerIP:8080` and confirm the page was created

## Wrap Up ##
This is a basic overview of using Ansible to systematically deploy services and configurations to Windows Servers. We utilize IIS in this repository but the playbooks can be added to and/or adapted to do whatever you need them to do. Much of the content utiilized in this repository was developed and adapated to be easier to use as I trained on the following [Pluralsight Course](https://app.pluralsight.com/library/courses/powershell-devops-playbook/) so thank you to the author of that course. 