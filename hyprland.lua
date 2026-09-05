```lua
-- Lubai
-- Mouse-oriented tiling environment
-- Based on the current Hyprland Lua configuration API.

--------------------------------------------------
-- MONITOR
--------------------------------------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


--------------------------------------------------
-- PROGRAMS
--------------------------------------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"


--------------------------------------------------
-- ENVIRONMENT
--------------------------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


--------------------------------------------------
-- LOOK AND FEEL
--------------------------------------------------

hl.config({
    general = {
        -- Lubai spatial language:
        -- every tile is separated by the same 20 px space.
        gaps_in  = 20,
        gaps_out = 20,

        border_size = 0,

        resize_on_border = true,

        allow_tearing = false,

        -- Tiling foundation.
        layout = "dwindle",
    },

    decoration = {
        rounding       = 0,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})


--------------------------------------------------
-- ANIMATIONS
--------------------------------------------------

hl.curve("lubai", {
    type = "bezier",
    points = {
        {0.23, 1},
        {0.32, 1},
    },
})

hl.animation({
    leaf    = "global",
    enabled = true,
    speed   = 10,
    bezier  = "default",
})

hl.animation({
    leaf    = "windows",
    enabled = true,
    speed   = 5,
    spring  = "easy",
})

hl.animation({
    leaf    = "windowsIn",
    enabled = true,
    speed   = 4,
    style   = "popin 87%",
})

hl.animation({
    leaf    = "windowsOut",
    enabled = true,
    speed   = 2,
    style   = "popin 87%",
})

hl.animation({
    leaf    = "fadeIn",
    enabled = true,
    speed   = 2,
})

hl.animation({
    leaf    = "fadeOut",
    enabled = true,
    speed   = 2,
})


--------------------------------------------------
-- DWINDLE
--------------------------------------------------

hl.config({
    dwindle = {
        -- Keep the spatial relationship of existing tiles.
        preserve_split = true,
    },
})


--------------------------------------------------
-- MISC
--------------------------------------------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})


--------------------------------------------------
-- INPUT
--------------------------------------------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- Mouse follows the pointer.
        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})


--------------------------------------------------
-- MAIN MODIFIER
--------------------------------------------------

local mainMod = "SUPER"


--------------------------------------------------
-- KEYBOARD
--------------------------------------------------

-- Terminal
hl.bind(
    mainMod .. " + Q",
    hl.dsp.exec_cmd(terminal)
)

-- Close
hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)

-- File manager
hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(fileManager)
)

-- Launcher
hl.bind(
    mainMod .. " + R",
    hl.dsp.exec_cmd(menu)
)

-- Toggle floating
hl.bind(
    mainMod .. " + V",
    hl.dsp.window.float({
        action = "toggle",
    })
)

-- Toggle split
hl.bind(
    mainMod .. " + J",
    hl.dsp.layout("togglesplit")
)


--------------------------------------------------
-- FOCUS
--------------------------------------------------

hl.bind(
    mainMod .. " + left",
    hl.dsp.focus({
        direction = "left",
    })
)

hl.bind(
    mainMod .. " + right",
    hl.dsp.focus({
        direction = "right",
    })
)

hl.bind(
    mainMod .. " + up",
    hl.dsp.focus({
        direction = "up",
    })
)

hl.bind(
    mainMod .. " + down",
    hl.dsp.focus({
        direction = "down",
    })
)


--------------------------------------------------
-- WORKSPACES
--------------------------------------------------

for i = 1, 10 do
    local key = i % 10

    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({
            workspace = i,
        })
    )

    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i,
        })
    )
end


--------------------------------------------------
-- MOUSE-ORIENTED WINDOW CONTROL
--------------------------------------------------

-- Left mouse + SUPER:
-- freely drag a tile/window.
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
    }
)

-- Right mouse + SUPER:
-- resize the tile from its border.
hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
    }
)


--------------------------------------------------
-- WINDOW RULES
--------------------------------------------------

-- Prevent applications from forcing themselves
-- into a different layout through maximize events.
hl.window_rule({
    name = "suppress-maximize-events",

    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})


-- XWayland drag fix.
hl.window_rule({
    name = "fix-xwayland-drags",

    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


--------------------------------------------------
-- HYPRLAND RUN
--------------------------------------------------

hl.window_rule({
    name = "move-hyprland-run",

    match = {
        class = "hyprland-run",
    },

    move  = "20 monitor_h-120",
    float = true,
})
```
