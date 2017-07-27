#!/bin/bash
if [ $(id -u) -ne 0 ];
then
echo "Voce precisa de permissao de root para executar este script"
exit
fi
echo -en "\tAtualizando os repositorios ... [    ]" 
apt update 1> /dev/null 2> /dev/stdout
echo -e  "\b\b\b\bOK"
echo -en "\tAtualizando os pacotes ........ [    ]"
apt upgrade -y 1> /dev/null 2> /dev/stdout
echo -e "\b\b\b\bOK"
echo -en "\tremovendo pacotes obsoletos ... [    ]"
apt autoremove -y 1> /dev/null 2> /dev/stdout
echo -e "\b\b\b\bOK"


