FROM node:argon

WORKDIR /app

ENV PORT 80

EXPOSE 80

ENTRYPOINT node server.js

COPY package.json .

RUN npm install

COPY . .