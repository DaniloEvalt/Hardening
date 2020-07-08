#!/bin/bash

echo "Atualizando o sistema!"
yum update -y && yum upgrde -y

echo "Instalando dependências"
yum install policycoreutils-python epel-release fail2ban fail2ban-systemd -y
yum update -y selinux-policy*

systemctl enable firewalld
systemctl start firewalld

systemctl enable fail2ban
systemctl start fail2ban 


cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

wget -c https://raw.githubusercontent.com/DaniloEvalt/ShellScript/blob/master/jail.local >> /etc/fail2ban/jail.local

wget -c https://raw.githubusercontent.com/DaniloEvalt/ShellScript/blob/master/sshd.local >> /etc/fail2ban/jail.d/sshd.local

echo "Alterando a porta do SSH"
sed -i 's,# Port 22,Port 6022,g' /etc/ssh/sshd_config

echo "Adicionando liberação"
semanage port -a -t ssh_port_t -p tcp 6022
firewall-cmd --permanent --zone=public --add-port=6022/tcp

echo "Reiniciando o firewall"
firewall-cmd --reload

echo "Reiniciando o SSH"
systemctl restart sshd

echo "Desabilitando o login ssh do usuário ROOT"
sed -i 's,# PermitRootLogin yes,PermitRootLogin no,g' /etc/ssh/sshd_config
systemctl reload sshd

echo "Configurando o NTP"
timedatectl set-timezone America/Sao_Paulo
yum install ntp -y
systemctl start ntpd
systemctl enable ntpd
