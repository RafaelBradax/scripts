#!/bin/bash


# Verifica se o usuario e o ROOT pelo id

root_verify ()
{
	if [ $(id -u) -ne 0 ]
	then 
	echo "Voce precisa de permissão de rrot para executar esta tarefa"
	exit 0
	fi
}

# Funcao para mostrar um contador na tela
# Recebe 3 parametros
# 1 -> numero de repeticoes
# 2 -> tempo entre as repeticoes em segundos
# 3 -> caracter mostrado

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

# Funcao que executa a remocao dos kernels antigos
# PS.: NAO REMOVE O KERNEL ATUAL

exclude_old_kernels ()
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

# Lista os Kernels existentes no sistema

k_list ()
{
	echo "Listando os Kernels"
	timer 5 0.7 '.'
	dpkg-query -l | awk '/linux-image-*/ {print $2}'
	echo
	timer 5 0.7 '.'
}

main()
{ 
	root_verify
	k_list	
	exclude_old_kernels
}
main

