# --- STAGE 1: Build stage ---
FROM node:lts-alpine AS build
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
# Use 'npm ci' for production builds for deterministic installs
RUN npm ci --production

# Copy the rest of the application code
COPY . .

# Run your production build command (if any, e.g., 'npm run build')
# For a simple Node app, this might just be the dependency install
# RUN npm run build

# --- STAGE 2: Production stage (using a minimal base) ---
FROM node:lts-alpine
WORKDIR /ena-map-server-front

# Copy only the necessary files from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app .

EXPOSE 3005

# The production start command
CMD ["npm", "start"]