# Automatically start labwc when logging in
[ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && /home/jj/bin/labwc/0.9.2/build/labwc &
