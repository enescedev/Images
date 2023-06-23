FROM ubuntu:20.04

RUN apt update \
    && apt install -y ca-certificates openssh-client \
    wget iptables \
    && rm -rf /var/lib/apt/list/*


# Systemctl çalışabilmesi için
RUN apt update \
	&& apt install -y systemd \
    && rm -rf /var/lib/apt/list/*


# c# installations 
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
    && rm packages-microsoft-prod.deb \
    && rm -rf /var/lib/apt/list/*

CMD ["/bin/bash"]