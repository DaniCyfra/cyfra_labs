# Comprobar si el script se está ejecutando con privilegios de administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script necesita privilegios de administrador. Ejecute PowerShell como administrador y vuelva a intentarlo."
    Exit
}

# Definir los detalles del usuario
$usuario = "ansible"
$pass = Read-Host -AsSecureString "Ingrese la password"

# Crear el nuevo usuario
$crearUsuario = New-LocalUser -Name $usuario -Password $pass -PasswordNeverExpires:$true -UserMayNotChangePassword:$true -AccountNeverExpires:$true -Description "Usuario para fines administrativos"

# Asignar privilegios de administrador al usuario
$grupoAdministradores = Get-LocalGroup -Name "Administradores"
$grupoAdministradores | Add-LocalGroupMember -Member $usuario

if ($crearUsuario) {
    Write-Host "El usuario $usuario se ha creado con exito y se ha agregado al grupo de administradores."
} else {
    Write-Host "Se produjo un error al crear el usuario."
}

# Instalar Python en el host Windows
Write-Host "Instalando Python en el host Windows..."
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe" -OutFile "python-installer.exe"
Start-Process -Wait -FilePath "python-installer.exe"
Write-Host "Python se ha instalado correctamente."

# Configurar la máquina de control de Ansible
$ipUbuntuControl = Read-Host "Ingresa la direccion IP de la maquina de control de Ansible: "
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "$ipUbuntuControl" -Force

# Solicitar la ruta del certificado SSL
#$rutaCertificadoSSL = Read-Host "Ingresa la ruta del certificado SSL: "

# Ejecutar bloque problemático con CMD
#$cmdScript = @"
#@echo off
#echo Eliminando agente de escucha existente...
#powershell -Command "Remove-Item -Path WSMan:\localhost\Listener\Listener_443 -Recurse -Force"
#echo Agente de escucha eliminado correctamente.
#echo Creando nuevo agente de escucha...
#powershell -Command "New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -Thumbprint $(Get-PfxCertificate -FilePath '$rutaCertificadoSSL').Thumbprint -Force"
#echo Nuevo agente de escucha creado correctamente.
#"@

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
