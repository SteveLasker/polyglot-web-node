FROM node
RUN mkdir /src
COPY package.json /src
RUN npm install
COPY . /src
WORKDIR /src
EXPOSE 3000
ENTRYPOINT ["node", "./bin/www"]
