#FALTA RECURSIVIDAD!!!

# mkdir carpeta1
# cd carpeta1
# touch "ejercicio     .txt"
# touch "ejercicio   .txt"
# cd ..
# chmod 777 Ejercicio2.sh
# ./Ejercicio2.sh ./carpeta1 -r


# Trabajo práctico N1 Ejercicio 2 
# Script: Ejercicio2.sh
# Integrantes:
# Zabala, Gaston        34614948
# Pessolani, Agustin	39670584
# Cela, Pablo           XXXXXXXX
# Sullca, Fernando      XXXXXXXX
# yyyyyy, David         XXXXXXXX

# Funciones
function ayuda(){
	echo ""
    echo "Uso: ./Ejercicio2.sh directorio_recorrer -r[Opcional]"
    echo "Reemplaza espacios en blanco por un guión bajo, en el nombre de los archivos"
    echo -e "   Parametros"
	echo -e "   \directorio_recorrer : directorio donde se buscan los archivos"
	echo -e "   -r [Opcional], permite recorrer el directorio recursivamente "
    exit
}

function func_MostrarMensajeErrorParametros
{
	echo "Parametro Incorrecto: Utilizar Ejercicio2.sh -h para verificar funcionamiento del comando"
}

function func_esRecursiva
{
	if [ $# == 2 ] && [ "$2" != "-r" ]
	then
			func_MostrarMensajeErrorParametros
			exit
	fi
}

function func_ValidarDirectorio
{
	path=$1
   
   	if ! test -e $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no existente"
		exit
	fi
	
	if ! test -d $path
	then
		echo "Parametro Incorrecto: Ruta ingresada no es directorio"
		exit
	fi	
}

function func_validarParametros
{
	if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]
	then
			ayuda
			exit
	fi
	
    if test $# -eq 0 || test $# -gt 2 ; then
        func_MostrarMensajeErrorParametros  
        exit 
    fi

	func_ValidarDirectorio $1
	func_esRecursiva $1 $2
}

#Agregamos para que los directorios funcionen con espacios
function func_ConfiguracionDirectorio
{
	IFS=$'\n'
}

############################################MAIN##########################################################

func_ConfiguracionDirectorio
func_validarParametros $1 $2

aBuscar=' '
aReemplazar='_'

for j in `find $1 -name "*$aBuscar*"`
do

 pathNuevo=$j;
 pathNuevo=$(echo $j | awk -F'/' 'BEGIN{
        ruta=""
        pos=0
        nombre=""
    }
    {
      split($NF,name," ")

      #Obtengo la cantidad de posiciones
      for (x in name){
        pos++
      }

      #recorro hasta la ante ultima posicion
      for (n=0;n<pos-1;n++){
        nombre=nombre name[n+1] "_"
      }

      #Le concateno la ultima parte
      nombre=nombre name[pos]

      #Rearmo la ruta
      for(i=1;i<NF;i++){
        ruta=ruta $i "/"
      }

print ruta""nombre}')
    add=0
    pAux=$pathNuevo
    while [ -f $pathNuevo ]
    do
        add=`expr $add + 1`
        pathNuevo=$pAux$add 
    done

    echo "Viejo: " $j
    echo "Nuevo: " $pathNuevo
    
    mv $j $pathNuevo
done

##################################################