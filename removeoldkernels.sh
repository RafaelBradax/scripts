#!/bin/bash

verifica_root ()
{
	if [ $(id -u) -ne 0 ]
	then 
	echo "Voce precisa de permissão de rrot para executar esta tarefa"
	exit 0
	fi
}

timer ()
{ 
	for i in $(seq 1 1 $1)
	do
		echo -n $3
		sleep $2
	done
	for i in $(seq 1 1 $1)
	do
		echo -ne "\b"
	done
}

excluir_old_kernels ()
{
	
	echo -e "Deseja excluir os kernels antigos encontrados ( S|N )?"
	read -n1 option
	case $option in
		S|s) echo
			echo "Localizar os kernels antigos .... [ OK ]"
			echo -ne "Excluir os kernels antigos ...... [    ]"	
			dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge 1> /dev/null 2> /dev/stdout
			echo -e "\b\b\b\bOK"
			echo -ne "Atualizar o GRUB ................ [    ]"
			update-grub 1> /dev/null 2> /dev/stdout
			echo -e "\b\b\b\bOK"
			echo "Kernels antigos excluidos com sucesso!"
			;;
		N|n) echo
			echo -n "Saindo "
			timer 5 0.7 '.'
			exit;;	
		*) echo
			echo "Erro -> Opcao invalida"
			echo -n "Saindo "
			timer 5 0.7 '.'
			echo
			exit;;
	esac
}

listar_old_kernels ()
{
	echo "Listando os Kernels"
	timer 5 0.7 '.'
	dpkg-query -l | awk '/linux-image-*/ {print $2}'
	echo
	timer 5 0.7 '.'
}

main()
{ 
	verifica_root
	listar_old_kernels
	excluir_old_kernels
}
main

