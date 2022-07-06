$SERVICE_RAW=Get-Service -Name W32Time
#$SERVICE | Get-Member -memberType *property
$SERVICE=$SERVICE_RAW.Status

if ($SERVICE -eq "Running") {
    
    w32tm /resync /nowait

}
else {
    
    Set-Service -Name W32Time -StartupType "Manual"
    Start-Service -Name W32Time
    Start-Sleep -Seconds 2
    w32tm /resync /nowait

}

#Stop-Service -Name W32Time