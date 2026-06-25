FROM nginx:alpine

# کپی رابط کاربری
COPY index.html /usr/share/nginx/html/index.html

# ساخت کانفیگ nginx با reverse proxy (بدون فایل سوم)
RUN rm /etc/nginx/conf.d/default.conf && \
    cat > /etc/nginx/conf.d/default.conf <<'NGINX'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # فایل‌های استاتیک
    location / {
        try_files $uri $uri/ =404;
    }

    # پراکسی به FreeLLMAPI - حل مشکل CORS
    location /v1/ {
        proxy_pass https://freellmapi-production-3240.up.railway.app/v1/;
        proxy_http_version 1.1;
        proxy_ssl_server_name on;

        proxy_set_header Host freellmapi-production-3240.up.railway.app;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header Content-Type $http_content_type;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # CORS headers
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Authorization, Content-Type" always;

        if ($request_method = OPTIONS) {
            return 204;
        }
    }
}
NGINX

EXPOSE 80
