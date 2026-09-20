# jellicrt — CRT filter for Jellium Desktop

*Read this in [Ukrainian](README.md).*

Gives Jellium that cozy CRT look (scanlines + shadow mask, flat screen —
no curved edges) with a single `jellicrt` command.

## Install

By hand, it's only four files. In `mpv.conf`, substitute your home path for `__HOME__`:

```bash
mkdir -p ~/.config/jellium-desktop/mpv/shaders ~/.config/fish/functions
sed "s|__HOME__|$HOME|" mpv.conf > ~/.config/jellium-desktop/mpv/mpv.conf
cp shaders/crt-lottes.glsl ~/.config/jellium-desktop/mpv/shaders/
cp toggle-crt.sh ~/.config/jellium-desktop/mpv/ && chmod +x ~/.config/jellium-desktop/mpv/toggle-crt.sh
cp fish-functions/jellicrt.fish ~/.config/fish/functions/
```

You need `socat` (`sudo pacman -S socat`). Restart Jellium after installing.

## Usage

- `jellicrt` — toggle the filter on/off
- the filter is off by default, enabled only manually
- want it auto-loaded at startup? Uncomment `glsl-shaders` in `~/.config/jellium-desktop/mpv/mpv.conf`

## What's inside

| File | Goes to | Why |
|---|---|---|
| `mpv.conf` | `~/.config/jellium-desktop/mpv/` | Control socket + shader off by default |
| `shaders/crt-lottes.glsl` | `.../mpv/shaders/` | The filter itself, mpv port, curvature removed |
| `toggle-crt.sh` | `.../mpv/` | Toggle via the mpv IPC socket |
| `fish-functions/jellicrt.fish` | `~/.config/fish/functions/` | Short terminal command |

## Why so involved instead of a simple input.conf bind

Three rakes we already stepped on:

1. Jellium only reads configs from `~/.config/jellium-desktop/mpv/`, plain `~/.config/mpv/` is ignored.
2. Keyboard input in Jellium is eaten by CEF and never reaches mpv — binds in `input.conf` don't work.
3. mpv rejects RetroArch shaders (`#pragma parameter`, `MVPMatrix`) — it needs the `//!HOOK` format.

So: the shader loads via `mpv.conf`, and toggling happens from the outside through the IPC socket.
