# --- STAGE 1: Build ---
FROM node:lts-alpine AS build
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm ci --legacy-peer-deps

# Copia todo o código
COPY . .

# --- RECEBE VARIÁVEIS DE BUILD ---
ARG REACT_APP_STAGE
ARG REACT_APP_HOMEPAGE

# Disponibiliza para o CRA
ENV REACT_APP_STAGE=$REACT_APP_STAGE
ENV REACT_APP_HOMEPAGE=$REACT_APP_HOMEPAGE

# Atualiza o package.json dinamicamente
RUN node -e "const fs = require('fs');const pkg = JSON.parse(fs.readFileSync('./package.json','utf8'));pkg.homepage = process.env.REACT_APP_HOMEPAGE || pkg.homepage;fs.writeFileSync('./package.json', JSON.stringify(pkg,null,2));console.log('✅ homepage setada para:', pkg.homepage);"

# Build do React
RUN npm run build

# --- STAGE 2: Runtime ---
FROM node:lts-alpine
WORKDIR /ena-map-server-front

# Instala o server estático
RUN npm install -g serve

# Copia o build do stage anterior
COPY --from=build /app/build ./build

# Expõe a porta
EXPOSE 3005

# Comando para servir o build
CMD ["serve", "-s", "build", "-l", "3005"]
