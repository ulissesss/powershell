winrm invoke Restore winrm/Config
winrm quickconfig
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
$s = New-PSSession -ComputerName <ip_machine> -Credential $credential
#Invoke-WebRequest -Session $s "https://github.com/ulissesss/powershell/raw/main/AD_script_install.ps1" -OutFile "C:\AD_script_install.ps1"
Invoke-Command -Session $s -Command {C:\AD_script_install.ps1}
