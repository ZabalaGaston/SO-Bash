#!/bin/bash

get_help(){
    echo "Ejercicio 3"
    echo "Ayuda: "
    echo "start: Inicia la ejecución del demonio, debe solicitar por parámetro el directorio a salvar, el directorio donde guardar el backup y el intervalo de tiempo entre backups (expresado en segundos). -start /home/usuario(origen) /home/usuario(destino) 100(intervalo)"
    echo "stop: Finalizar el demonio. Ejm -stop"
    echo "count: Indica la cantidad de archivos de backup hay en el directorio. Param: -count"
    echo "clear: Limpia el directorio de backup, recibe por parámetro la cantidad de backup que mantiene en la carpeta, siendo estos los últimos generados. Si no se recibe ningún parámetro se toma el valor cero. Ejm -clear 10(Opcional)"
    echo "play: El demonio crea el backup, en ese instante. Ejm: -play"
}

comenzar(){
    
    SRCDIR=$1
    DESTDIR=$2
    INTERVAL=$3
    FILENAME=bkp-$(date +%-Y%-m%-d)-$(date +%-T).tgz

    salida()
    {
        rm /tmp/DESTDIR.txt
        rm /tmp/SRCDIR.txt
        exit 0
    }
    ##################
    iteracion()
    {
        #tar --create --gzip --file=$DESTDIR$FILENAME $SRCDIR
        tar -czvf $DESTDIR"/"$FILENAME $SRCDIR 2> /dev/null > /dev/null
        #ejecutamos sleep en un fork de este programa
        sleep $INTERVAL &
        # En bash, $! significa el pid del último proceso lanzado
        SLEEP_PID=$!
        # Esperamos a que el último proceso lanzado acabe.
        # Wait en bash sí que admite señales asíncronas.
        wait $SLEEP_PID
        
    }
    ##################
    trap salida SIGTERM SIGKILL

    echo $DESTDIR > /tmp/DESTDIR.txt
    echo $SRCDIR > /tmp/SRCDIR.txt

    while true
    do
        # hacer lo que sea
        #echo "iteracion"
        # esperar
        iteracion
    done
}

ES_NUMERO='^-?[0-9]+([.][0-9]+)?$'

#Mostra ayuda
if [ $1 == -h ] || [ $1 == -help ] || [ $1 == -? ]; then
    get_help
    exit 0
fi;

#Creacion del servicio de Bkp
if [ $# == 4 ] && [ $1 == -start ] && [ -d $2 ] && [ -d $3 ] && [[ $4 =~ $ES_NUMERO ]]; then
    VAL_PROCESS=""
    VAL_PROCESS=$(ps -e | grep Ejercicio3.sh)
    echo "-"$VAL_PROCESS"-"
    if [[ ! -z VAL_PROCESS ]]; then
        echo "Comienza el bkp"
        echo "Directorio de bkp: "$3
        comenzar $2 $3 $4 &
        exit 0
    else
        echo "Ya existe un servicio de backup en ejecucion. Finalice el existente y vuelva a intentar."
        exit 0
    fi;
elif [ $# == 1 ] && [ $1 == -stop ]; then
    #Validar si existe el servicio en ejecucion
    PROCESS=`ps -e | grep Ejercicio3.sh`
    if [ PROCESS ]; then
        #Elimino archivos temporales
        rm /tmp/DESTDIR.txt
        rm /tmp/SRCDIR.txt
        #Kill Service
        killall -9 Ejercicio3.sh 2> /dev/null > /dev/null
        echo "BKP Service eliminado."
        exit 0
    else
        echo "No hay un servicio en ejecucion."
        exit 0
    fi;
elif [ $# == 1 ] && [ $1 == -play ]; then
    #Validar si existe el servicio en ejecucion
    PROCESS=`ps -e | grep Ejercicio3.sh`
    if [ PROCESS ]; then
        #Variables necesarias para realizar el bkp
        DESTDIR=`cat /tmp/DESTDIR.txt`
        SRCDIR=`cat /tmp/SRCDIR.txt`
        FILENAME=bkp-$(date +%-Y%-m%-d)-$(date +%-T).tgz
        tar -czvf $DESTDIR"/"$FILENAME $SRCDIR 2> /dev/null > /dev/null
        echo "Backup creado."
        exit 0
    else
        echo "No hay un servicio en ejecucion."
        exit 0
    fi;
elif [ $# == 1 ] && [ $1 == -count ]; then
        #Cantidad de bkp en el directorio asignado
        echo "Cantidad de archivos en el directorio: "
        cat DESTDIR.txt | ls | grep .tgz | wc -l
        exit 0
elif [ $# == 2 ] && [ $1 == -clear ]; then
    #Validar parametro de cantidad a mantener
    if [ $2 == "" ]; then
        CANT_BKP=0
    elif [ $2 =~ $ES_NUMERO ]; then
        CANT_BKP=$2
    else
        echo "No se validaron los parametros."
        exit 0;
    fi;
else
    echo "No se validaron los parametros."
    exit 0;
fi;
