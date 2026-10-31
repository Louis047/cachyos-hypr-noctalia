hl.config({
    render = {
        direct_scanout = 2,
    },
    ecosystem = {
        no_donation_nag = true,
        no_update_news = true,
    },
    general = {
        gaps_in = 6,
        gaps_out = 12,
        col = {
            active_border = "rgba(434343ff)",
            inactive_border = "rgba(555555ff)"
        },
        allow_tearing = true,
    },
    decoration = {
        rounding = 8,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        blur = {
            enabled = true,
            size = 8,
            passes = 1,
            new_optimizations = true,
            xray = true,
        },

        shadow = {
            range = 24,
            render_power = 2,
            offset = { 0, 6 },
            color = "rgba(00000059)",
            color_inactive = "rgba(00000059)",
        },
    },
    input = {
        sensitivity = -0.075,
        accel_profile = "flat",
        numlock_by_default = true,
        repeat_rate = 30,
        repeat_delay = 175,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.65,
            drag_lock = 2,
        },
    },
    gestures = {
        workspace_swipe_min_speed_to_force = 20,
    },
    misc = {
        disable_hyprland_logo = true,
        middle_click_paste = false,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        background_color = 0x000000,
        key_press_enables_dpms = true,
    },
    xwayland = {
        enabled = false,
    },
    cursor = {
        no_hardware_cursors = 0,
        inactive_timeout = 3,
    },
    dwindle = {
        preserve_split = true,
        force_split = 2
    }
})

-- Curves: slideCurve for window motion, fadeCurve (linear) for fades.
-- "smooth" kept for the border animation only.
hl.curve("smooth", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("slideCurve", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("fadeCurve", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
-- Bare "slide" = dynamic nearest-monitor-edge, symmetric for open/close.
-- Per-window popin/slide overrides live in configs/animations.lua.
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "slideCurve", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "slideCurve", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "slideCurve", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.5, bezier = "slideCurve" })
-- fadeOut must stay enabled: with it off, closing windows warp alpha 1->0
-- instantly and the slide-out is invisible.
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "fadeCurve" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.8, bezier = "fadeCurve" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "fadeCurve" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 1.5, bezier = "fadeCurve" })
hl.animation({ leaf = "fadeDim", enabled = false })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "slideCurve", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "slideCurve", style = "slide" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.8, bezier = "fadeCurve" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "fadeCurve" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "slideCurve", style = "slide" })
hl.animation({ leaf = "fadeSwitch", enabled = false })
-- Workspace close anims mirror open ones: Out "slide top" exits through the
-- bottom edge, matching In "slide bottom".
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2.5, bezier = "slideCurve", style = "slide bottom" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2.5, bezier = "slideCurve", style = "slide top" })

-- Touchpad per-device overrides
hl.device({ name = "elan1203:00-04f3:307a-touchpad", sensitivity = 0.15, accel_profile = "adaptive" })
hl.device({ name = "elan1203:00-04f3:307a-mouse", sensitivity = 0.15, accel_profile = "adaptive" })

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "special", workspace_name = "magic" })
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "magic" })
