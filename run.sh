#!/usr/bin/env bash

dbus-run-session bash -c 'dbus-update-activation-environment WAYLAND_DISPLAY=wayboard-0 QT_QPA_PLATFORM=wayland GDK_BACKEND=wayland; ./build/wayboard'
