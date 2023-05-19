#!/bin/bash

# Crear el usuario ansible
useradd -m ansible

# Establecer una contraseña para el usuario ansible
passwd ansible

# Agregar el usuario ansible al archivo sudoers
echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Agregar el usuario ansible al grupo "sudo"
usermod -aG sudo ansible
