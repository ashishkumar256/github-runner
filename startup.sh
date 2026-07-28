#!/bin/bash
set -e

# Required values
if [ -z "$RUNNER_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "ERROR: RUNNER_URL and RUNNER_TOKEN must be set"
  exit 1
fi

# Configure runner unattended
./config.sh \
  --unattended \
  --url "$RUNNER_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --runnergroup "$RUNNER_GROUP" \
  --labels "$RUNNER_LABELS" \
  --replace \
  --work "$RUNNER_WORKDIR"

# Start runner
./run.sh
