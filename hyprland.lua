-- SplayDE
-- Mouse-oriented tiling environment
--
-- Hyprland is the compositor and tiling/layout backend.
-- Splay is the spatial interaction layer.


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = terminal .. " -e yazi"
local launcher    = terminal .. " -e fsel"


--------------------------------
---- ENVIRONMENT VARIABLES ----
--------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- LOOK AND FEEL ---
-----------------------

hl.config({
    general = {
        -- Splay spatial unit.
        gaps_in  = 10,
        gaps_out = 20,

        -- No visible Hyprland borders.
        -- Splay uses the spatial separation between tiles.
        border_size = 0,

        -- Hyprland handles native tile resizing.
        resize_on_border = true,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
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


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint", {
    type = "bezier",
    points = {
        {0.23, 1},
        {0.32, 1},
    },
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = {
        {0.65, 0.05},
        {0.36, 1},
    },
})

hl.curve("linear", {
    type = "bezier",
    points = {
        {0, 0},
        {1, 1},
    },
})

hl.curve("almostLinear", {
    type = "bezier",
    points = {
        {0.5, 0.5},
        {0.75, 1},
    },
})

hl.curve("quick", {
    type = "bezier",
    points = {
        {0.15, 0},
        {0.1, 1},
    },
})

hl.curve("easy", {
    type = "spring",
    mass = 1,
    stiffness = 238.1191,
    dampening = 24.21279333,
})


hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    spring = "easy",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    spring = "easy",
    style = "popin 87%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3.03,
    bezier = "quick",
})

hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})

hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 7,
    bezier = "quick",
})


--------------------
---- DWINDLE -------
--------------------

hl.config({
    dwindle = {
        -- Preserve the spatial subdivision tree.
        preserve_split = true,
    },
})


---------------------
---- INPUT ---------
---------------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})


----------------
---- MISC ------
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
    },
})


--------------------------------
---- SPLAY ---------------------
--------------------------------

local splay = {
    -- The visual separation between adjacent tiles is 20 px.
    gap = 20,

    -- Each adjacent tile owns half of the gap.
    -- Therefore Splay considers 10 px of the gap to belong
    -- to each neighboring tile.
    edge = 10,

    -- Maximum interval between the two clicks.
    double_click_time = 250,

    -- State of the current click sequence.
    waiting_second_click = false,
    first_direction = nil,
}


---------------------------
---- SPLAY GEOMETRY -------
---------------------------

-- Returns the distance from a point to each side of a window.
local function window_edge_distances(window, cursor)
    local left   = cursor.x - window.at.x
    local right  = (window.at.x + window.size.x) - cursor.x
    local top    = cursor.y - window.at.y
    local bottom = (window.at.y + window.size.y) - cursor.y

    return {
        left   = left,
        right  = right,
        top    = top,
        bottom = bottom,
    }
end


-- Determines which tile owns the cursor position.
--
-- A tile owns:
--
--     10 px inside its own edge
--     +
--     10 px of the adjacent 20 px gap
--
-- This means neighboring tiles meet exactly at the
-- midpoint of the visual gap.
local function get_splay_target()
    local cursor = hl.get_cursor_pos()

    if cursor == nil then
        return nil
    end

    local windows = hl.get_windows()

    if windows == nil then
        return nil
    end

    local best_window = nil
    local best_direction = nil
    local best_distance = math.huge

    for _, window in ipairs(windows) do
        if
            window ~= nil
            and not window.floating
            and window.at ~= nil
            and window.size ~= nil
        then

            local d = window_edge_distances(window, cursor)

            local candidates = {
                {
                    direction = "l",
                    distance = math.abs(d.left),
                    valid = d.left >= -splay.edge,
                },
                {
                    direction = "r",
                    distance = math.abs(d.right),
                    valid = d.right >= -splay.edge,
                },
                {
                    direction = "u",
                    distance = math.abs(d.top),
                    valid = d.top >= -splay.edge,
                },
                {
                    direction = "d",
                    distance = math.abs(d.bottom),
                    valid = d.bottom >= -splay.edge,
                },
            }

            for _, candidate in ipairs(candidates) do
                if candidate.valid and candidate.distance <= splay.edge then
                    if candidate.distance < best_distance then
                        best_window = window
                        best_direction = candidate.direction
                        best_distance = candidate.distance
                    end
                end
            end
        end
    end

    if best_window == nil then
        return nil
    end

    return {
        window = best_window,
        direction = best_direction,
    }
end


---------------------------
---- SPLAY ACTION ---------
---------------------------

local function splay_create_tile()
    local target = get_splay_target()

    if target == nil then
        splay.waiting_second_click = false
        splay.first_direction = nil
        return
    end

    local direction = target.direction

    -- First click.
    if not splay.waiting_second_click then
        splay.waiting_second_click = true
        splay.first_direction = direction

        hl.timer(
            function()
                splay.waiting_second_click = false
                splay.first_direction = nil
            end,
            {
                timeout = splay.double_click_time,
                type = "oneshot",
            }
        )

        return
    end


    -- Second click must correspond to the same edge.
    if splay.first_direction ~= direction then
        splay.first_direction = direction
        return
    end


    splay.waiting_second_click = false
    splay.first_direction = nil


    --------------------------------
    -- Tell Dwindle where to split.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- A Splay tile is a real window.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )
end


---------------------------
---- SPLAY MOUSE ----------
---------------------------

-- Left click on a tile edge.
--
-- Splay interprets two consecutive clicks
-- on the same edge as the "create tile" gesture.
hl.bind(
    "mouse:272",
    splay_create_tile,
    {
        mouse = true,
        click = true,
    }
)


---------------------------
---- KEYBINDINGS ----------
---------------------------

local mainMod = "SUPER"


---------------------------
---- APPLICATIONS --------
---------------------------

-- Open terminal.
hl.bind(
    mainMod .. " + Q",
    hl.dsp.exec_cmd(terminal)
)

-- Open file manager.
-- Yazi is a TUI and runs inside Ghostty.
hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(fileManager)
)

-- Open application launcher.
-- fsel is currently a placeholder launcher for SplayDE.
hl.bind(
    mainMod .. " + R",
    hl.dsp.exec_cmd(launcher)
)

-- Close current tile/window.
hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)


---------------------------
---- WINDOW BEHAVIOUR ----
---------------------------

-- Temporary escape hatch while Splay is being developed.
hl.bind(
    mainMod .. " + V",
    hl.dsp.window.float({
        action = "toggle",
    })
)

-- Toggle the current Dwindle split.
hl.bind(
    mainMod .. " + J",
    hl.dsp.layout("togglesplit")
)


---------------------------
---- FOCUS ---------------
---------------------------

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


---------------------------
---- WORKSPACES -----------
---------------------------

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


---------------------------
---- MOUSE ----------------
---------------------------

-- SUPER + left mouse:
-- move the current tile/window.
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
    }
)

-- SUPER + right mouse:
-- resize the current tile/window.
hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
    }
)


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore application maximize requests.
hl.window_rule({
    name = "suppress-maximize-events",

    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})


-- Fix XWayland dragging issues.
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


-- Hyprland-run window.
hl.window_rule({
    name = "move-hyprland-run",

    match = {
        class = "hyprland-run",
    },

    move  = "20 monitor_h-120",
    float = true,
})
