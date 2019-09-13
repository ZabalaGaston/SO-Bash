# Trabajo práctico N1 Ejercicio 6
# Script: Ejercicio6.sh
# Integrantes:
# Zabala, Gaston        34614948
# Pessolani, Agustin	  39670584
# Cela, Pablo           36166867
# Sullca, Fernando      37841788
# Cabral, David         39757782
##################################
base_path=$(pwd)
base_path=$(realpath "$1")

declare -a files=()
declare -a count=()
declare -a sizes=()

leerDirectorio () {
  dirs=`find "$1" -type d`
  for dir in $dirs ; do
    dirs_count=$((`(find "$dir" -type d | wc -l)` -1))
    if [ $dirs_count == 0 ] ; then
      count=`find "$dir" -maxdepth 1 -type f | wc -l`
      size=`find "$dir" -maxdepth 1 -type f | wc -c`
      agregarDirectorio "$dir" $count $size
    fi
  done
}

reemplazarVectores () {
  menor=${sizes[0]}
  new_index=0

  for i in {1..9} ; do
    if [[ ${sizes[$i]} -lt $menor ]]; then
      menor=${sizes[$i]}
      new_index=$i
    fi
  done

  if [[ $3 -gt $menor ]] ; then
    files[$new_index]=$1
    counts[$new_index]=$2
    sizes[$new_index]=$3
  fi
}

agregarDirectorio () {
  if [[ ${#files[@]} == 10 ]]; then
    reemplazarVectores $1 $2 $3
  else
    files[$index]=$1
    counts[$index]=$2
    sizes[$index]=$3
    ((index++))
  fi
}

ayuda () {
  echo "Uso: ./Ejercicio6.sh directorio_a_recorrer"
  echo "Programa informa: "
  echo "Una lista con los 10 subdirectorios con mayor peso."
  echo -e " Parametros"
  echo -e "   directorio_a_recorrer: directorio donde se buscan los subdirectorios"
  exit
}

errorParametros () {
  echo "Parametro Incorrecto: Utilizar Ejercicio6.sh -h"
  exit
}

validarDirectorio () {
  path=$1
  if ! test -d $path ; then
    echo "Directorio no encontrado."
    exit
  fi
}

validarParametros () {
  if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]; then
    ayuda
  fi

  if test $# -gt 1 ; then
    errorParametros
  fi

  validarDirectorio $1
}

########## MAIN ##########
validarParametros $1
leerDirectorio $base_path

for i in {0..9} ; do
  if [ ${files[$i]} ]; then
    echo "${files[$i]} | ${sizes[$i]} B | ${counts[$i]} files"
  fi
done
