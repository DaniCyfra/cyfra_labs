#!/bin/bash

# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# Instalar paquetes necesarios
sudo apt install -y isc-dhcp-server apache2

# Configurar servidor DHCP
sudo sed -i 's/#INTERFACESv4=""/INTERFACESv4="enp0s3"/' /etc/default/isc-dhcp-server

# Descargar netboot.tar.gz desde internet
wget http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images/netboot/netboot.tar.gz

# Pedir ruta del archivo .iso montado
read -p "Introduce la ruta del archivo .iso montado en tu equipo: " iso_path

# Configurar servidor HTTP Apache
sudo mkdir /var/www/html/ubuntu
sudo cp -avr $iso_path /var/www/html/ubuntu

# Extraer netboot.tar.gz
tar -xzvf netboot.tar.gz

# Mover archivos a la ubicación correcta
sudo mv $iso_path /var/www/html/ubuntu

# Limpiar archivos descargados
rm netboot.tar.gz

echo "Proceso completado exitosamente."
