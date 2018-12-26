#!/bin/bash

# Script para renombrar en orden secuencial las fotos contenidas en un directorio
# En concreto, se renombra el interior de los paréntesis
# Recibe como parámetro la extensión de las fotos

EXT=$1
DIR=$2
contador=0

if [ -z "$EXT" ]
	then
		echo Introduzca la extensión de las imágenes
	else 

cd $DIR

matches=$(ls | grep .*$EXT | wc -l)
if [ $matches -eq 0 ]
	then
		echo No hay archivos con extensión .$EXT
	else

MAX=$(ls | grep -oP '\(\K[^\)]+' | sort -nr | head -1) 
shopt -s extglob
MAX=${MAX##+(0)}

CIFRAS=${#MAX}

for foto in *.$EXT
do
	number=$(echo $foto | grep -oP '\(\K[^\)]+')

	if [ "${#number}" -eq "$CIFRAS" ]
		then 
			echo $foto ya está en el formato correcto. Omitiendo ...
		else

	shopt -s extglob
	parsed_number=${number##+(0)}	# Contiene el numero sin ningun 0 delante

	new=$(printf "(%0${CIFRAS}d)" "$parsed_number") 
	nueva_foto="${foto/($number)/$new}"
	mv -i -- "$foto" "$nueva_foto"

	echo Renombrando $foto a $nueva_foto ...
	let contador++

	fi
done

echo Proceso finalizado. Se han realizado $contador cambios.

fi
fi