#!/usr/bin/env bash
set -euo pipefail

if command -v aerospace >/dev/null 2>&1; then
  AEROSPACE_BIN="$(command -v aerospace)"
elif [ -x /opt/homebrew/bin/aerospace ]; then
  AEROSPACE_BIN=/opt/homebrew/bin/aerospace
elif [ -x /usr/local/bin/aerospace ]; then
  AEROSPACE_BIN=/usr/local/bin/aerospace
else
  exit 1
fi

# exec-and-forget detaches this helper before AeroSpace exits. Ask it to quit
# cleanly first, then fall back to a normal TERM if the app does not leave.
/usr/bin/osascript -e 'tell application "AeroSpace" to quit' >/dev/null 2>&1 || true
for _ in $(seq 1 60); do
  if ! /usr/bin/pgrep -x AeroSpace >/dev/null 2>&1; then
    break
  fi
  /bin/sleep 0.05
done

if /usr/bin/pgrep -x AeroSpace >/dev/null 2>&1; then
  /usr/bin/killall AeroSpace >/dev/null 2>&1 || true
  for _ in $(seq 1 40); do
    if ! /usr/bin/pgrep -x AeroSpace >/dev/null 2>&1; then
      break
    fi
    /bin/sleep 0.05
  done
fi

/usr/bin/open -a AeroSpace

# Wait until the new server accepts a command before restarting the border
# service. AeroSpace's startup hook also starts borders; this final restart
# makes the manual full-stack restart deterministic.
for _ in $(seq 1 80); do
  if "$AEROSPACE_BIN" list-modes >/dev/null 2>&1; then
    break
  fi
  /bin/sleep 0.1
done

bash "$HOME/.config/aerospace/reload-borders.sh" >/dev/null 2>&1 || true
