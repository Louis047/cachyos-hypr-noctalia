# Image asset paths

No image files are included in this repository. These are the paths referenced by the snapshot.

## Wallpapers

Default and `eDP-1`:

```text
~/Pictures/Wallpapers/Fractal-Glass/wc-fractal-glass-v1-purple-[5120x2880].png
```

`HDMI-A-1`:

```text
~/Pictures/Wallpapers/Normal Wallpapers/gzml-shell.png
```

The default path also appears as `wallpaper.last` and `wallpaper.default.path` in the Noctalia config.

## Avatar

```text
~/Pictures/Profile/luffy_face_transparent.png
```

## Restore behavior

- Recreate the files at the same paths, or
- Copy different images and update Noctalia's wallpaper/avatar settings.

Quote the wallpaper path in shell commands because it contains square brackets:

```bash
ls -l "$HOME/Pictures/Wallpapers/Fractal-Glass/wc-fractal-glass-v1-purple-[5120x2880].png"
```

The `HDMI-A-1` entries are external-monitor leftovers on a laptop-only setup. Remove or update them if that output is not present.
