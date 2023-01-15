# From the base image (built on Docker host)
FROM coder-base:v0.1

WORKDIR /usr/src
RUN git clone https://github.com/Koreatech-Mongle/chameleon-platform -b develop && \
    git clone https://github.com/Koreatech-Mongle/chameleon-client -b develop && \
    git clone https://github.com/Koreatech-Mongle/chameleon-controller -b develop && \
    git clone https://github.com/Koreatech-Mongle/model-executor

WORKDIR /usr/src/chameleon-platform
RUN npm install
WORKDIR /usr/src/chameleon-client
RUN npm install
WORKDIR /usr/src/chameleon-controller
# RUN npm install

WORKDIR /usr/src/model-executor/backend
RUN npm install
WORKDIR /usr/src/model-executor/front
RUN npm install
WORKDIR /usr/src/model-executor/controller
RUN npm install && npm run pack