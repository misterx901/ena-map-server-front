# --- STAGE 1: Build ---
FROM node:lts-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci --legacy-peer-deps

COPY . .
RUN npm run build

# --- STAGE 2: Runtime ---
FROM node:lts-alpine
WORKDIR /ena-map-server-front

# Instala apenas o server estático
RUN npm install -g serve

COPY --from=build /app/build ./build

EXPOSE 3005

CMD ["serve", "-s", "build", "-l", "3005"]
