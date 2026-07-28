FROM ubuntu:22.04

WORKDIR /actions-runner

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl jq git tar bash \
    libicu70 libssl3 libkrb5-3 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Download runner binary
ARG RUNNER_VERSION=2.336.0
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Copy startup script
COPY startup.sh /actions-runner/startup.sh
RUN chmod +x /actions-runner/startup.sh

ENTRYPOINT ["/actions-runner/startup.sh"]
