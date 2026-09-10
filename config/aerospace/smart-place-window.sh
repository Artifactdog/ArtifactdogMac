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

new_window_id="${AEROSPACE_WINDOW_ID:-}"
[ -n "$new_window_id" ] || exit 0

# A window-detected callback can fire before the new window appears in the
# query output. Wait briefly for its parent container metadata to exist.
window_row=""
parent_layout=""
workspace=""
for _ in $(seq 1 150); do
  window_row="$($AEROSPACE_BIN list-windows --all --format '%{window-id}|%{window-parent-container-layout}|%{workspace}' 2>/dev/null | awk -F '|' -v id="$new_window_id" '$1 == id {print; exit}')"
  if [ -n "$window_row" ]; then
    IFS='|' read -r _ parent_layout workspace <<< "$window_row"
    case "$parent_layout" in
      h_tiles|v_tiles) break ;;
    esac
  fi
  sleep 0.02
done
[ -n "$window_row" ] || exit 0

# A newly created background window can be reported briefly as a hidden-app
# container. Wait until AeroSpace exposes its real tiled parent before using
# join-with; otherwise the callback would permanently miss this placement.
case "$parent_layout" in
  h_tiles|v_tiles) ;;
  *) exit 0 ;;
esac

workspace_window_count="$($AEROSPACE_BIN list-windows --workspace "$workspace" --count 2>/dev/null || printf '0')"
case "$workspace_window_count" in
  ''|*[!0-9]*) exit 0 ;;
esac

# The first two windows establish the horizontal root. From the third window
# onward, join the new leaf with the nearest old leaf in the parent axis. The
# join creates the opposite-axis nested container.
[ "$workspace_window_count" -gt 2 ] || exit 0
case "$parent_layout" in
  h_tiles)
    "$AEROSPACE_BIN" join-with --window-id "$new_window_id" left
    ;;
  v_tiles)
    "$AEROSPACE_BIN" join-with --window-id "$new_window_id" up
    ;;
esac
