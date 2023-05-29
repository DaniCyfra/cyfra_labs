# Comprobar si el script se está ejecutando con privilegios de administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script necesita privilegios de administrador. Ejecute PowerShell como administrador y vuelva a intentarlo."
    Exit
}

# Definir los detalles del usuario
$usuario = "ansible"
$contraseña = "xxxxxxxxxxxxxxxxx"

# Crear una nueva contraseña segura
$contraseñaSegura = ConvertTo-SecureString -String $contraseña -AsPlainText -Force

# Crear el nuevo usuario
$crearUsuario = New-LocalUser -Name $usuario -Password $contraseñaSegura -PasswordNeverExpires:$true -UserMayNotChangePassword:$true -AccountNeverExpires:$true -Description "Usuario para fines administrativos"

# Asignar privilegios de administrador al usuario
$grupoAdministradores = Get-LocalGroup -Name "Administrators"
$grupoAdministradores | Add-LocalGroupMember -Member $usuario

if ($crearUsuario) {
    Write-Host "El usuario $usuario se ha creado con éxito y se ha agregado al grupo de administradores."
} else {
    Write-Host "Se produjo un error al crear el usuario."
}

# Instalar Python en el host Windows
Write-Host "Instalando Python en el host Windows..."
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe" -OutFile "python-installer.exe"
Start-Process -Wait -FilePath "python-installer.exe"
Write-Host "Python se ha instalado correctamente."

# Configurar WinRM en el host Windows
Write-Host "`nConfigurando WinRM en el host Windows..."
winrm quickconfig
Get-NetConnectionProfile
$interfaceAlias = Read-Host "Ingresa el Alias de la interfaz (por ejemplo, 'wi-fi'): "
Set-NetConnectionProfile -InterfaceAlias $interfaceAlias -NetworkCategory Private

# Configurar la máquina de control de Ansible
$ipUbuntuControl = Read-Host "Ingresa la dirección IP de la máquina de control de Ansible: "
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "$ipUbuntuControl" -Force

# Crear certificado SSL
$hostName = Read-Host "Ingresa el nombre del host Windows: "
$cert = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation cert:\LocalMachine\My
$certThumbprint = $cert.Thumbprint
Write-Host "Se ha creado el certificado SSL correctamente."
Write-Host "Huella del certificado SSL: $certThumbprint"

# Ejecutar bloque problemático con CMD
$cmdScript = @'
@echo off
echo Eliminando agente de escucha existente...
powershell -Command "Remove-Item -Path WSMan:\localhost\Listener\Listener_443 -Recurse -Force"
echo Agente de escucha eliminado correctamente.
echo Creando nuevo agente de escucha...
powershell -Command "New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $certThumbprint -Force"
echo Nuevo agente de escucha creado correctamente.
'@

$cmdScriptPath = "cmdScript.cmd"
$cmdScript | Out-File -FilePath $cmdScriptPath -Encoding ASCII

Start-Process -Wait -FilePath "cmd.exe" -ArgumentList "/C", $cmdScriptPath

# Permitir tráfico en el puerto 5986 en el Firewall de Windows
Write-Host "`nConfigurando el Firewall de Windows..."
$ruleName = "Allow WinRM HTTPS"
$existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if ($existingRule -eq $null) {
    try {
        New-NetFirewallRule -DisplayName $ruleName -Name "WinRM-HTTPS-In-TCP" -Protocol TCP -LocalPort 5986 -Action Allow
        Write-Host "Se ha creado la regla del Firewall correctamente."
    } catch {
        Write-Host "Error al crear la regla del Firewall: $_"
    }
} else {
    Write-Host "La regla del Firewall ya existe. No se ha creado una nueva regla."
}

Write-Host "`n¡La configuración de WinRM se ha completado correctamente!"
