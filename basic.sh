#!/bin/bash

echo "Atualizando o sistema!"
yum update -y && yum upgrde -y

echo "Alterando a porta do SSH"
sed -i 's,# Port 22,Port 6022,g' /etc/ssh/sshd_config

echo "Instalando dependências"
yum install policycoreutils-python

echo "Adicionando liberação"
semanage port -a -t ssh_port_t -p tcp 6022
firewall-cmd --permanent --zone=public --add-port=6022/tcp

echo "Reiniciando o firewall"
firewall-cmd --reload

echo "Reiniciando o SSH"
systemctl restart sshd

echo "Instalando e configurando o FAIL2BAN"
yum install epel-release -y
yum install fail2ban fail2ban-systemd -y

yum update -y selinux-policy*

cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

wget -c https://github.com/DaniloEvalt/ShellScript/blob/master/jail.local >> /etc/fail2ban/jail.local

wget -c https://github.com/DaniloEvalt/ShellScript/blob/master/sshd.local >> /etc/fail2ban/jail.d/sshd.local

systemctl enable firewalld
systemctl start firewalld

systemctl enable fail2ban
systemctl start fail2ban 


echo "Desabilitando o login ssh do usuário ROOT"
sed -i 's,PermitRootLogin yes,PermitRootLogin no,g' /etc/ssh/sshd_config
systemctl reload sshd

echo "Configurando o NTP"
timedatectl set-timezone America/Sao_Paulo
yum install ntp -y
systemctl start ntpd
systemctl enable ntpd
