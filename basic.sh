#!/bin/bash

echo "Atualizando o sistema!"
yum update -y && yum upgrde -y

echo "Alterando a porta do SSH"
echo "Port 6022" >> /etc/ssh/sshd_config

echo "Instalando dependências"
yum install policycoreutils-python

echo "Adicionando liberação"
semanage port -a -t ssh_port_t -p tcp 6022
firewall-cmd --permanent --zone=public --add-port=6022/tcp

echo "Reiniciando o firewall"
firewall-cmd --reload

echo "Reiniciando o SSH"
systemctl restart sshd

echo "Instalando FAIL2BAN!"
yum install fail2ban fail2ban-systemd -y

yum update -y selinux-policy*

cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

***Adicionar comando que baixa a configuração do GIT

***Adicionar comando que baixa a jail ssh do GIT

systemctl enable firewalld
systemctl start firewalld

systemctl enable fail2ban
systemctl start fail2ban 
