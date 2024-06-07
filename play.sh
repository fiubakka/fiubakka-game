#!/bin/bash

start_cloudflared() {
    echo "Starting cloudflared..."
    cloudflared access tcp --hostname fiubakka.marcosrolando.uk --url 127.0.0.1:2020 &
    CLOUDFLARED_PID=$!
    echo "cloudflared started with PID $CLOUDFLARED_PID"
}

stop_cloudflared() {
    echo "Stopping cloudflared..."
    kill $CLOUDFLARED_PID
    echo "cloudflared stopped."
}

run_fiubakka() {
    echo "Starting fiubakka..."
    ./fiubakka &
    FIUBAKKA_PID=$!
    wait $FIUBAKKA_PID
}

# Trap to ensure cloudflared stops when the script exits
trap stop_cloudflared EXIT

start_cloudflared

run_fiubakka

