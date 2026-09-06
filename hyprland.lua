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
---- SPLAY STATE ---------------
--------------------------------

-- First click arms an edge.
local splay_click_pending = false
local splay_click_direction = nil

-- Becomes true when Splay has requested a new window.
--
-- The window.open event consumes this flag and collapses
-- the newly-created tile to its minimum spatial size.
local splay_spawn_pending = false
local splay_spawn_direction = nil

-- Signals that the next mouse bind invocation should
-- start the native Hyprland resize operation.
local splay_new_tile = false


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

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

        border_size = 0,

        -- Native Hyprland resizing.
        resize_on_border = true,
        extend_border_grab_area = 10,

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
    speed = 3,
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

    binds = {
        drag_threshold = 10,

        -- Allow normal mouse interaction to continue
        -- when Splay has a mouse bind active.
        pass_mouse_when_bound = true,
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


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"


---------------------------
---- APPLICATIONS --------
---------------------------

hl.bind(
    mainMod .. " + Q",
    hl.dsp.exec_cmd(terminal)
)

hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(fileManager)
)

hl.bind(
    mainMod .. " + R",
    hl.dsp.exec_cmd(launcher)
)

hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)


---------------------------
---- WINDOW BEHAVIOUR ----
---------------------------

hl.bind(
    mainMod .. " + V",
    hl.dsp.window.float({
        action = "toggle",
    })
)

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


--------------------------------
---- SPLAY EDGE DETECTION ------
--------------------------------

local function get_splay_edge()

    local cursor = hl.get_cursor_pos()
    local windows = hl.get_windows()

    for _, window in ipairs(windows) do

        if window.at and window.size then

            local x = window.at.x
            local y = window.at.y

            local w = window.size.x
            local h = window.size.y

            local cx = cursor.x
            local cy = cursor.y


            ----------------
            -- LEFT EDGE --
            ----------------

            if cx >= x - 10
                and cx <= x + 10
                and cy >= y
                and cy <= y + h then

                return "l"
            end


            -----------------
            -- RIGHT EDGE --
            -----------------

            if cx >= x + w - 10
                and cx <= x + w + 10
                and cy >= y
                and cy <= y + h then

                return "r"
            end


            ----------------
            -- TOP EDGE --
            ----------------

            if cy >= y - 10
                and cy <= y + 10
                and cx >= x
                and cx <= x + w then

                return "u"
            end


            -------------------
            -- BOTTOM EDGE --
            -------------------

            if cy >= y + h - 10
                and cy <= y + h + 10
                and cx >= x
                and cx <= x + w then

                return "d"
            end
        end
    end

    return nil
end


--------------------------------
---- COLLAPSE NEW TILE ---------
--------------------------------

-- Once the window created by Splay has been fully opened,
-- collapse it along the split axis.
--
-- l / r:
--     width  = 1px
--     height = whatever dwindle gave it
--
-- u / d:
--     width  = whatever dwindle gave it
--     height = 1px
--
-- The following native resize operation is only used to
-- establish the initial geometry. The subsequent mouse
-- resize remains completely native to Hyprland.

hl.on("window.open", function(window)

    if not splay_spawn_pending then
        return
    end

    if not splay_spawn_direction then
        return
    end


    local direction = splay_spawn_direction

    --------------------------------
    -- Consume Splay spawn state.
    --------------------------------

    splay_spawn_pending = false
    splay_spawn_direction = nil


    --------------------------------
    -- Make sure we have geometry.
    --------------------------------

    if not window.size then
        return
    end


    local width  = window.size.x
    local height = window.size.y


    --------------------------------
    -- Collapse split axis.
    --------------------------------

    if direction == "l" or direction == "r" then

        hl.dispatch(
            hl.dsp.window.resize({
                x      = 1,
                y      = height,
                window = window,
            })
        )

    elseif direction == "u" or direction == "d" then

        hl.dispatch(
            hl.dsp.window.resize({
                x      = width,
                y      = 1,
                window = window,
            })
        )
    end
end)


--------------------------------
---- SPLAY CLICK ---------------
--------------------------------

local function splay_click()

    local direction = get_splay_edge()

    if not direction then
        return
    end


    --------------------------------
    -- FIRST CLICK
    --------------------------------

    if not splay_click_pending then

        splay_click_pending = true
        splay_click_direction = direction

        hl.timer(function()

            splay_click_pending = false
            splay_click_direction = nil

        end, {
            timeout = 250,
            type = "oneshot",
        })

        return
    end


    --------------------------------
    -- DIFFERENT EDGE
    --------------------------------

    if splay_click_direction ~= direction then

        splay_click_direction = direction

        return
    end


    --------------------------------
    -- SECOND CLICK
    --------------------------------

    splay_click_pending = false
    splay_click_direction = nil


    --------------------------------
    -- Tell the window.open event
    -- which new tile belongs to Splay.
    --------------------------------

    splay_spawn_pending = true
    splay_spawn_direction = direction


    --------------------------------
    -- The new window is preselected
    -- in the requested direction.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Create the new tile.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )


    --------------------------------
    -- Tell the second mouse bind
    -- to start native resize.
    --------------------------------

    splay_new_tile = true
end


--------------------------------
---- SPLAY MOUSE BIND ----------
--------------------------------

-- LMB has two simultaneous roles here:
--
-- 1. Splay click detection.
-- 2. Native Hyprland resize.
--
-- On the second click:
--
--     preselect
--        ↓
--     create terminal
--        ↓
--     window.open
--        ↓
--     new tile becomes 1px
--        ↓
--     native resize starts
--
-- Because the new tile is already collapsed when resize
-- starts, dragging the mouse makes it appear to emerge
-- from the selected edge.

hl.bind(
    "mouse:272",
    function()

        --------------------------------
        -- New tile has just been created.
        --------------------------------

        if splay_new_tile then

            splay_new_tile = false

            hl.dispatch(
                hl.dsp.window.resize()
            )

            return
        end


        --------------------------------
        -- Normal Splay click.
        --------------------------------

        splay_click()

    end,
    {
        mouse = true,
    }
)


--------------------------------
---- MOUSE RELEASE -------------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        splay_new_tile = false

    end,
    {
        mouse = true,
        release = true,
    }
)


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name = "suppress-maximize-events",

    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})


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


hl.window_rule({
    name = "move-hyprland-run",

    match = {
        class = "hyprland-run",
    },

    move  = "20 monitor_h-120",
    float = true,
})
