#!/bin/bash

trap 'rm /var/run/hello-rs/running' EXIT
trap 'kill -SIGINT $PID' INT
trap 'kill -SIGTERM $PID' TERM

touch /var/run/hello-rs/running
hello-rs &
PID=$!
wait $PID
