FROM node:19-alpine

ENV npm_config_cache ./.npm-cache
RUN apk add --no-cache dos2unix envsubst

WORKDIR /srv/app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN dos2unix entrypoint.sh && \
    npm run build && \
    chown node: build/index.html && \
    chgrp -R 0 /srv/app && \
    chmod -R g=u /srv/app

USER node

EXPOSE 3000

ENTRYPOINT [ "./entrypoint.sh" ]
CMD ["npm", "run", "start"]
