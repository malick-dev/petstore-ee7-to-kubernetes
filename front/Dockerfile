# @see https://hub.docker.com/_/nginx
FROM nginx:1.17.9-alpine
# add server conf to nginx conf
COPY default.conf /etc/nginx/conf.d/
COPY static /usr/share/nginx/html