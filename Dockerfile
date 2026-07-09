# Production multi-stage Dockerfile for WACRM Next.js app

# Builder stage: install deps and build the app
FROM node:20 AS builder
WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./

# Install all dependencies (including dev needed for build)
RUN npm ci

# Copy the rest of the source and build
COPY . .
RUN npm run build

# Runner stage: smaller image for runtime
FROM node:20-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Copy built app and node_modules from builder
COPY --from=builder /app /app

# Expose port (Next.js default)
EXPOSE 3000

# Start the Next.js production server
CMD ["npm", "start"]
