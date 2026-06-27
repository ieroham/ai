FROM nginx:alpine  
  
COPY index.html /usr/share/nginx/html/index.html  
  
RUN cat > /etc/nginx/conf.d/default.conf << 'EOF'  
server {  
    listen 80;  
    server_name localhost;  
    root /usr/share/nginx/html;  
    index index.html;  
      
    location / {  
        try_files $uri $uri/ /index.html;  
    }  
      
    location /v1/ {  
        proxy_pass https://freellmapi-production-3240.up.railway.app/v1/;  
        proxy_http_version 1.1;  
        proxy_set_header Host $host;  
        proxy_set_header X-Real-IP $remote_addr;  
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
        proxy_set_header X-Forwarded-Proto $scheme;  
          
        add_header Access-Control-Allow-Origin * always;  
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;  
        add_header Access-Control-Allow-Headers * always;  
          
        if ($request_method = OPTIONS) {  
            return 204;  
        }  
    }  
}  
EOF  
  
EXPOSE 80  
