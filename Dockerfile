# Usa una imagen oficial de Node.js ligera
FROM node:14-alpine

# Define el directorio de trabajo en el contenedor
WORKDIR /app

# Copia los archivos de configuración y instala dependencias
COPY package*.json ./
RUN npm install

# Copia el resto del código
COPY . .

# Expone el puerto en el que corre la aplicación (3000 en este caso)
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "index.js"]
