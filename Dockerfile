FROM ubuntu:22.04

# Create user/group
RUN groupadd -r ubuntu && \
    useradd -r -g ubuntu -d /actions-runner -m ubuntu

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl jq git tar bash \
    docker.io \
    libicu70 libssl3 libkrb5-3 zlib1g \
    libc6 libgcc-s1 libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

ARG DOCKER_GID=112
RUN groupmod -g ${DOCKER_GID} docker && \
    usermod -aG docker ubuntu

COPY startup.sh /actions-runner/startup.sh
RUN chown ubuntu:ubuntu /actions-runner/startup.sh

# Switch to ubuntu
USER ubuntu

WORKDIR /actions-runner

COPY startup.sh startup.sh

ARG RUNNER_VERSION=2.336.0

RUN curl -L \
      -o runner.tar.gz \
      https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
 && tar xzf runner.tar.gz \
 && rm runner.tar.gz

ENTRYPOINT ["/actions-runner/startup.sh"]
