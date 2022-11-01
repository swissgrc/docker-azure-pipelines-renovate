FROM node:18.12.0-bullseye-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-renovate"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-renovate"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prerequisites

#Disabled renovate: datasource=repology depName=debian_11/ca-certificates versioning=loose
ENV CACERTIFICATES_VERSION=20210119

# Ca-Certificates is required for connection to Azure DevOps
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends ca-certificates=${CACERTIFICATES_VERSION} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install Renovate

# renovate: datasource=npm depName=renovate
ENV RENOVATE_VERSION=34.12.0

RUN npm install -g renovate@${RENOVATE_VERSION} && \
  npm cache clean --force && \
  # Smoke test
  renovate --version

# Install Git

# Install from backports since renovate requires at least git 2.33.0
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" | tee /etc/apt/sources.list.d/bullseye-backports.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends -t bullseye-backports git=1:2.34.1-1~bpo11+1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Configure Git
    git config --global user.email 'bot@renovateapp.com' && \
    git config --global user.name 'Renovate Bot'
