FROM node
ARG source=.
WORKDIR /src
COPY package.json .
RUN npm install
EXPOSE 3000
COPY $source .
ENTRYPOINT ["node", "server.js"]
