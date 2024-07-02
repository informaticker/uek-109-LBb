FROM node:19-alpine

ENV npm_config_cache ./.npm-cache
RUN apk add --no-cache dos2unix 

WORKDIR /srv/app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN dos2unix entrypoints/*

USER node

EXPOSE 8080
ENTRYPOINT [ "entrypoints/production.sh" ]
CMD [ "npm", "start" ]
