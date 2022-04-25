<# This function can be used to test winRM connectivity to the windows server host, it will attempt to connect to the machine
via winRM and report back if an issue occurs. Once connected it will invoke the $scriptBlock variable to configure Ansible #>

$winHostIp = Read-Host -Prompt "Input the Windows Host IP"
$Username = Read-Host -Prompt "Input the Username for the Windows machine"
$Password = Read-Host -Prompt "Input the Password for the Windows machine"

function Configure-Server($winHostIp, $Password, $Username) {
    ## Build a PS credential, this isn't best practice using plain text pw's in scripts. But the below link has best practice information
    # https://blog.techsnips.io/how-to-create-a-pscredential-object-without-using-get-credential-in-powershell/
    $winHostAdminPassword = ConvertTo-SecureString -String "$Password" -AsPlainText -Force ## Do as I say and not as I do here
    $winHostUserName = "$Username"
    $psCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $winHostUserName, $winHostAdminPassword

    # Try to connect to WinRM now, write out error if it occurs
    try {
        Test-WSMan -ComputerName $winHostIp -Credential $psCredential -Authentication Negotiate
        $winHostSession = New-PSSession -ComputerName $winHostIp -Credential $psCredential

        #Download and run the Ansible-provided WinRm script on the Windows host. Also allowing unencrypted HTTP traffic, bad practice but this is POC
        $scriptBlock = {
            $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
            $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
    	(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
            & $file
            winrm set winrm/config/service '@{AllowUnencrypted="true"}'
        }

        # Run the scriptblock to grab the ansible configuration .ps1, run the file and configure winrm
        Invoke-Command -Session $winHostSession -ScriptBlock $scriptBlock
    }
    catch {
        Write-Host $Error[0]
    }
}

Configure-Server -winHostIp $winHostIp -Password $Password -Username $Username