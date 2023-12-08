#Copy the output of the command get-process in running.txt

#Set path of running.txt
$path = "$env:UserProfile\Desktop\running.txt"
#if exist file remove it and create it again
if (Test-Path $path) {
     Remove-Item $path
     Get-Process | Out-File -FilePath $path
} else {
     Get-Process | Out-File -FilePath $path
  
}
