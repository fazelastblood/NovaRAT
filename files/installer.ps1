# builds resources for rat
# made by : Code0

# random String for directories
function random_text {
    return -join((65..90)+(97..122) | Get-Random -Count 5 | % {[char]$_})
}

## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = %cd%

#goto temp, make working directory
mkdir $path
cd $path
echo "" > poc. txt
cd $initial_dir
Remove-Item installer.ps1
