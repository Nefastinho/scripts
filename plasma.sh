#!/bin/bash

dbus-monitor --session "type='signal',interface='org.freedesktop.ScreenSaver'" |
while read x; do
    case "$x" in
        *"boolean true"*) echo SCREEN_LOCKED;; 
        *"boolean false"*) killall plasmashell | kstart plasmashell;;
    esac
done