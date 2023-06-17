#!/bin/bash

# Crear el usuario ansible
useradd -m ansible

# Establecer una contraseña para el usuario ansible
passwd ansible

# Agregar el usuario ansible al grupo "sudo"
adduser ansible sudo

# Ocultar usuario ansible en el gdm
echo "HideUsers=ansible" | sudo tee -a /etc/gdm3/custom.conf


