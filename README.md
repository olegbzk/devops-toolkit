# DevOps Toolkit

A comprehensive Docker image containing essential tools for cloud infrastructure management, deployment automation, and container orchestration.

## Overview

This project provides a single Docker image packed with DevOps tools for:
- Infrastructure as Code (OpenTofu, Ansible)
- Kubernetes management (kubectl, Helm, Helmfile)
- Cloud provider management (AWS CLI, Azure CLI)
- Secrets management (SOPS, age)
- Data processing (yq, jq)

## Installed Applications

The following tools are included with their current versions (defined in `versions.json`):

### Infrastructure as Code

- **OpenTofu**: `1.10.6` - Open source Terraform alternative for infrastructure provisioning
- **Ansible**: `2.18.3` - Configuration management and application deployment automation

### Kubernetes & Container Management

- **kubectl**: `1.32.3` - Kubernetes command-line tool
- **Helm**: `3.19.0` - Kubernetes package manager
- **Helmfile**: `1.1.7` - Declarative spec for deploying Helm charts

### Data Processing & Configuration

- **yq**: `4.44.2` - YAML/JSON/XML processor
- **jq**: Built-in - JSON processor (Ubuntu package)

### Security & Secrets Management

- **SOPS**: `3.11.0` - Secrets management tool
- **age**: `1.2.1` - Modern encryption tool

### Cloud Provider CLI Tools

- **AWS CLI**: `2.24.24` - Amazon Web Services command-line interface
- **Azure CLI**: `2.70.0` - Microsoft Azure command-line interface

### Additional Tools

- **Git**: Latest (Ubuntu package) - Version control system
- **curl**: Latest (Ubuntu package) - Data transfer tool
- **unzip**: Latest (Ubuntu package) - Archive extraction
- **OpenSSH Client**: Latest (Ubuntu package) - SSH connectivity

## Usage

### Building the Image

Build the image using Docker:

```bash
docker build -t devops-toolkit:latest .
```

### Running the Container

Run the container interactively:

```bash
docker run -it devops-toolkit:latest
```

Run with mounted volumes for persistent work:

```bash
docker run -it -v $(pwd):/workspace devops-toolkit:latest
```

## Version Management

All tool versions are centrally managed in `versions.json`. To update any tool version:

1. Edit `versions.json`
2. Rebuild the image
3. The CI/CD pipeline automatically uses these versions for builds

## CI/CD

The project includes GitHub Actions workflow (`build-push.yml`) that:

- Automatically reads versions from `versions.json`
- Builds and pushes images to Docker Hub
- Uses Docker BuildKit with caching for efficient builds
- Tags images with semantic versioning

## License

This project is licensed under the terms specified in the LICENSE file.