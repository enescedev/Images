FROM ubuntu:20.04

RUN apt update \
    && apt install -y ca-certificates openssh-client \
    wget curl iptables supervisor \
    && rm -rf /var/lib/apt/list/*

ENV DOCKER_CHANNEL=stable \
	DOCKER_VERSION=20.10.18 \
	DOCKER_COMPOSE_VERSION=1.29.2 \
	DEBUG=false

# Docker installation
RUN set -eux; \
		arch="$(uname --m)"; \
	case "$arch" in \
        # amd64
		x86_64) dockerArch='x86_64' ;; \
        # arm32v6
		armhf) dockerArch='armel' ;; \
        # arm32v7
		armv7) dockerArch='armhf' ;; \
        # arm64v8
		aarch64) dockerArch='aarch64' ;; \
		*) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
	esac; \
	\
	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version

# Additional installations
RUN apt-get update \
    && apt-get install -y vim \
    && wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get install -y gpg \
    && wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o microsoft.asc.gpg \
    && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
    && wget https://packages.microsoft.com/config/ubuntu/22.04/prod.list \
    && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
    && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-6.0 \
    && rm packages-microsoft-prod.deb

COPY modprobe startup.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/

RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/modprobe

VOLUME /var/lib/docker

# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose && docker-compose version

# Set PS1 to only display "hostname $ " sign.
RUN echo "PS1='\h \$ '" >> /root/.bashrc

ENTRYPOINT ["startup.sh"]
CMD ["bash"]