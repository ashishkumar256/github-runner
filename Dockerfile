FROM ubuntu:22.04

WORKDIR /actions-runner

# Install dependencies as root
RUN apt-get update && apt-get install -y \
    curl jq git tar bash \
    docker.io \
    libicu70 libssl3 libkrb5-3 zlib1g \
    libc6 libgcc-s1 libstdc++6 \
    && rm -rf /var/lib/apt/lists/*
# Create ubuntu user and group
RUN groupadd -r ubuntu && useradd -r -g ubuntu ubuntu

RUN groupmod -g 112 docker && \
    usermod -aG docker ubuntu

# Switch to non-root user for runtime
USER ubuntu

# Download runner binary as root
ARG RUNNER_VERSION=2.336.0
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && chown -R ubuntu:ubuntu /actions-runner

# Copy startup script
COPY startup.sh /actions-runner/startup.sh
# RUN chmod +x /actions-runner/startup.sh && chown ubuntu:ubuntu /actions-runner/startup.sh

ENTRYPOINT ["/actions-runner/startup.sh"]
