# Artifactdog's macOS setup — hotkeys

Keep **Caps Lock** held while pressing the second key. Karabiner turns Caps
Lock into the Hyper modifier:

`Control + Option + Command`

AeroSpace owns tiling, focus, workspaces, and these bindings. The native macOS
menu bar remains enabled. Raycast keeps its own **Caps + Space** binding.

The separate **Globe/Fn** key remains a macOS input-source switch; it is not
part of the Caps Lock Hyper modifier.

Hold **Caps Lock first**, then hold **Tab**, then press the shortcut key for the
Tab layer. Normal Tab behavior is unchanged when Caps Lock is not held. The
original Caps+Shift combinations remain available as an alternate path.

## Window and app control

| Hotkey | Action |
|---|---|
| **Caps + W** | Close the focused window; quit the app if it was that app's last window |
| **Caps + Q** | Quit the application owning the focused window |
| **Caps + F** | AeroSpace fullscreen with border clearance, without creating a separate macOS Space |
| **Caps + Tab + F** | Native macOS fullscreen; removes the title bar and fills the display |
| **Caps + Tab + E** | Toggle floating / tiled |
| **Caps + Enter** | Open a new Ghostty window with smart alternating BSP placement |
| **Caps + N** | Open a new Finder window at the home folder |
| **Caps + Space** | Open Raycast (Raycast-owned binding) |

W is the normal close action. When it closes an app's last known window,
AeroSpace also quits that app, preventing headless terminal processes from
accumulating. Ghostty's close confirmation is disabled because this is an
intentional terminal-close workflow; running processes in that terminal are
terminated immediately. Q is the explicit whole-application quit action.
Background/menu-bar apps with no focused window are not targeted.

The float/tile toggle is on Caps+Tab+E; physical Caps+Shift+E remains an
alternate path for the same action.

## Focus and move windows

Mouse focus is disabled: moving the pointer over a tiled window does not make
it active.

| Hotkey | Action |
|---|---|
| **Caps + I** | Focus up |
| **Caps + J** | Focus left |
| **Caps + K** | Focus down |
| **Caps + L** | Focus right |
| **Caps + Tab + I/J/K/L** | Move the focused window up / left / down / right |

The Ghostty launcher is deliberately BSP-like. The first two terminals create
a left/right root. After that, the new terminal is split inside whichever pane
was focused, using the opposite axis of that pane's parent. Therefore a
focused left or right pane gets its new terminal below it; the next launch
alternates to the other axis inside the newly focused pane. A lock and a short
window-appearance wait make rapid Caps+Enter presses serialize instead of
repeating the same split.

Other applications opened outside Caps+Enter pass through AeroSpace's
new-window callback: ordinary windows are forced into the tiling tree, then
Finder and similar apps receive the same focused-pane placement pass.
System Settings, Calculator, Karabiner-Elements, and Raycast remain
intentionally floating because they are utility panels rather than workspace
windows.

## Workspaces and monitors

AeroSpace uses its own virtual workspaces. The number bindings focus or move
windows to workspaces 1–6; the native macOS menu bar stays untouched and no
custom Space indicator is used.

| Hotkey | Action |
|---|---|
| **Caps + 1…6** | Focus AeroSpace workspace 1–6 |
| **Caps + Tab + 1…6** | Send the focused window to workspace 1–6 |
| **Caps + P** | Switch to the previous workspace |
| **Caps + D** | Move the focused window to the next display and focus it |
| **Caps + Tab + D** | Move the current workspace to the next display |

## Layout and resizing

| Hotkey | Action |
|---|---|
| **Caps + B** | Balance tile sizes |
| **Caps + T** | Cycle tile orientation |
| **Caps + A** | Restore the regular tile layout |
| **Caps + S** | Enter resize mode |
| **I/J/K/L** in resize mode | Resize up / left / down / right |
| **S / B** in resize mode | Adjust the focused split smaller / bigger |
| **R** in resize mode | Return to normal mode |

Non-letter triggers are the workspace numbers, **Space** for Raycast, and
**Enter** for Ghostty.

## If something feels wrong

1. Check that Karabiner's Hyper rule is enabled.
2. Check that **AeroSpace** is enabled under **System Settings → Privacy &
   Security → Device Control and Data Access** (called **Accessibility** on
   older macOS versions).
3. Check AeroSpace's state:

   ```bash
   aerospace list-windows --all
   aerospace list-workspaces --all
   ```

4. Reload the manager and borders:

   ```bash
   aerospace reload-config
   brew services restart borders
   ```
