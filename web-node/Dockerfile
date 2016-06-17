FROM node:argon

WORKDIR /app

ENV PORT 8080

EXPOSE 8080

ENTRYPOINT node server.js

COPY package.json .

RUN npm install

COPY . .