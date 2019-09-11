#!/usr/bin/env bash

promConfig="$(pwd)/prometheus.yml"
promContainerName="prometheus-server"
grafanaContainerName="grafana-server"
echo "Initializing Prometheus"
if test -f "$promConfig"; then
    echo "Found prometheus.yml file in working dir"

    read -p "This will remove stored docker container w. name: $promContainerName, Proceed? " -n 1 -r
    echo    # move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      echo "Attempting to remove any previous containers"
      docker container rm -f $promContainerName
      docker container rm -f $grafanaContainerName
      echo "Attempting to start prometheus using docker on port 9090"
      docker container run -d \
          -p 9090:9090 \
          -v $promConfig:/etc/prometheus/prometheus.yml --name $promContainerName \
          prom/prometheus
      docker run -d -p 3000:3000 grafana/grafana --name $grafanaContainerName
    else
      echo "Aborting..."
    fi

    
    echo "Edit prometheus.yml for config-changes!"
    echo "Prometheus server started, hit CTRL+C to exit"
    trap ctrl_c INT

    function ctrl_c() {
      echo "Stopping Prometheus"
      docker stop $promContainerName
      docker stop $grafanaContainerName
      exit 0
    }

    # Wait forever
    read -r -d '' _ </dev/tty
else
    echo "No prometheus.yml file found in working dir! Aborting..."
fi
