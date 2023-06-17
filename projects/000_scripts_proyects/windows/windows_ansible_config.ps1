# Abre una ventana de PowerShell con permisos de administrador
Start-Process powershell -Verb RunAs

# Crea un usuario llamado "ansible" con una contraseña
net user ansible * /add

# Establece la contraseña del usuario "ansible"
net user ansible *

# Da permisos de administrador al usuario "ansible"
net localgroup Administradores ansible /add

# Habilita el protocolo WinRM
winrm quickconfig

# Permite el acceso a través del firewall
netsh advfirewall firewall set rule name="Administración remota de Windows (HTTPS-Entrada)" profile=public protocol=tcp localport=5986 remoteip=localsubnet new remoteip=any

# Agrega el usuario "ansible" al grupo de "Administración remota de Windows"
net localgroup "Administración remota de Windows" ansible /add

# Reinicia el servicio WinRM
net stop winrm
net start winrm