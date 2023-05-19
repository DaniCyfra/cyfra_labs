#!/bin/bash

# Actualizar la caché de apt
sudo apt update

# Instalar ufw
sudo apt install -y ufw

# Configurar ufw para permitir SSH
sudo ufw allow 22

# Configurar ufw para permitir HTTP
sudo ufw allow http

# Configurar ufw para permitir HTTPS
sudo ufw allow https

# Configurar ufw para permitir DNS
sudo ufw allow 53

# Habilitar ufw
sudo ufw enable
