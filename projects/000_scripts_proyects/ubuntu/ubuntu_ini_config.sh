#!/bin/bash

# Actualizar la lista de paquetes
sudo apt update

# Actualizar sistema
sudo apt dist-upgrade -y

# Instalar el paquete net-tools
sudo apt install net-tools -y

# Instalar el paquete ssh
sudo apt install ssh -y

# Instalar Python
apt install -y python-is-python3