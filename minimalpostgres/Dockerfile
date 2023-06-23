FROM ubuntu:20.04

#ENV
ENV TZ=Europe/Istanbul
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /mock
WORKDIR /mock
COPY data /mock

RUN apt update \
    && apt install -y ca-certificates openssh-client ca-certificates wget gnupg lsb-release \
    wget iptables \
    && rm -rf /var/lib/apt/list/*

# postgresql kurulumu

RUN apt update \
    && apt install -y \
	&& wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && apt update \
	&& apt install -y tzdata \
	&& apt install -y postgresql-14 \
    && rm -rf /var/lib/apt/list/*

# PostgreSQL veritabanını başlat, test veritabanı oluştur ve komutları çalıştır

RUN chmod +x /mock/init-db.sh 
RUN chown postgres:postgres /mock
USER root

ENTRYPOINT [ "/mock/init-db.sh" ]