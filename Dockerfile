FROM donbeave/jackin-construct:trixie

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install additional system packages for Rust and Java builds
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    build-essential \
    libclang-dev \
    libssl-dev \
    openssl \
    pkg-config && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/lib/apt/* \
               /var/cache/apt/* \
               /tmp/*

# Install GitHub CLI
RUN sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    sudo chmod a+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends gh && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/lib/apt/* /var/cache/apt/* /tmp/*

USER claude

ENV MISE_TRUSTED_CONFIG_PATHS=/workspace

# Set Docker API version for Testcontainers compatibility with Docker 29.x
RUN echo "api.version=1.44" > /home/claude/.docker-java.properties

# Create gradle cache directory
RUN mkdir -p /home/claude/.gradle

# Language runtimes
RUN mise install node@lts && \
    mise use -g --pin node@lts

RUN mise install rust@latest && \
    mise use -g --pin rust@latest

RUN mise install java@oracle-graalvm-25.0.1 && \
    mise use -g --pin java@oracle-graalvm-25.0.1

RUN mise install protoc@latest && \
    mise use -g --pin protoc@latest

# Cargo tools
RUN mise use -g cargo-binstall
RUN mise use -g cargo:cargo-nextest
RUN mise use -g cargo:ast-grep
RUN mise use -g cargo:rust-script
RUN mise use -g cargo:just
RUN mise use -g cargo:shellfirm
RUN mise use -g cargo:tirith
RUN mise use -g cargo:bottom

# Tessl CLI
RUN curl -fsSL https://get.tessl.io | sh

# Global npm packages
RUN mise exec node@lts -- npm install -g ctx7

# SpecStory CLI for session history capture
ARG SPECSTORY_VERSION=1.12.0
RUN ARCH="$(uname -m)" && \
    if [ "$ARCH" = "aarch64" ]; then ARCH="arm64"; fi && \
    curl -fsSL "https://github.com/specstoryai/getspecstory/releases/download/v${SPECSTORY_VERSION}/SpecStoryCLI_Linux_${ARCH}.tar.gz" \
    | tar -xz -C /home/claude/.local/bin specstory
