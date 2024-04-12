FROM nginx:latest

RUN mkdir -p /code

COPY index.html /code
WORKDIR /code

COPY app.conf /etc/nginx/conf.d/default.conf

CMD nginx -g 'daemon off;'
