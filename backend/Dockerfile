# Stage 1
FROM node:22-slim AS backend-builder

# setup the working dir
WORKDIR /app

# code
COPY package*.json ./

# packages install
RUN npm ci

COPY . .

# tests
RUN npm run test

# Stage 2
FROM node:22-slim AS production

# setup the working dir
WORKDIR /app

# copy the above stage as compressed
COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force
COPY --from=backend-builder /app/server.js ./server.js
COPY --from=backend-builder /app/config ./config
COPY --from=backend-builder /app/controllers ./controllers
COPY --from=backend-builder /app/data ./data
COPY --from=backend-builder /app/models ./models
COPY --from=backend-builder /app/public ./public
COPY --from=backend-builder /app/routes ./routes
COPY --from=backend-builder /app/services ./services
COPY --from=backend-builder /app/utils ./utils
# Port
EXPOSE 8080

# App
CMD ["npm", "start"]
