import os, sys, glob
arguments = sys.argv

if len(arguments)!=3:
    print 'Numero de parametros incorrecto.\nUso: renameByDate.py <numero> <path>'
else:    
    number = arguments[1]
    path = arguments[2] + '/'
    # Obtengo los ficheros del directorio 'path' ordenados por fecha de modificacion
    files = glob.glob(path+'*')
    files.sort(key=os.path.getmtime)   
    # Numero de ceros para rellenar a partir del numero de archivos en el directorio
    digits = len(str(len(files)))    
    count = 1

    for file in files:               
        _, extension = os.path.splitext(file)
        # Creo el string del contador rellenado con tantos ceros como digitos
        numStr = str(count)
        numStr = numStr.zfill(digits)
        newName = '%s(%s)%s' % (number,numStr,extension)
        filePath = path + newName
        os.rename(file,filePath)
        print 'Renombrando %s --> %s' % (file,filePath)        
        count += 1