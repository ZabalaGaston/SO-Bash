# Trabajo práctico N1 Ejercicio 5
# Script: Ejercicio5.sh
# Integrantes:
# Cabral, David         39757782
# Cela, Pablo           36166867
# Pessolani, Agustin    39670584
# Sullca, Fernando      37841788
# Zabala, Gaston        34614948

# cd Documentos
# mkdir carpeta1
# mkdir carpeta2
# cd carpeta1
# touch "repetidocarpeta.txt"
# touch "Unitario.txt"
# touch "Unitario2.txt"
# cd ..
# cd carpeta2
# touch "repetidocarpeta.txt"
# touch "Unitario3.txt"
# touch "Unitario4.txt"
# cd ..
# touch "documento a repetir.txt"
# chmod 777 Ejercicio5.sh
#./Ejercicio5.sh 'documento a repetir'
# touch "documento a repetir"
#./Ejercicio5.sh 'documento a repetir'
#./Ejercicio5.sh -l
##Muestra los archivo en la paperera repetidos

# Funciones Sin paramentros
function ayuda(){
	echo "Uso: ./Ejercicio5.sh Archivo "
	echo "Eliminar un archivo con posibilidad de recuperacion.Simular comando 'rm' "
	echo -e "Parametros:"
	echo -e "  Archivo : directorio donde se eliminara el archivo Absoluto ,Parcial ,Archivo"
	echo -e "Opcionales:"
	echo -e "  -l ,listar los archivo en papelera "
	echo -e "  -r [archivo], permite recuperar el archivo pasado por parametro a su ubicacion origina"
	echo -e "  -e vaciar la papelera(Definitivo)"
	exit
}

function func_MostrarMensajeErrorParametros() {
 	echo "Parametro Incorrecto: Utilizar Ejercicio5.sh -h para verificar funcionamiento del comando"

}

#Agregamos para que los directorios funcionen con espacios
function func_ConfiguracionDirectorio()
{
	IFS=$'\n'
}

#Agregamos La papelera De reciclaje
function func_ConfigurarPapelera()
{ #echo "ConfigurarPapelera"
   	if ! test -d "/home/$USER/.Papelera"
	then
		#echo "Creando Papelera de reciclaje para el usuario $USER"
		mkdir "/home/$USER/.Papelera"
		#exit
	fi
}

#x -lt y			x menor que y
#x -le y			x menor o igual que y
#x -eq y			x igual que y
#x -ge y			x mayor o igual que y
#x -gt y			x mayor que y
#x -ne y			x no igual que y

function func_validarParametros
{
#echo "abriendo validarParametros"
#echo $#
   	if  test $# -gt 2  || test $# -lt 1 ; then
#echo "parametros mayor a 2 o igual a 0"
        func_MostrarMensajeErrorParametros
        exit
    	fi

	if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]
	then
#echo "ayuda"
		ayuda
		exit
	fi

	if [ "$1" == "-l" ] || [ "$1" == "-e" ] && test $# -eq 2 ;
	then
#echo "parametros -l o -e"
	func_MostrarMensajeErrorParametros
	exit
	fi


	if [ "$1" == "-r" ] && [ $# == 1 ] ;then
	#echo "parametros -r "
			func_MostrarMensajeErrorParametros
			exit
	fi
}

#-d fichero		fichero existe y es un directorio
#-e fichero		fichero existe
#-f fichero		fichero existe y es un fichero regular (no un

function func_ValidarDirectorio
{
	path=$1
	#echo "Directorio $path"

	if ! test -f $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no es fichero"
		exit
	fi

}


function func_eliminarArchivo
{
  path=$1
	func_ValidarDirectorio $path
 # echo "Eliminando Archivo..."
 	_nombreArchivo=${path##*/}
 # echo "Nombre de archivo $_nombreArchivo"
  	_dirAbs=$( readlink -f $path)
 # echo "Direccion absoluta $_dirAbs"
 	_dirOrigen=${_dirAbs%/*}
 # echo "Direccion recortada $_dirOrigen"

		# Valido que el archivo no exista
		# Si existe, le agrego un numero al nombre del archivo, antes de la extension (si tiene),
		# o al final del archivo
		Contador=0
		NombreNuevo=$_nombreArchivo
		pAux=$_nombreArchivo
		while [ -f  "/home/$USER/.Papelera/$NombreNuevo"  ]
		do
			Contador=`expr $Contador + 1`

			_arch=${pAux##*/}

			if [[ $_arch =~ "." ]]
				then
				_sinExt=${_arch%%.*}
				_ext="."${_arch##*.}
				_dirOk=$_sinExt""$Contador""$_ext
			else
				_dirOk=$_arch""$Contador
			fi
			NombreNuevo=$_dirOk

	#control de cambios por cada archivo
		done
		if [ "$_nombreArchivo" != "$NombreNuevo" ]
		then
	#	echo "cambiando nombre  $_nombreArchivo Nuevo: " $NombreNuevo
	#Cambio  el nombre del archivo
		mv $_dirOrigen"/"$_nombreArchivo  $_dirOrigen"/"$NombreNuevo
		fi

	#control de cambios por cada archivo resultante

	#echo "Moviendo a la papelera..."
	_dirNueva=$_dirOrigen"/"$NombreNuevo
	#echo $_dirNueva
	touch "/home/$USER/.Papelera/.$NombreNuevo.trashinfo"
	readlink -f $_dirNueva >> "/home/$USER/.Papelera/.$NombreNuevo.trashinfo"
	mv $_dirNueva "/home/$USER/.Papelera"
}

########################MAIN######################################
func_validarParametros $1 $2
func_ConfiguracionDirectorio
func_ConfigurarPapelera
path=$1

#1 parametro: rm(archivo) 'archivo a elimnar'

if  [ "$1" == "-l" ]
 then
	#echo "listar archivos archivo -> /home/$USER/papelera"
	ls "/home/$USER/.Papelera/"
	exit
	fi

if  [ "$1" == "-e" ]
 then
	#echo "vaciar papelera -> /home/$USER/papelera"
	cd "/home/$USER/.Papelera"
	rm -f *
	rm -f .*.trashinfo
	exit
	fi


if [ "$1" != "-r" ]
then
 	func_eliminarArchivo $1
exit 1
fi

if [ $1 == "-r" ]
then
	path=$2
	cd "/home/$USER/.Papelera"
	anterior=$2
	#Busca el archivo
	if find  $path
	then
	#	echo "Archivo encontrado"
	pathOrigen=".$2.trashinfo"
	read -r FIRSTLINE < $pathOrigen
	#	echo $FIRSTLINE
	_dir=${FIRSTLINE%/*}
	#	echo  "Carpeta Destino: " $_dir
 	mv $path $_dir
	rm $pathOrigen
	else
	 echo "Archivo NO encontrado"
	fi
fi

exit 1
################################################################
