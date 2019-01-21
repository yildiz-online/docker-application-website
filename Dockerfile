FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
RUN git clone --single-branch -b develop https://github.com/yildiz-online/repo-web.git

FROM moussavdb/build-nodejs as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/repo-web /app
RUN yarn
RUN ng build --prod

FROM nginx
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
COPY --from=build /app/dist /usr/share/nginx/html
RUN apt-get install -y -q curl
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
