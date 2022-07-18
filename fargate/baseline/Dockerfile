FROM golang:1.8

# A partir de esta linea vamos a trabajr en este directorio
WORKDIR /app    

# de donde vamos a copiar archivos hacia la imagen del contenedorcopiate todos los archivos desde baseline hacia la imagen contenedor
# COPY ./baseline/* ./  
COPY . .

# EJECUTAMOS COMANDOS
RUN go build -o /usr/bin/application

EXPOSE 8080


# COMAND
ENTRYPOINT application
