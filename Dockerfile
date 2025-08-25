FROM nginx:alpine
COPY nginx-config/default.conf /etc/nginx/conf.d/default.conf
COPY html-content/index.html /usr/share/nginx/html/index.html
COPY html-content /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
