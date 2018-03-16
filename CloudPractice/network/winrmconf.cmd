echo "winrm step 1"
cmd.exe /c winrm quickconfig -q
echo "step 2"
cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
echo "step 3"
cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}
echo "step 4"
cmd.exe /c netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" profile=public protocol=tcp localport=5985 remoteip=localsubnet new remoteip=any
echo "winrm complete"

