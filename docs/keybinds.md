# Keybinds

The authoritative source is [`home/.config/hypr/configs/keybinds.lua`](../home/.config/hypr/configs/keybinds.lua). This table is a human-readable summary.

`SUPER` is the main modifier. `ALT` and `CTRL` are used where noted.

## Applications

| Keybind | Action |
|---|---|
| `SUPER + Return` | Open kitty |
| `SUPER + Q` | Close focused window |
| `SUPER + E` | Open Thunar |
| `SUPER + B` | Open Zen Browser |
| `CTRL + Space` | Toggle Noctalia launcher |

## Volume, brightness, and media

| Keybind | Action |
|---|---|
| `XF86AudioRaiseVolume` | Noctalia volume up |
| `XF86AudioLowerVolume` | Noctalia volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle microphone mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |
| `XF86AudioPlay` | Toggle media |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

## Session and power

| Keybind | Action |
|---|---|
| `SUPER + L` | Lock session |
| Lid switch on | `lock-suspend.sh` |
| Lid switch off | DPMS on |
| `XF86PowerOff` | `lock-suspend.sh` |

The Hyprland autostart also starts a `systemd-inhibit` process so the compositor owns the power key.

## Windows

| Keybind | Action |
|---|---|
| `SUPER + T` | Toggle floating, resize to 1280x800, center |
| `SUPER + SHIFT + F` | Toggle true fullscreen |
| `SUPER + F` | Toggle maximized/fullscreen mode |
| `SUPER + P` | Toggle pin |
| `SUPER + V` | Toggle split |
| `SUPER + Tab` | Cycle floating windows and raise the next one |
| `SUPER + Arrow` | Focus in direction |
| `SUPER + SHIFT + Arrow` | Move window in direction |
| `SUPER + CTRL + Arrow` | Resize window by 20 px |
| `SUPER + SHIFT + D` | Move window to next workspace |
| `SUPER + SHIFT + A` | Move window to previous workspace |
| `SUPER + CTRL + D` | Move window to next monitor |
| `SUPER + CTRL + A` | Move window to previous monitor |

## Workspaces

| Keybind | Action |
|---|---|
| `SUPER + 1..5` | Focus workspace 1-5 |
| `SUPER + SHIFT + 1..5` | Move window to workspace 1-5 |
| `SUPER + D` | Cycle to next workspace with windows |
| `SUPER + A` | Cycle to previous workspace with windows |
| `SUPER + S` | Toggle special workspace `magic` |
| `SUPER + SHIFT + S` | Float, resize, center, and move window to `magic` |

Workspaces are persistent for 1-5.

## Mouse

| Keybind | Action |
|---|---|
| `SUPER + left mouse drag` | Move window |
| `SUPER + right mouse drag` | Resize window |

## Reload and zoom

| Keybind | Action |
|---|---|
| `SUPER + SHIFT + R` | Reload Hyprland and restart Noctalia |
| `SUPER + Minus` | Zoom out |
| `SUPER + Plus` | Zoom in |
| `SUPER + keypad minus` | Zoom out |
| `SUPER + keypad plus` | Zoom in |

## Screenshots and recording

| Keybind | Action |
|---|---|
| `ALT + S` | Annotate region, copy and save |
| `ALT + SHIFT + S` | Annotate fullscreen, copy and save |
| `ALT + R` | Toggle region recording |
| `ALT + SHIFT + R` | Toggle fullscreen recording |
| `ALT + T` | OCR region to clipboard |
| `SUPER + SHIFT + B` | Toggle Noctalia bar |
