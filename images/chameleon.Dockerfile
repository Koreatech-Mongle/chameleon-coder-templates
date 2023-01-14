# From the base image (built on Docker host)
FROM coder-base:v0.1

# Install everything as root
USER root

WORKDIR /usr/src
RUN git clone https://github.com/Koreatech-Mongle/chameleon-platform -b develop && \
    git clone https://github.com/Koreatech-Mongle/chameleon-client -b develop && \
    git clone https://github.com/Koreatech-Mongle/chameleon-controller -b develop

WORKDIR /usr/src/chameleon-platform
RUN npm install
WORKDIR /usr/src/chameleon-client
RUN npm install
WORKDIR /usr/src/chameleon-controller
RUN npm install

# Set back to coder user
USER coder