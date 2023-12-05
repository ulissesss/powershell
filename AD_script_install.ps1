#Script to install AD and populate the Database

get-windowsfeature

#Change hostname and reboot
Rename-Computer -NewName valerio -Force -Passthru -Restart

#Install AD
install-windowsfeature AD-Domain-Services
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName "valerio.net" -DomainNetbiosName "Server" -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString -String Pippo88 -AsPlainText -Force)
Add-WindowsFeature RSAT-AD-PowerShell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools


#Download users and groups csv list
$url1 = "https://raw.githubusercontent.com/ulissesss/powershell/main/users.csv"
$url2 = "https://raw.githubusercontent.com/ulissesss/powershell/main/group.csv"
$dest1 = "c:\users.csv"
$dest2 = "c:\group.csv"
Invoke-WebRequest -Uri $url1 -OutFile $dest1
Invoke-WebRequest -Uri $url2 -OutFile $dest2

#Import groups and users in AD
$Import_Group = Import-Csv -Path c:\group.csv
foreach ($group in $Import_Group) {New-ADGroup -Name $Group.Name -GroupScope Global }
$Import_users = Import-Csv -Path c:\users.csv
foreach ($users in $Import_users) {New-ADUser -Name $users.full -GivenName $users.first -Surname $users.last -SamAccountName $users.first -AccountPassword (ConvertTo-SecureString -AsPlainText Pippo8888888 -Force) -ChangePasswordAtLogon $True -Company "Devops" -Enabled $True }

#two users have the same group
$users=Import-Csv -Path "c:\users.csv" | Select -ExpandProperty first
$groups=Import-Csv -Path "c:\group.csv" | Select -ExpandProperty name
$j = 0
for ($i = 0; $i -lt $users.Count; $i+=2) {
    $user = $users[$i..($i + 1)]
Add-ADGroupMember -Identity $groups[$j] -Members $user
$j++
}

