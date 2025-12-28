# --- STAGE 1: Build stage ---
FROM node:lts-alpine AS build
WORKDIR /app

COPY package*.json ./

# 🔥 REMOVER --production
RUN npm ci

COPY . .

# Se existir build (React/Vite/CRA)
RUN npm run build

# --- STAGE 2: Runtime ---
FROM node:lts-alpine
WORKDIR /ena-map-server-front

# Copia apenas o necessário
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./

EXPOSE 3005
CMD ["npm", "start"]
