param(
    [Parameter(Mandatory=$true)]
    [String]$SERVERINSTANCE
)

$currDir = Split-Path $MyInvocation.MyCommand.Definition

$process = 'msiexec.exe'
$params = " SERVERINSTANCE=" + $SERVERINSTANCE
$arguments = '/i "C:\\install\\content\\DynamicsNavDvd\\ServiceTier\\Microsoft Dynamics NAV Service.msi" /quiet /qn /norestart /log "C:\install\content\LOG\installnst.log"' + $params

# Copy Missing Files
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\install\content\ExtraDependencies' -TargetDirectory ($env:windir + '\System32')
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\install\content\DynamicsNavDvd\ServiceTier\System64Folder' -FileNames @("NavSip.dll") -TargetDirectory 'C:\Windows\SysWOW64'    

$res = Start-Process -FilePath $process -ArgumentList $arguments -Wait -PassThru

while ($res.HasExited -eq $false) {
    Write-Host "Waiting for $process..."
    Start-Sleep -s 1
}

# Change service startup type to Disabled (we don`t want to run main and unconfigured default instance) and stop it.
$navSvc = Get-Service '*MicrosoftDynamicsNavServer*' 
Set-Service $navSvc.Name -StartupType Disabled
Stop-Service $navSvc.Name

# Copy missing dlls
& (Join-Path $currDir Copy-ItemsTo.ps1) -ParentDirectory 'c:\install\content\ExtraDependencies' -FileNames $filesToCopy -TargetDirectory "c:\windows\system32"

$exitCode = $res.ExitCode