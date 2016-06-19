FROM node
WORKDIR /src
COPY package.json .
RUN npm install
EXPOSE 3000
ENTRYPOINT ["node", "server.js"]
COPY . .
