#!/bin/bash

# Crear el usuario ansible
useradd -m ansible

# Establecer una contraseña para el usuario ansible
passwd ansible

# Agregar el usuario ansible al grupo "sudo"
adduser ansible sudo

# Crear la carpeta .ssh y el archivo authorized_keys
mkdir /home/ansible/.ssh
touch /home/ansible/.ssh/authorized_keys

# Solicitar la clave pública al usuario
echo "Por favor, ingresa la clave pública para el archivo authorized_keys:"
read public_key

# Agregar la clave pública al archivo authorized_keys
echo "$public_key" >> /home/ansible/.ssh/authorized_keys

# Ajustar los permisos adecuados
chmod 700 /home/ansible/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh

# Ocultar usuario ansible en el gdm
echo "HideUsers=ansible" | sudo tee -a /etc/gdm3/custom.conf


