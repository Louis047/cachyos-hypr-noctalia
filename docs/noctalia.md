# Noctalia

Snapshot version: **Noctalia v5.4.1** (`noctalia-git`).

## Configuration stack

Noctalia merges configuration in this order:

1. Every `*.toml` in `~/.config/noctalia/`, sorted alphabetically.
2. GUI-managed overrides in `~/.local/state/noctalia/settings.toml`.
3. Internal UI state in `~/.local/state/noctalia/state.toml`.

Because the state file loads last, a GUI change can override a declarative config value. The app-managed state is deliberately **not** restored by this repository.

## What this repo contains

- `home/.config/noctalia/config.toml` is a merged export generated with:
  ```bash
  noctalia config export merged
  ```
- `reference/noctalia-settings.toml` is the raw app-managed state from the snapshot. It is reference material only.
- Noctalia's downloaded plugin caches, community-template catalogs, clipboard history, notification history, and `state.toml` are not included.

The merged export captures the effective user values without the roughly 1,000 lines of built-in defaults.

## Hooks

The power hooks are home-relative and must stay that way:

```toml
[hooks]
battery_charging = "~/.config/hypr/scripts/power-refresh.sh"
battery_discharging = "~/.config/hypr/scripts/power-refresh.sh"
battery_plugged = "~/.config/hypr/scripts/power-refresh.sh"
started = "~/.config/hypr/scripts/power-refresh.sh"
```

Noctalia runs these as shell commands, so `~` expands correctly. Do not replace them with `/home/<user>/...` paths.

## Plugins and templates

The exported config records:

- Plugin source repositories:
  - `noctalia-dev/official-plugins`
  - `noctalia-dev/community-plugins`
- Enabled plugins:
  - `noctalia/notes`
  - `shangshui0302/github-kanban`
  - `thaer99ob/default-apps`
  - `yuuto/calculator`
  - `aristides/udiskie`
- Community palette: `Vesper`
- Built-in templates: `btop`, `gtk3`, `gtk4`, `kcolorscheme`, `kitty`, `qt`
- Community templates: `antigravity`, `opencode`, `zapfast`, `gimp`, `libreoffice`, `micro`, `heroiclauncher`, `obs`, `zathura`, `hyprtoolkit`, `papirus-icons`

Noctalia can re-fetch plugins and template catalogs. The generated outputs that matter for an immediate restore are archived under `home/`:

- GTK 3/4 CSS
- kitty theme
- btop theme
- qt6ct color scheme
- `kdeglobals`
- `hyprtoolkit.conf`
- Papirus folder color
- zathura theme
- Zapfast theme

Regenerating a palette or template in Noctalia may overwrite these files. That is expected.

## Paths

The exported config uses home-relative paths for the avatar and wallpapers:

```toml
avatar_path = "~/Pictures/Profile/luffy_face_transparent.png"
directory = "~/Pictures/Wallpapers"
```

The snapshot also contains an `HDMI-A-1` wallpaper and lock-screen widget. Those are harmless on a laptop-only setup but should be removed if that monitor is not used.

## Validation and reload

```bash
noctalia config validate "$HOME/.config/noctalia/config.toml"
```

Reload the desktop with:

```bash
~/.config/hypr/scripts/reload.sh
```

That script reloads Hyprland and restarts Noctalia.

## Restore caution

- Copy `home/.config/noctalia/config.toml` to `~/.config/noctalia/config.toml`.
- Do **not** copy `reference/noctalia-settings.toml` into the state directory during a normal restore.
- If a restored value appears to be ignored, inspect `~/.local/state/noctalia/settings.toml`; it may contain a newer GUI override.
- Wallpapers and the avatar are not in the repo. See [`assets.md`](assets.md).
