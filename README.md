# cachyos-hypr-noctalia

Configuration-only snapshot of a CachyOS laptop desktop built around **Hyprland** and **Noctalia**, with GTK/Qt theming, fontconfig, kitty, and laptop-aware power management.

> This is an archival snapshot, not an installer. Review the files before copying them back.

## Snapshot

| Item | Value |
|---|---|
| Date | 2026-10-31 |
| OS | CachyOS (Arch-based, rolling) |
| Kernel | 7.3.0-4-cachyos |
| Compositor | Hyprland 0.57.0, Lua config |
| Shell/panel | Noctalia 5.4.1 |
| Terminal | kitty 0.49.2 |
| Login shell | zsh |
| Hardware | AMD Ryzen 7 5800H; Radeon iGPU + NVIDIA RTX 3060 Mobile; 1920x1080 eDP-1 |

The setup is optimized for this laptop. The AC/battery refresh-rate switching in `power-refresh.sh` is intentionally laptop-specific.

## Layout

```text
home/    Files destined for $HOME, preserving their relative paths
```

The repository intentionally contains only configuration and supporting scripts. Package manifests, restore documentation, reference data, wallpapers, avatars, and generated Noctalia theme outputs are not included.

## Restore

Back up the existing configuration first, then copy the snapshot into place:

```bash
cp -a home/. "$HOME/"
```

One application needs a literal absolute path. Replace the `__HOME__` token in Shelly's config:

```bash
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/shelly/config.json"
```

Noctalia hooks are already home-relative and must remain that way:

```toml
[hooks]
battery_charging = "~/.config/hypr/scripts/power-refresh.sh"
battery_discharging = "~/.config/hypr/scripts/power-refresh.sh"
battery_plugged = "~/.config/hypr/scripts/power-refresh.sh"
started = "~/.config/hypr/scripts/power-refresh.sh"
```

## Theme outputs

Noctalia-generated files such as GTK CSS, the kitty color theme, btop theme, Qt color scheme, KDE colors, and Zathura theme are deliberately omitted. Noctalia regenerates them from the palette and template IDs in `home/.config/noctalia/config.toml`.

The hand-maintained kitty configuration itself is included at `home/.config/kitty/kitty.conf`.

## Notes

- Wallpapers and the avatar are not included. Recreate them under `~/Pictures` or update Noctalia's paths after restoring.
- The monitor configuration targets `eDP-1` and is updated by `power-refresh.sh`.
- `wayland-wheeltani` was installed from Cargo rather than pacman; install it separately if you restore that user service.
- System-level configuration under `/etc` is not included.

## License

MIT. See [`LICENSE`](LICENSE).
