#!/bin/bash

# Check if PRESET argument is provided
if [ -z "$1" ]; then
    echo "Error: PRESET argument is missing. Must be either 'Linux/X11' or 'Windows'"
    exit 1
fi

# Check if PRESET is either "Linux/X11" or "Windows"
if [ "$1" != "Linux/X11" ] && [ "$1" != "Windows" ]; then
    echo "Error: PRESET must be either 'Linux/X11' or 'Windows'."
    exit 1
fi

# Check if EXPORT_PATH argument is provided
if [ -z "$2" ]; then
    EXPORT_PATH="fiubakka"
else
    EXPORT_PATH="$2"
fi

# Check if VERSION argument is provided
if [ -n "$3" ]; then
    EXPORT_PATH="$EXPORT_PATH-$3"
fi

# Compose EXPORT_PATH
EXPORT_PATH="exported/$EXPORT_PATH"

godot --export-release $1 $EXPORT_PATH

