#!/bin/bash
pkill -f 'waybar -c .*config$' || waybar -c "$HOME/.config/waybar/config"
