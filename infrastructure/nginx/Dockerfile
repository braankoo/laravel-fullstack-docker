FROM nginx:latest
ARG php_container
ARG PHP_PORT=9000
COPY ./config/nginx.conf /etc/nginx/nginx.conf
RUN echo "upstream php { server ${php_container}:${PHP_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
