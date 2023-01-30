# From the base image (built on Docker host)
FROM coder-base:v0.1

RUN touch /usr/sbin/startup.lock
RUN echo "if [ -f /usr/sbin/startup.lock ]; then" >> /usr/sbin/startup
RUN echo "cd /usr/src" >> /usr/sbin/startup
RUN echo "git clone https://github.com/Koreatech-Mongle/chameleon-platform -b develop" >> /usr/sbin/startup
RUN echo "git clone https://github.com/Koreatech-Mongle/chameleon-client -b develop" >> /usr/sbin/startup
RUN echo "git clone https://github.com/Koreatech-Mongle/chameleon-controller -b develop" >> /usr/sbin/startup
RUN echo "git clone https://github.com/Koreatech-Mongle/chameleon-coder-templates" >> /usr/sbin/startup
RUN echo "git clone https://github.com/Koreatech-Mongle/model-executor" >> /usr/sbin/startup

RUN echo "cd /usr/src/chameleon-platform && npm install" >> /usr/sbin/startup
RUN echo "cd /usr/src/chameleon-client && npm install" >> /usr/sbin/startup
RUN echo "cd /usr/src/chameleon-controller" >> /usr/sbin/startup
RUN echo "cd /usr/src/chameleon-coder-templates && cp -r settings/* /usr/src/ && cp -r settings/.idea /usr/src" >> /usr/sbin/startup
# npm install

RUN echo "cd /usr/src/model-executor/backend && npm install && \\" >> /usr/sbin/startup
RUN echo "echo '{\"httpPort\":5000,\"socketExternalHost\":\"chameleon.best\",\"socketPort\":5050,\"defaultDockerServer\":\"mongle\",\"dockerServers\":{\"mongle\":{\"host\":\"host.docker.internal\",\"port\":33000}}}' >> config.json" >> /usr/sbin/startup

RUN echo "cd /usr/src/model-executor/frontend && npm install" >> /usr/sbin/startup
RUN echo "cd /usr/src/model-executor/controller && npm install && npm run pack" >> /usr/sbin/startup
RUN echo "rm /usr/sbin/startup.lock" >> /usr/sbin/startup
RUN echo "fi" >> /usr/sbin/startup

ARG root_password
ENV ROOT_PASSWORD=${root_password}
RUN echo "root:${ROOT_PASSWORD}" | chpasswd