# Script para renombrar en orden secuencial las fotos contenidas en un directorio
# En concreto, se renombra el interior de los parentesis
# Recibe como parametro la extension de las fotos y el path donde se encuentran

import os, sys, glob, re

#-------------------------------------------------------
# Obtengo los numeros que van separados por espacios
def get_number(file):	
	temp = file.split(" ")[1]  # El segundo campo contiene el numero
	number = temp.split(".")[0]  # Separamos para quitar la extension
	return number
	
#-------------------------------------------------------
# Relleno el numero con ceros al principio
def add_leading_zeros(number,digits):
	parsed_number = number.zfill(digits)
	return parsed_number
#-------------------------------------------------------
# Ordeno inversamente la lista de numeros de las fotos y devuelvo la cabeza
def get_max_number(matches):
	numbers = []
	for picture in matches:
		number = get_number(picture)
		numbers.append(int(number))

	numbers.sort(reverse=True)	
	return numbers[0]
#-------------------------------------------------------
# Obtengo el ultimo campo separando el path por /
def get_files_name(files):
    # Detectamos el SO '/' para UNIX y '\\' para Windows    
	if "win" in sys.platform:
		delimiter = "\\"
	else:
		delimiter = "/"		
	
	temp = []
	for i in range(len(files)):
		temp.append(files[i].split(delimiter)[-1])
	return temp
#-------------------------------------------------------

arguments = sys.argv
if len(arguments)!=3:
    print "Numero de parametros incorrecto.\nUso: rename.py <extension> <directorio>"
else:
	extension = "." + arguments[1]
	path = arguments[2] + "/"
	contador = 0

	os.chdir(path)
	matches = glob.glob(path+"*"+extension)	
	if not matches:
		print "No hay archivos con extension " + extension
	else:
		pictures = get_files_name(matches)
		pictures.sort() # Ordeno para que visualmente se vea mas claro que se renombra
		max_number = get_max_number(pictures)
		digits = len(str(max_number))

		for picture in pictures:
			number = get_number(picture)
			if (len(number)==digits):
				print picture + " ya esta en el formato correcto. Omitiendo ..."
			else:				
				new_number = add_leading_zeros(number,digits)				
				new_picture = picture.replace(" "+number," "+new_number)
				os.rename(picture,new_picture)
				print "Renombrando " + picture + " --> " + new_picture
				contador+=1

		print "Proceso finalizado. Se han realizado " + str(contador) + " cambios."
