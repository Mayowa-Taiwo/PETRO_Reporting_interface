FROM node:20-alpine
WORKDIR /app

COPY portal/package*.json ./
RUN npm install

COPY portal/ ./
COPY packages/ /packages/
COPY products/ /products/

RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
