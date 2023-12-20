FROM moussavdb/build-nodejs as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
RUN git clone --single-branch -b develop https://github.com/yildiz-online/repo-web.git
WORKDIR /repo-web
RUN pnpm install
RUN ng build --configuration production

FROM nginx:alpine
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
COPY --from=build /repo-web/dist /usr/share/nginx/html
RUN apk add --update curl \
    && rm -rf /var/cache/apk/*
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
