--[[ 
#########
# INIT #
#########
--]]
Layout = {
    DWINDLE  = "dwindle",
    MASTER   = "master"
}
RiseAndFall = {
    UP = "rise",
    DOWN = "fall"
}
Now_layout = Layout.DWINDLE
Aopacity = 0.8
Popacity = 0.4
defaultOutsideGap = {top = 5, right = 5, bottom = 5, left = 5}
changeableOutsideGap = {top = 34, left = 5, right = 5, bottom = 5} -- change by rust script
--[[ 
################
# Default Apps #
################
--]]
terminal = "kitty"
fileManager = "dolphin"
menu = "wofi --show drun"

--[[ 
#########
# MODS #
#########
--]]
function switch_layout()
    if Now_layout == Layout.DWINDLE then
        Now_layout = Layout.MASTER
    else
        Now_layout = Layout.DWINDLE
    end
    hl.config({
        general = {
            layout = Now_layout,
        },
    })
end
function change_opacity(now_op, raf)
    if raf == RiseAndFall.UP and now_op < 1.0 then
        if now_op == Aopacity then
            Aopacity = now_op + 0.1
        else
            Popacity = now_op + 0.1 end
    end
    if raf == RiseAndFall.DOWN and now_op > 0.0 then
        if now_op == Aopacity then
            Aopacity = now_op - 0.1
        else
            Popacity = now_op - 0.1 end
    end 
    hl.config({
        decoration = {
            active_opacity = Aopacity,
            inactive_opacity = Popacity
        }})
end
function default_something()
    changeableOutsideGap = {
        top = defaultOutsideGap.top,
        right = defaultOutsideGap.right,
        bottom = defaultOutsideGap.bottom,
        left = defaultOutsideGap.left
    }
    hl.config({
        general = {
            gaps_out = changeableOutsideGap
        }
    })
end

--[[ 
###############################
# Auto Start Things When Boot #
###############################
--]]
hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar -c /home/tamettu_mushroom/.config/waybar/nowMusic/nowMusicIdle.jsonc -s /home/tamettu_mushroom/.config/waybar/nowMusic/nowMusicIdle.css")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("kitty")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("waybar -c /home/tamettu_mushroom/.config/waybar/Default/DefaultBase.jsonc -s /home/tamettu_mushroom/.config/waybar/Default/DefaultBase.css")
    default_something()
end)



--[[ 
#########
# Binds #
#########
--]]
-- Add by Myself
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"), { release = true })
hl.bind("SUPER + SHIFT + P", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER +SHIFT + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind("ALT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind("SUPER + H + D", hl.dsp.exec_cmd("hyprpaper"))
hl.bind("SUPER + H + L", hl.dsp.exec_cmd("hyprpaper -c /home/tamettu_mushroom/.config/hypr/hyprpaperLive.conf"))
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd('sh -c "pkill wayvibes || (cd ~/.config/wayvibes && wayvibes --background)"'))
hl.bind("SUPER + ALT+ L", switch_layout)
hl.bind("SUPER + ALT + mouse_down", function() change_opacity(Aopacity,RiseAndFall.UP) end, {mouse = true})
hl.bind("SUPER + ALT + mouse_up", function() change_opacity(Aopacity,RiseAndFall.DOWN) end, {mouse = true})
hl.bind("SUPER + SHIFT + mouse_down", function() change_opacity(Popacity,RiseAndFall.UP) end, {mouse = true})
hl.bind("SUPER + SHIFT + mouse_up", function() change_opacity(Popacity,RiseAndFall.DOWN) end, {mouse = true})

-- Hyprland Important
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.window.close())
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + P", hl.dsp.layout("pseudo")) 
hl.bind("SUPER + J", hl.dsp.layout("togglesplit")) 

hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

hl.bind("SUPER + S", hl.dsp.focus({ workspace = "special:magic", toggle = true }))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { repeat_press = true, locked = true }))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { repeat_press = true, locked = true }))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { repeat_press = true, locked = true }))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { repeat_press = true, locked = true }))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+", { repeat_press = true, locked = true }))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-", { repeat_press = true, locked = true }))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--[[ 
#############
# Win Rules #
#############
--]]
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize"
})
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    float = true,
    move = "20 monitor_h-120"
})
hl.window_rule({
    name = "remove-game-opacity",
    match = { class = "^steam_app_.*" },
    opacity = "1.0 1.0 override"
})

--[[ 
##########
# Config #
##########
--]]
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0.5,

        touchpad = {
            natural_scroll = false,
        },
    },
    cursor = {
    no_hardware_cursors = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    animations = {
        enabled = true,
        bezier = {
            { "easeOutQuint", 0.23, 1, 0.32, 1 },
            { "easeInOutCubic", 0.65, 0.05, 0.36, 1 },
            { "linear", 0, 0, 1, 1 },
            { "almostLinear", 0.5, 0.5, 0.75, 1 },
            { "quick", 0.15, 0, 0.1, 1 },
        },
        animation = {
            { "global", true, 10, "default" },
            { "border", true, 5.39, "easeOutQuint" },
            { "windows", true, 4.79, "easeOutQuint" },
            { "windowsIn", true, 4.1, "easeOutQuint", "popin 87%" },
            { "windowsOut", true, 1.49, "linear", "popin 87%" },
            { "fadeIn", true, 1.73, "almostLinear" },
            { "fadeOut", true, 1.46, "almostLinear" },
            { "fade", true, 3.03, "quick" },
            { "layers", true, 3.81, "easeOutQuint" },
            { "layersIn", true, 4, "easeOutQuint", "fade" },
            { "layersOut", true, 1.5, "linear", "fade" },
            { "fadeLayersIn", true, 1.79, "almostLinear" },
            { "fadeLayersOut", true, 1.39, "almostLinear" },
            { "workspaces", true, 1.94, "almostLinear", "fade" },
            { "workspacesIn", true, 1.21, "almostLinear", "fade" },
            { "workspacesOut", true, 1.94, "almostLinear", "fade" },
            { "zoomFactor", true, 7, "quick" },
        },
    },
    general = {
        gaps_in = 3,
        gaps_out = changeableOutsideGap,
        border_size = 3,

        ["col.active_border"] = "rgb(efcfe3)",
        ["col.inactive_border"] = "rgb(1c0333)",

        resize_on_border = false,
        allow_tearing = false,
        layout = Now_layout,
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity = Aopacity,
        inactive_opacity = Popacity,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

--[[ 
#########
# Mon #
#########
--]]
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

--[[ 
#########
# ENVS #
#########
--]]
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_SESSION_TYPE","wayland")
hl.env("GBM_BACKEND","nvidia-drm")
hl.env("WLR_NO_HARDWARE_CURSORS","1")
hl.env("NVD_BACKEND","direct")
hl.env("XCURSOR_SIZE","24")
hl.env("HYPRCURSOR_SIZE","24")
