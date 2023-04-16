
#Separar los pasos en diferentes etapas permite  "organizar mejor lo que queremos hacer"
#Cada construccion de imagen msotrada abajo  son imagenes temporales y al final solo queda la ultima imagen contrusida
#Ejemplo en una etapa construimos las dependencias que posteriormente podemos usarla y además no va a volver a reconstruirse si  no ha cambiado nada
#Se debe asignar un alias a cada etapa con 'as'

#Etapa 1, creamos una imagen solo para instalar las dependencias incluidas las de desarrollo
FROM node:lts-alpine as dependencias
WORKDIR /app
COPY package.json ./
RUN npm install

#Etapa 2, armamos la otra imagen para ejecutar las pruebas, si falla se detiene la construccion.
#podemos copiar archivos de la imagen previa temporal
FROM node:lts-alpine as tester-builder
WORKDIR /app
COPY --from=dependencias /app/node_modules ./node_modules
COPY . ./
RUN npm run test

#Etapa 3, armamos otra imagen solo con las dependencias de prod.
FROM node:lts-alpine as prod-dependencias
WORKDIR /app
COPY package.json ./
RUN npm install --prod

#Etapa 4, armamos otra imagen con todo, tomamos las dependencia de la imagen previa
#tambien copiamos solo lo que nos interesa, pudieramos decirle que todo con . ./, pero esto traería los archivos de pruebas, 
#e ignorarlos en el .dockerignore no nos conviene porque lo necesitamos para las priemras etapas
FROM node:lts-alpine as runner
WORKDIR /app
COPY --from=prod-dependencias /app/node_modules ./node_modules
COPY index.js ./
CMD ["node","index.js"]

#Este es el metodo sin etapa originalmente usado
# FROM node:lts-alpine
# WORKDIR /app
# COPY . ./
# RUN npm install
# RUN npm run test
# RUN rm -rf saludo.js && rm -rf saludo.test.js && rm -rf node_modules
# RUN npm install --prod
# CMD ["node","index.js"]
