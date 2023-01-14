FROM ubuntu:22.10

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    bash \
    build-essential \
    ca-certificates \
    htop \
    locales \
    man \
    python3 \
    python3-pip \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    tmux \
    unzip tar \
    vim nano \
    mariadb-server mariadb-client \
    php8.1 php8.1-fpm php8.1-cgi php8.1-mysqli php8.1-mbstring php8.1-common php8.1-mysql php-phpseclib php-pear \
    tzdata nginx \
    wget curl && \
    # Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes git

# Install Node.JS & Global dependencies
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && source ~/.nvm/nvm.sh && nvm install v18.12.1 && npm install -g http-server yarn

# Set tzdata for php
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# IntelliJ IDEA & WebStorm Setting
WORKDIR /etc/jetbrains
RUN wget -O idea.tar.gz https://download.jetbrains.com/idea/ideaIU-2022.3.1.tar.gz && \
    tar -xzvf idea.tar.gz && \
    rm idea.tar.gz && \
    sh $(find ./ -maxdepth 1 -name "idea*")/bin/remote-dev-server.sh registerBackendLocationForGateway

RUN wget -O webstorm.tar.gz https://download.jetbrains.com/webstorm/WebStorm-2022.3.1.tar.gz && \
    tar -xzvf webstorm.tar.gz && \
    rm webstorm.tar.gz && \
    sh $(find ./ -maxdepth 1 -name "Web*")/bin/remote-dev-server.sh registerBackendLocationForGateway

# PHPMyAdmin setting
WORKDIR /var/www
RUN wget -O phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip && \
    unzip phpmyadmin.zip && rm phpmyadmin.zip && mv $(find ./ -maxdepth 1 -name "php*") phpmyadmin

# Nginx setting
RUN rm /etc/nginx/sites-enabled/default && \
    printf "server {\n listen 80 default_server;\n listen [::]:80 default_server;\n\t\t\n server_name _;\n client_max_body_size 10G;\n\n root /var/www/phpmyadmin;\n index index.php index.html index.htm index.nginx-debian.html;\n\n location / {\n     try_files $uri $uri/ =404;\n }\n\n location ~ .php$ {\n   include snippets/fastcgi-php.conf;\n   fastcgi_pass unix:/run/php/php8.1-fpm.sock;\n }\n\n location ~ /.ht {\n     deny all;\n }\n}" >> /etc/nginx/sites-enabled/phpmyadmin

# Entrypoint script
RUN printf "#!/bin/sh" >> /usr/sbin/startup.sh && \
    printf "#!/bin/sh\nservice php8.1-fpm start\nservice nginx start\nservice mariadb start\nsh /usr/sbin/startup.sh\ntail -f /dev/null" >> /usr/sbin/entrypoint

CMD ["/bin/sh" , "/usr/sbin/entrypoint"]