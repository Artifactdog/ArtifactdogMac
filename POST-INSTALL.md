# Artifactdog's macOS setup — install and finish

For the compact everyday reference, see [HOTKEYS.md](HOTKEYS.md). For the
one-command install, see [README.md](README.md).

## 1. Run the installer

From this folder:

```bash
./install.sh
```

The installer installs dependencies from `Brewfile`, backs up existing
managed files to the printed backup folder, applies the repository config, and
keeps the native macOS menu bar. It removes the old Yabai/skhd and custom
Space-indicator files when they are present.

## 2. Complete the required macOS steps

### Enable the Hyper key

Open **Karabiner-Elements → Complex Modifications → Add predefined rule** and
enable:

**Caps Lock → Hyper (Control + Option + Command)**

Caps is now the Linux-style **Super/Hyper** key. Grant Karabiner any
permissions macOS asks for, including its Accessibility/Input Monitoring or
driver prompts.

### Give AeroSpace and JankyBorders permission

Open **System Settings → Privacy & Security** and enable **AeroSpace** in the
permission panel macOS shows for it—usually **Accessibility**, or
**Device Control and Data Access** on some macOS builds. If macOS names a
different permission for JankyBorders, approve that one as well.

No SIP change is required. This setup has no Yabai scripting addition, skhd
daemon, or custom native Space indicator.

### Keep Globe for language switching

The installer sets the separate **Globe/Fn** key to **Change Input Source**.
If it still shows Emoji & Symbols or does nothing, open **System Settings →
Keyboard → Press Globe key to** and choose **Change Input Source**, then log
out and back in if macOS has not applied the change yet. This setting is
independent of the Caps Lock Hyper mapping.

## 3. Prepare displays

AeroSpace workspaces are virtual workspaces, so they do not require creating
six native Spaces in Mission Control. Keep **Displays have separate Spaces**
enabled for standard macOS display behavior.

The native macOS menu bar remains enabled. No extra menu-bar helper is
installed.

## 4. Transparent terminal

Ghostty is configured with 86% background opacity, native blur, and a
transparent macOS titlebar. Its close confirmation is disabled because the
configured Caps+W action intentionally closes the last terminal and quits
Ghostty. Fully quit and reopen Ghostty after installation so the setting is
applied to new windows.

## 5. Verify the setup

```bash
aerospace --version
borders --version
aerospace list-windows --all
aerospace list-workspaces --all
aerospace reload-config
brew services restart borders
```

Open Ghostty with **Caps + Enter** several times. The first two windows should
be side by side; each later window should split the currently focused pane on
the opposite axis, producing the alternating BSP/grid effect. The launcher
serializes rapid presses so a burst does not repeat the same orientation.

Apps opened from Finder, the Dock, or their own menus are handled by the same
new-window callback. Normal app windows are forced into the tiling tree and
placed beside the focused pane; System Settings, Calculator,
Karabiner-Elements, and Raycast stay floating by design.

Equal 12px inner and side/bottom gaps and a 7px top gap remain in effect.
JankyBorders draws the colored 7px active/inactive outlines.

## Config locations

The installer applies these project files to the live setup:

```text
~/.config/aerospace/aerospace.toml
~/.config/aerospace/quit-focused-app.sh
~/.config/aerospace/open-finder.sh
~/.config/aerospace/reload-borders.sh
~/.config/aerospace/restart-window-stack.sh
~/.config/aerospace/smart-open-ghostty.sh
~/.config/aerospace/smart-place-window.sh
~/.config/borders/bordersrc
~/.config/ghostty/config
~/.config/karabiner/assets/complex_modifications/artifactdog-hyper.json
```

AeroSpace handles tiling, focus, workspaces, and hotkeys. JankyBorders is a
separate visual layer for the colored borders. Ghostty supplies the transparent
terminal styling. The current workspaces are AeroSpace virtual workspaces, not
native macOS Spaces; a tiny inactive-window corner can therefore remain
visible on some macOS versions.
