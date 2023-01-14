FROM ubuntu:22.10

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    bash \
    build-essential \
    ca-certificates \
    curl \
    htop \
    locales \
    man \
    python3 \
    python3-pip \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    nano \
    tar \
    mariadb-server \
    mariadb-client \
    tzdata \
    nginx \
    php8.1 \
    php8.1-fpm \
    wget && \
    # Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes git

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

WORKDIR /etc/jetbrains

RUN wget -O idea.tar.gz https://download.jetbrains.com/idea/ideaIU-2022.3.1.tar.gz && \
    tar -xzvf idea.tar.gz && \
    rm idea.tar.gz && \
    sh $(find ./ -maxdepth 1 -name "idea*")/bin/remote-dev-server.sh registerBackendLocationForGateway

RUN wget -O webstorm.tar.gz https://download.jetbrains.com/webstorm/WebStorm-2022.3.1.tar.gz && \
    tar -xzvf webstorm.tar.gz && \
    rm webstorm.tar.gz && \
    sh $(find ./ -maxdepth 1 -name "Web*")/bin/remote-dev-server.sh registerBackendLocationForGateway

WORKDIR /var/www
RUN wget -O phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip && \
    unzip phpmyadmin.zip

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder
