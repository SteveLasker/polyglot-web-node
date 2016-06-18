FROM node
RUN mkdir /src
COPY package.json /src
RUN npm install
COPY . /src
WORKDIR /src
EXPOSE 80
ENTRYPOINT ["node", "./bin/www"]
