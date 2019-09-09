# Trabajo práctico N1 Ejercicio 6
# Script: Ejercicio6.sh
# Integrantes:
# Zabala, Gaston        34614948
# Pessolani, Agustin	  39670584
# Cela, Pablo           36166867
# Sullca, Fernando      XXXXXXXX
# yyyyyy, David         XXXXXXXX
# Funciones
base_path=$(pwd)
base_path=$(realpath "$1")

declare -a files=()
declare -a counts=()
declare -a sizes=()
index=0
new_index=0

ayuda () {
  echo "Uso: ./Ejercicio6.sh directorio_a_recorrer"
  echo "Programa que informa: "
	echo "Una lista con los 10 subdirectorios mas largos y con mayor peso contenido en el directorio ingresado."
  echo "Cantidad de líneas de comentarios"
  echo -e "   Parametros"
	echo -e "   directorio_a_recorrer: directorio donde se buscan los subdirectorios"
	exit
}

ErrorParametros () {
	echo "Parametro Incorrecto: Utilizar Ejercicio6.sh -h"
}

validarDirectorio () {
	path=$1

	if ! test -d $path ; then
		echo "Directorio ono encontrado."
		exit
	fi
}

validarParametros () {
	if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ] ; then
		ayuda
		exit
	fi

  if test $# -ne 1 ; then
    ErrorParametros
    exit
  fi

	validarDirectorio $1
}

leerDirectorio () {
  dirs=`find "$1" -type d`
  for dir in $dirs; do
    dirs_count=$((`(find "$dir" -type d | wc -l)`-1))
    if [ $dirs_count == 0 ]; then
      count=`find "$dir" -maxdepth 1 -type f | wc -l`
      size=`find "$dir" -maxdepth 1 -type f | wc -c`
      agregarDirectorio "$dir" $count $size
    fi
  done
}

buscarMenor () {

}

agregarDirectorio {
  if [ ${#files[@]} == 10 ] && buscarMenor ; then
		files[$new_index]=$1
		counts[$new_index]=$2
		sizes[$new_index]=$3
  else
    files[$index]=$1
    counts[$index]=$2
    sizes[$index]=$3
    ((index++))
  fi
}

########## Main ##########
validarParametros
leerDirectorio $base_path

for i in {0..9}; do
  if [ ${files[$i]} ]; then
    echo "${files[$i]} | ${sizes[$i]} B | ${counts[$i]} files"
  fi
done
