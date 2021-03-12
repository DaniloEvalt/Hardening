#!/usr/bin/python3

import os
import ipaddress
opcao = 0
portaSSH = 0
ipEmpresa = (0)
liberaIP = 0

while liberaIP == 0:
    print('Qual o ip da empresa?')
    ipEmpresa = input('IP Roteável e FIXO\n') 
    liberaIP = ipaddress.ip_address(ipEmpresa).is_global

    if liberaIP == 1:
        print("IP Válido\n")
    else:
        print("IP Inválido\n")

while portaSSH > 65535 or portaSSH < 1:
    print('Qual a porta SSH?')
    portaSSH = int(input('Número inteiro de 1 a 65535\n'))

while opcao != 9:
    print("""Bem vindo(a)!
    IP Informado -> """,ipEmpresa,"""
    Porta SSH Informada -> """,portaSSH,"""
    Selecione uma opção no menu abaixo.
    1 - Permitir IP Life
    2 - Bloquear outros IPs
    3 - Modificar porta SSH
    4 - Rotacionar Logs
    7 - Alterar IP
    8 - Alterar Porta SSH
    9 - Sair
    """)                
    opcao = int(input('>>>Qual a sua opção?<<<\n'))
    if opcao == 1:
       os.system("echo 'Permitindo IP'",ipEmpresa)
       os.system("iptables -A INPUT -s",ipEmpresa,"-p tcp -j ACCEPT")
       os.system("iptables -A INPUT -s",ipEmpresa,"-p udp -j ACCEPT")
       os.system("echo 'Alterando o arquivo hosts.allow'")
       os.system("echo 'sshd:",ipEmpresa," >> /etc/hosts.allow'")
    elif opcao == 2:
       os.system("echo 'Dropando outros ip's via SSH' ")
       os.system("iptables -A INPUT -p tcp --dport",portaSSH,"-j DROP")
       os.system("echo 'Alterando o arquivo hosts.deny'")
       os.system("'echo sshd: ALL >> /etc/hosts.deny' ")
    elif opcao == 3:
       os.system("echo 'Alterando a porta SSH'")
       os.system("echo 'Port",portaSSH," >> /etc/ssh/sshd_config'")
       os.system("echo 'Reiniciando SSHD'")
       os.system("systemctl restart sshd")
    elif opcao == 4:
       os.system("echo 'Rotacionando LOGs'")
       os.system("logrotate --force --verbose /etc/logrotate.conf")
       os.system("echo 'Alterando a porta SSH'")
    elif opcao == 7:
       ipEmpresa = (0)
       liberaIP = 0
       while liberaIP == 0:
        print('Qual o ip da empresa?')
        ipEmpresa = input('IP Roteável e FIXO\n')
        liberaIP = ipaddress.ip_address(ipEmpresa).is_global
        if liberaIP == 1:
            print("IP Válido\n")
        else:
            print("IP Inválido\n") 
    elif opcao == 8:
       portaSSH = 0
       while portaSSH > 65535 or portaSSH < 1:
        print('Qual a porta SSH?')
        portaSSH = int(input('Número inteiro de 1 a 65535\n'))
    elif opcao == 9:
       print('Encerrando')
    else:
       print('Opção inválida')
print('=-=' * 10)
print('Até mais!')
