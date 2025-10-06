ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    jq \
    unzip \
    openssh-client \
    locales \
    python3-full \
    python3-pip 

ARG ANSIBLE_VERSION=2.18.3
RUN python3 -m pip install ansible-core==${ANSIBLE_VERSION} --break-system-packages

ARG TOFU_VERSION=1.10.6
RUN mkdir /tmp/tofu_env/ && \
    cd /tmp/tofu_env/ && \
    curl -LO https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_amd64.zip && \
    unzip tofu_${TOFU_VERSION}_linux_amd64.zip && \
    cp tofu /usr/local/bin/ && chmod +x /usr/local/bin/tofu && \
    rm -rf /tmp/tofu_env/

ARG KUBECTL_VERSION=1.32.3
RUN mkdir /tmp/kubectl_env/ && \
    cd /tmp/kubectl_env/ && \
    curl -LO "https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    rm -rf /tmp/kubectl_env/

ARG AWSCLI_VERSION=2.24.24
RUN mkdir /tmp/awscli_env/ && \
    cd /tmp/awscli_env/ && \
    curl -LO "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" && \
    unzipc -qq awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip && ./aws/install && rm -rf /tmp/awscli_env/

ARG AZURECLI_VERSION=2.70.0
RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y azure-cli=$AZURECLI_VERSION-1~$AZ_DIST

ARG HELM_VERSION=3.19.0
RUN mkdir /tmp/helm_env/ && \
    cd /tmp/helm_env/ && \
    curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf /tmp/helm_env/

RUN helm plugin install https://github.com/databus23/helm-diff --version v3.13.0 && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version 4.6.10

ARG HELMFILE_VERSION=1.1.7
RUN curl -L https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz -o /tmp/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz && \
    tar -xf /tmp/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz -C /tmp/ && mv /tmp/helmfile /usr/local/bin/helmfile  && chmod +x /usr/local/bin/helmfile

ARG YQ_VERSION=4.44.2
RUN curl -L https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz -o /tmp/yq_linux_amd64.tar.gz && \
    tar -xf /tmp/yq_linux_amd64.tar.gz -C /tmp/ && mv /tmp/yq_linux_amd64 /usr/local/bin/yq  && chmod +x /usr/local/bin/yq

ARG SOPS_VERSION=3.11.0
RUN curl -L https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops

ARG AGE_VERSION=1.2.1  
RUN curl -L https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz -o /tmp/age-linux-amd64.tar.gz && \
    tar -xf /tmp/age-linux-amd64.tar.gz -C /tmp &&  mv /tmp/age/age* /usr/local/bin/ && chmod +x /usr/local/bin/age /usr/local/bin/age-keygen

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENV DEBIAN_FRONTEND=teletype
ENV TZ=""

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
