#!/usr/bin/env bash

promConfig="$(pwd)/prometheus.yml"
echo "Initializing Prometheus"
if test -f "$promConfig"; then
    echo "Found prometheus.yml file in working dir"

    prometheus --config.file=$promConfig
else
    echo "No prometheus.yml file found in working dir! Aborting..."
fi
