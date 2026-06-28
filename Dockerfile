FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
RUN echo 'server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri /index.html;
    }

    location /v1/ {
        proxy_pass https://freellmapi-production-3240.up.railway.app/v1/;
        proxy_ssl_verify off;
        proxy_set_header Host freellmapi-production-3240.up.railway.app;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        if ($request_method = "OPTIONS") {
            add_header "Access-Control-Allow-Origin" "*";
            add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, PUT, DELETE";
            add_header "Access-Control-Allow-Headers" "Authorization, Content-Type, Accept";
            return 204;
        }

        add_header "Access-Control-Allow-Origin" "*";
        add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, PUT, DELETE";
        add_header "Access-Control-Allow-Headers" "Authorization, Content-Type, Accept";
    }
}' > /etc/nginx/conf.d/default.conf
EXPOSE 80
