FROM rockylinux:8

RUN dnf -y install epel-release && \
    dnf -y install iptables supervisor procps-ng

ENV DOCKER_VERSION=20.10.8 \
	DOCKER_COMPOSE_VERSION=1.29.2 \
	DEBUG=false

RUN set -eux; \
    curl -L https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz -o docker.tgz && \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin && \
    rm docker.tgz

# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose && docker-compose version

COPY supervisor/docker.ini /etc/supervisord.d/docker.ini
COPY startup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/startup.sh

# set PS1 to only display "hostname $ " sign.
RUN echo "PS1='\h \$ '" >> /root/.bashrc

ENTRYPOINT ["startup.sh"]
CMD ["bash"]
