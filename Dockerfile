FROM node:10.16.0

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm i

COPY . .

EXPOSE 8080

CMD node app.js 8080 /usr/src/app
