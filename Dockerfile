FROM ghcr.io/swissgrc/azure-pipelines-node:22.15.0-net9 AS base

FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_12/curl versioning=deb
ENV CURL_VERSION=7.88.1-10+deb12u12

RUN apt-get update -y && \
    # Install necessary dependencies
    apt-get install -y --no-install-recommends curl=${CURL_VERSION}

# Install the Flux CLI

# renovate: datasource=github-releases depName=fluxcd/flux2 extractVersion=^v(?<version>.*)$
ENV FLUX_VERSION=2.5.1

RUN curl -s https://fluxcd.io/install.sh | FLUX_VERSION=${FLUX_VERSION} bash

FROM base AS final

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-renovate"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-renovate"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /

# Smoke test prerequisites
RUN git version && \
    dotnet --version

# Install Renovate

# renovate: datasource=npm depName=renovate
ENV RENOVATE_VERSION=39.262.1

# We need to run scripts here to have RE2 installed
RUN npm install -g renovate@${RENOVATE_VERSION} && \
    npm cache clean --force && \
    # Smoke test
    renovate --version

# Install Flux CLI

# Copy Flux CLI from build stage
COPY --from=build /usr/local/bin/flux /usr/local/bin/flux

# Smoke test    
RUN flux --version

# Configure Git

RUN git config --global user.email 'bot@renovateapp.com' && \
    git config --global user.name 'Renovate Bot'

# Clean up
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*