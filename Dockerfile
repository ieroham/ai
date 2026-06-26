FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
RUN echo 'server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
    location /v1/ {
        if ($request_method = OPTIONS) {
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods GET,POST,OPTIONS;
            add_header Access-Control-Allow-Headers *;
            add_header Content-Length 0;
            add_header Content-Type text/plain;
            return 204;
        }
        proxy_pass https://freellmapi-production-3240.up.railway.app/v1/;
        proxy_set_header Host freellmapi-production-3240.up.railway.app;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods GET,POST,OPTIONS always;
        add_header Access-Control-Allow-Headers * always;
    }
}' > /etc/nginx/conf.d/default.conf
EXPOSE 80
