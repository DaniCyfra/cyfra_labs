#!/bin/bash

# Crear el usuario "ansible"
sudo dscl . -create /Users/ansible
sudo dscl . -create /Users/ansible UserShell /bin/bash
sudo dscl . -create /Users/ansible RealName "Ansible User"
sudo dscl . -create /Users/ansible UniqueID 501
sudo dscl . -create /Users/ansible PrimaryGroupID 20
sudo dscl . -create /Users/ansible NFSHomeDirectory /Users/ansible
sudo dscl . -passwd /Users/ansible

# Crear directorio .ssh
sudo mkdir /Users/ansible/.ssh

# Solicitar clave pública
echo "Ingrese la clave pública para el usuario ansible:"
read public_key

# Agregar clave pública
echo "$public_key" | sudo tee -a /Users/ansible/.ssh/authorized_keys >/dev/null

# Establecer permisos
sudo chown -R ansible:staff /Users/ansible/.ssh
sudo chmod 700 /Users/ansible/.ssh
sudo chmod 600 /Users/ansible/.ssh/authorized_keys
