FROM ubuntu:18.04

RUN apt update \
    && apt install -y ca-certificates openssh-client \
    wget iptables \
    && rm -rf /var/lib/apt/list/*

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 19.03.5
ENV DEBUG false
# TODO ENV DOCKER_SHA256
# https://github.com/docker/docker-ce/blob/5b073ee2cf564edee5adca05eee574142f7627bb/components/packaging/static/hash_files !!
# (no SHA file artifacts on download.docker.com yet as of 2017-06-07 though)

RUN set -eux; \
	\
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

COPY modprobe.sh /usr/local/bin/modprobe
COPY docker-entrypoint.sh /usr/local/bin/

# https://github.com/docker-library/docker/pull/166
#   dockerd-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-generating TLS certificates
#   docker-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-setting DOCKER_TLS_VERIFY and DOCKER_CERT_PATH
# (For this to work, at least the "client" subdirectory of this path needs to be shared between the client and server containers via a volume, "docker cp", or other means of data sharing.)
ENV DOCKER_TLS_CERTDIR=/certs
# also, ensure the directory pre-exists and has wide enough permissions for "dockerd-entrypoint.sh" to create subdirectories, even when run in "rootless" mode
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/modprobe
# (doing both /certs and /certs/client so that if Docker does a "copy-up" into a volume defined on /certs/client, it will "do the right thing" by default in a way that still works for rootless users)

# Systemctl çalışabilmesi için
RUN apt update \
	&& apt install -y systemd \
    && rm -rf /var/lib/apt/list/*

VOLUME /var/lib/docker

# postgresql kurulumu

ENV TZ=Europe/Istanbul
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y ca-certificates wget gnupg lsb-release \
    # && wget --quiet -O - **https://www.postgresql.org/media/keys/ACCC4CF8.asc** | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg \
	# && echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] **http://apt.postgresql.org/pub/repos/apt/** $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
	&& wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && apt update \
	&& apt install -y tzdata \
	&& apt install -y postgresql-14 \
    && rm -rf /var/lib/apt/list/*


ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["systemd.unit=multi-user.target"]