# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build  # Ensure this creates dist/index.js

# Stage 2: Runtime
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist  # Make sure this exists

# Alternative if not using dist:
# COPY --from=builder /app/src ./src

EXPOSE 3000
CMD ["node", "dist/index.js"]  # Or "src/index.js" if not using dist
