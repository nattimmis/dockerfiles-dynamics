Install-WindowsFeature Web-Server
Install-WindowsFeature NET-Framework-45-ASPNET
Install-WindowsFeature Web-Asp-Net45
Install-WindowsFeature Web-Filtering
Install-WindowsFeature Web-CGI
Install-WindowsFeature Web-ISAPI-Ext
Install-WindowsFeature Web-ISAPI-Filter
Install-WindowsFeature Web-Mgmt-Tools -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature Web-Net-Ext
Install-WindowsFeature Web-Net-Ext45
Install-WindowsFeature Web-Windows-Auth

Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/AnonymousAuthentication -name enabled -value false -PSPath IIS:\
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/windowsAuthentication -name enabled -value true -PSPath IIS:\