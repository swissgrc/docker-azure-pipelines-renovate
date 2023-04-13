FROM node:18.16.0-bullseye-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-renovate"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-renovate"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prerequisites

# renovate: datasource=repology depName=debian_11/ca-certificates versioning=loose
ENV CACERTIFICATES_VERSION=20210119

# Ca-Certificates is required for connection to Azure DevOps
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends ca-certificates=${CACERTIFICATES_VERSION} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install Renovate

# renovate: datasource=npm depName=renovate
ENV RENOVATE_VERSION=35.47.0

# We need to run scripts here to have RE2 installed
RUN npm install -g renovate@${RENOVATE_VERSION} && \
  npm cache clean --force && \
  # Smoke test
  renovate --version

# Install Git

# renovate: datasource=repology depName=debian_11_backports/git versioning=loose
ENV GIT_VERSION=1:2.39.2-1~bpo11+1

# Install from backports since renovate requires at least git 2.33.0
RUN echo "deb https://deb.debian.org/debian bullseye-backports main" | tee /etc/apt/sources.list.d/bullseye-backports.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends -t bullseye-backports git=${GIT_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Configure Git
    git config --global user.email 'bot@renovateapp.com' && \
    git config --global user.name 'Renovate Bot'
