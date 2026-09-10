#!/usr/bin/env bash
set -euo pipefail

app_name="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -n 1)"

# Do not send quit to desktop/background processes if focus briefly reports a
# system window while the user is switching workspaces or monitors.
case "$app_name" in
  ""|AeroSpace|Dock|SystemUIServer|ControlCenter|NotificationCenter|WindowManager)
    exit 0
    ;;
esac

/usr/bin/osascript - "$app_name" <<'APPLESCRIPT'
on run argv
  set appName to item 1 of argv
  tell application appName to quit
end run
APPLESCRIPT
