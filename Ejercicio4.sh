#   ______________
#   ______________
#   _____//.......
#   ______________
#   //............
#   _____/*.......
#   ............*/
#   /*..........*/
#   /*............
#   ............*/
#   /*............
#   ....*/________
#   _____/*.......
#   ....*/________


# Trabajo práctico N1 Ejercicio 4 
# Script: Ejercicio4.sh
# Integrantes:
# Zabala, Gaston        34614948
# Pessolani, Agustin	39670584
# Cela, Pablo           XXXXXXXX
# Sullca, Fernando      XXXXXXXX
# yyyyyy, David         XXXXXXXX


#Agregamos para que los directorios funcionen con espacios
function func_ConfiguracionDirectorio
{
	IFS=$'\n'
}

# Funciones
function ayuda(){
	echo ""
  echo "Uso: ./Ejercicio2.sh directorio_recorrer extension"
  echo "Programa que informa: "
  echo "Cantidad de archivos analizados."
  echo "Cantidad de líneas de código totales, como su porcentaje contra el total de líneas de los archivos analizados."
  echo "Cantidad de líneas de comentarios"
  echo -e "   Parametros"
	echo -e "   \directorio_recorrer : directorio donde se buscan los archivos"
	echo -e "   extension: extension de los archivos a analizar "
	exit
}

function func_MostrarMensajeErrorParametros
{
	echo "Parametro Incorrecto: Utilizar Ejercicio2.sh -h para verificar funcionamiento del comando"
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
    echo "entro aca!"
		ayuda
		exit
	fi
	
    if test $# -gt 2 ; then
        func_MostrarMensajeErrorParametros  
        exit 
    fi

	func_ValidarDirectorio $1
}

function obtenerCantLineas(){
  _aux=`wc -l $j`
  _cantLineasV=(${_aux// / })
  cantLineas=`expr ${_cantLineasV[0]} + $cantLineas`
}

function obtenerCantLineasComentadas(){
  _AuxcantLineasComentadas=$(awk 'BEGIN{cant=0}{
     if($0 ~ "//")
       cant=100;
    }
    END{
     print cant;
    }' $j)
}

function obtenerCantLineasCodigo(){
  _AuxcantLineasCodigo=$(awk 'BEGIN{cant=0}{
       cant=2;
    }
    END{
     print cant;
    }' $j)
}

function acumularCantLineasComentadas(){
  acumCantLineasComentadas=`expr $acumCantLineasComentadas + $_AuxcantLineasComentadas`
  }

function acumularCantLineasCodigo(){
  acumCantLineasCodigo=`expr $acumCantLineasCodigo + $_AuxcantLineasCodigo`
  }

#func_ConfiguracionDirectorio()

func_validarParametros $1

aBuscar='.txt'
path='.'
cantLineas=0
cantArchivos=0
acumCantLineasComentadas=0
acumCantLineasCodigo=0

for j in `find $path -name "*$aBuscar"`
do
  _AuxcantLineasComentadas=0
  _AuxcantLineasCodigo=0
  cantArchivos=`expr $cantArchivos + 1`
  obtenerCantLineas $j
  obtenerCantLineasComentadas
  acumularCantLineasComentadas

  obtenerCantLineasCodigo
  acumularCantLineasCodigo
done

echo "Cantidad de lineas: "$cantLineas
echo "Cantidad de archivos: "$cantArchivos
echo "Cantidad líneas comentadas: "$acumCantLineasComentadas
echo "Cantidad líneas Codigo: "$acumCantLineasCodigo