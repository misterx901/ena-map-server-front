# --- STAGE 1: Build ---
FROM node:lts-alpine AS build
WORKDIR /app

COPY package*.json ./

# 🔥 resolve conflito do MUI
RUN npm ci --legacy-peer-deps

COPY . .

RUN npm run build

# --- STAGE 2: Runtime ---
FROM node:lts-alpine
WORKDIR /ena-map-server-front

COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./

EXPOSE 3005
CMD ["npm", "start"]
