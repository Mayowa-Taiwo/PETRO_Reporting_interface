FROM node:20-alpine
WORKDIR /app
COPY apps/web/package.json apps/web/package-lock.json* ./
RUN npm ci 2>/dev/null || npm install --legacy-peer-deps
COPY apps/web .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
