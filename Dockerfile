FROM nginx:alpine

# فایل فرانت
COPY index.html /usr/share/nginx/html/index.html

# ساخت nginx.conf داخل خود Dockerfile (بدون فایل سوم)
RUN rm /etc/nginx/conf.d/default.conf && \
cat > /etc/nginx/conf.d/default.conf <<'EOF'
server {
    listen 80;
    
    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }

    location /v1/ {
        proxy_pass https://freellmapi-production-3240.up.railway.app/v1/;
        proxy_set_header Host freellmapi-production-3240.up.railway.app;
        proxy_set_header Authorization $http_authorization;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Authorization, Content-Type" always;
        if ($request_method = OPTIONS) { return 204; }
    }
}
EOF
