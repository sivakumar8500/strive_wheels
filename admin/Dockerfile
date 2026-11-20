# 1. Install dependencies
FROM node:22-alpine AS deps
WORKDIR /app

COPY package*.json package-lock.json* ./
RUN npm install
 
# 2. Build stage
FROM node:22-alpine AS builder
WORKDIR /app

# Install jq for JSON processing
RUN apk add --no-cache jq

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Get base64 encoded secrets
ARG SECRET_JSON_B64

# To this (remove the additional NEXT_PUBLIC_ prefix):
RUN echo "$SECRET_JSON_B64" | base64 -d > /tmp/secrets.json && \
    jq -r 'to_entries | .[] | "\(.key)=\(.value)"' /tmp/secrets.json > .env.production && \
    rm /tmp/secrets.json

# Print the environment (for debugging)
RUN cat .env.production

RUN rm -rf .next
RUN npm run build
 
# 3. Runtime
FROM node:22-alpine AS runner
WORKDIR /app
ENV PORT=3000
 
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
 
EXPOSE 3000
CMD ["npm", "start"]