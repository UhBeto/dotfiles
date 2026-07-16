#!/usr/bin/env bash
set -e

# $1 determines the capture mode
case "$1" in
    region)
        # Uses slurp to select an area
        grim -t ppm -g "$(slurp -d -F monospace)" - | satty --filename -
        ;;
    focused-monitor)
        # Captures the monitor that currently has focus in niri
        grim -o "$(niri msg -j outputs | jq -r '.[] | select(.focused) | .name')" - | satty --filename -
        ;;
    all-monitors)
        # Captures all outputs
        grim - | satty --filename -
        ;;
    *)
        echo "Usage: $0 {region | focused-monitor | all-monitors}"
        exit 1
        ;;
esac
