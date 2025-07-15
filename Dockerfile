# Etapa de construcción
FROM node:18 AS build
WORKDIR /app

# Copiar los archivos package.json y package-lock.json primero para aprovechar la caché de Docker
COPY package*.json ./

# Instalar las dependencias en el contenedor
RUN npm install

# Copiar el resto del código
COPY . .

# Ejecutar la construcción de React
RUN npm run build

# Etapa de producción
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]