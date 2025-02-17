# Docker image for running Renovate in Azure Pipelines container jobs

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-renovate/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-renovate/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-renovate/actions/workflows/publish.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=swissgrc_docker-azure-pipelines-renovate&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=swissgrc_docker-azure-pipelines-renovate) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-renovate.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-renovate) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-renovate.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-renovate)
<!-- markdownlint-restore -->

Docker image to run [Renovate] in [Azure Pipelines container jobs].

## Usage

This container can be used to run Renovate in [Azure Pipelines container jobs].

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job add the following task use it with the `target` property.

The following example shows the container used for running Renovate:

```yaml
- stage: Renovate
  jobs:
  - job: Renovate
    steps:
    - bash: |
        npx renovate
      target: swissgrc/azure-pipelines-renovate:latest
```

## Included Software
- [swissgrc/azure-pipelines-node:22-net8](https://github.com/swissgrc/docker-azure-pipelines-node22-net8) as base image
- Renovate
- Flux

## Tags

<!-- markdownlint-disable MD013 -->
| Tag      | Description                                     | Size                                                                                                                              |
|----------|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)      | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-renovate/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-renovate/unstable?style=flat-square) |
| x.y.z    | Image for a specific version of Renovate        |                                                                                                                                   |
<!-- markdownlint-restore -->

[Renovate]: https://renovatebot.com/
[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
