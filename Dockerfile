FROM docker.io/nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
COPY ./images /usr/share/nginx/html/images
COPY ./style.css /usr/share/nginx/html/style.css

EXPOSE 80
