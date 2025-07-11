# build environment
FROM node:22 as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
COPY package-lock.json /usr/src/app/package-lock.json
COPY . /usr/src/app
RUN npm install && npm run build

# production environment
FROM nginx:alpine
RUN rm -rf /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# index.html will include config.js
ENV START_SCRIPT=/usr/share/docker-entrypoint.sh
COPY docker-entrypoint.sh $START_SCRIPT
RUN chmod 551 $START_SCRIPT

EXPOSE 80
CMD ["/bin/sh", "/usr/share/docker-entrypoint.sh", "/usr/share/nginx/html/env-config.js"]