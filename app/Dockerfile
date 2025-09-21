# app/Dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package.json ./
RUN npm ci --only=production

COPY . .
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD wget -qO- --timeout=2 http://127.0.0.1:3000/ || exit 1
CMD ["node", "src/app.js"]
