#!/bin/bash
DEFAULT_APPILICATION_NAME="myapp"
DEFAULT_NETWORK_NAME="my-app-network"
DEFAULT_LOCALHOST_URL="myapp.localhost"

while true; do
    read -p "Please enter a name for your application (default: $DEFAULT_APPILICATION_NAME): " APPLICATION_NAME
    APPLICATION_NAME=${APPLICATION_NAME:-$DEFAULT_APPILICATION_NAME}

    echo "You entered: $APPLICATION_NAME"
    read -p "Is this correct? (y/n): " CONFIRM

    case $CONFIRM in
      [Yy]* ) break;;
      [Nn]* ) echo "Let's try again...";;
      * ) echo "Please answer y or n.";;
    esac
done


while true; do
    read -p "Please enter a name for the Docker network (default: $DEFAULT_NETWORK_NAME): " NETWORK_NAME
    NETWORK_NAME=${NETWORK_NAME:-$DEFAULT_NETWORK_NAME}

    echo "You entered: $NETWORK_NAME"
    read -p "Is this correct? (y/n): " CONFIRM

    case $CONFIRM in
      [Yy]* ) break;;
      [Nn]* ) echo "Let's try again...";;
      * ) echo "Please answer y or n.";;
    esac
done


while true; do
    read -p "Please enter the localhost URL your app will run on (default: $DEFAULT_LOCALHOST_URL): " LOCALHOST_URL
    LOCALHOST_URL=${LOCALHOST_URL:-$DEFAULT_LOCALHOST_URL}

    echo "You entered: $LOCALHOST_URL"
    read -p "Is this correct? (y/n): " CONFIRM
    case $CONFIRM in
      [Yy]* ) break;;
      [Nn]* ) echo "Let's try again...";;
      * ) echo "Please answer y or n.";;
    esac
done

touch ./infrastructure/.env
echo "APPLICATION_NAME=$APPLICATION_NAME" > ./infrastructure/.env
echo "NETWORK_NAME=$NETWORK_NAME" >> ./infrastructure/.env
echo "LOCALHOST_URL=$LOCALHOST_URL" >> ./infrastructure/.env
echo "Configuration saved to ./infrastructure/.env"



set -o allexport
source ./infrastructure/.env
set +o allexport

if [ -z "$NETWORK_NAME" ]; then
  echo "NETWORK_NAME nije definisan u .env fajlu."
  exit 1
fi

sed -i "" "s/__NETWORK_NAME__/${NETWORK_NAME}/g" ./infrastructure/docker-compose.yml

touch ./infrastructure/nginx/sites/$APPLICATION_NAME.conf

cat > ./infrastructure/nginx/sites/${APPLICATION_NAME}.conf <<EOF
server {

    listen 80;
    server_name ${LOCALHOST_URL};

    location / {
        proxy_pass http://${APPLICATION_NAME}_node:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /api {
        root /var/www/api/public;
        fastcgi_connect_timeout 3m;
        fastcgi_param SERVER_NAME \$host;
        fastcgi_pass php;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME \$document_root/index.php;
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

}
EOF
