# Usa una imagen oficial de Node.js ligera como base
FROM node:14-alpine

# Instalar dependencias necesarias para Jenkins
RUN apk update && apk add --no-cache \
    openjdk11-jre bash curl \
    && rm -rf /var/cache/apk/*

# Instalar Jenkins y configurar
RUN curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee \
    /etc/apt/trusted.gpg.d/jenkins.asc
RUN echo "deb http://pkg.jenkins.io/debian/jenkins.io/ stable main" | tee \
    /etc/apt/sources.list.d/jenkins.list
RUN apk add --no-cache \
    openjdk11-jre bash curl \
    && curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee \
    /etc/apt/trusted.gpg.d/jenkins.asc \
    && curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee /etc/apt/keyrings/jenkins.asc
RUN apk add --no-cache \
    openjdk11-jre bash curl \
    && rm -rf /var/cache/apk/*

# Agregar el certificado al contenedor (si es necesario)
COPY eks-ca.crt /tmp/eks-ca.crt
RUN keytool -import -trustcacerts -keystore /opt/java/openjdk/lib/security/cacerts -storepass changeit -noprompt -alias eks-ca -file /tmp/eks-ca.crt

# Crear el directorio de trabajo
WORKDIR /app

# Copiar los archivos de la aplicación Node.js
COPY package*.json ./
RUN npm install

# Copiar el resto del código
COPY . .

# Exponer el puerto de la aplicación Node.js
EXPOSE 3000

# Iniciar Jenkins y tu app Node.js
CMD ["sh", "-c", "jenkins && node index.js"]
