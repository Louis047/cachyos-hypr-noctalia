# System notes

These are documentation-only records. No `/etc` files are committed to this repository.

Do not copy these blindly onto another machine. Review the target's boot loader, root filesystem, GPU, and initramfs configuration first.

## `/etc/environment`

The font-rendering environment variable used on the snapshot:

```text
FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
```

This disables CFF stem darkening and keeps rendering closer to the intended macOS look. Add it to the target's `/etc/environment` or an equivalent `/etc/environment.d/` drop-in.

## greetd and Plymouth

File:

```text
/etc/systemd/system/greetd.service.d/override.conf
```

Contents:

```ini
[Unit]
After=plymouth-quit.service plymouth-quit-wait.service
Wants=plymouth-quit.service plymouth-quit-wait.service

[Service]
ExecStartPre=/bin/sh -c 'for i in $(seq 1 50); do plymouth --ping >/dev/null 2>&1 || exit 0; sleep 0.2; done'
```

This waits for the Plymouth splash to finish before greetd starts.

## wayland-wheeltani udev rule

File:

```text
/etc/udev/rules.d/60-wayland-wheeltani.rules
```

Contents:

```udev
ACTION!="add|change", GOTO="wayland_wheeltani_end"

KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"

KERNEL=="event[0-9]*", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="04d9", ENV{ID_MODEL_ID}=="fc7a", MODE="0600", TAG+="uaccess"

LABEL="wayland_wheeltani_end"
```

The vendor/product IDs match the configured USB mouse. Adjust them for different hardware.

## initramfs and Plymouth

`/etc/mkinitcpio.conf` on the snapshot used:

```text
MODULES=()
HOOKS=(base systemd autodetect microcode kms modconf block keyboard sd-vconsole plymouth filesystems)
```

Plymouth packages included:

```text
plymouth
cachyos-plymouth-bootanimation
```

Rebuild after changing the initramfs:

```bash
sudo mkinitcpio -P
```

## Boot loader

The snapshot uses **Limine 12.9.4**.

Kernel command line shape:

```text
nowatchdog rw quiet splash rootflags=subvol=/@ root=UUID=<your-root-uuid>
```

The original uses a Btrfs root subvolume named `@`. Replace the UUID and subvolume with the target machine's values. Do not copy the original UUID.

## Pacman repositories

The snapshot uses CachyOS repositories alongside Arch repositories:

- `[cachyos-v3]`
- `[cachyos-extra-v3]`
- `[cachyos-core-v3]`
- `[cachyos]`
- `[core]`
- `[extra]`
- `[multilib]`

The exact mirror lists are machine- and region-specific and are not archived. Follow the current CachyOS installation documentation when rebuilding.

## Session and power-key handling

Hyprland autostart runs:

```lua
hl.exec_cmd("systemd-inhibit --what=handle-power-key --mode=block --who=hyprland --why='compositor owns power key' sleep infinity")
```

This keeps logind from handling the power key so Hyprland can bind it to `lock-suspend.sh`. The lid switch is also bound to the same script.

`~/.config/uwsm/env` sets the Wayland toolkit, VA-API, and cursor environment for the session. It is archived under `home/` and is hardware-specific:

```bash
export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER=radeonsi
```

Adjust these if the target does not use an AMD GPU for video decode.
