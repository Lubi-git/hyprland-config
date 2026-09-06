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
---- SPLAY ---------------------
--------------------------------

local splay = {
    -- Spatial area considered to be a tile border.
    border_zone = 20,

    -- Maximum time between two clicks to form a double click.
    double_click_time = 250,

    -- Minimum tile size accepted by Splay.
    minimum_size = 20,

    -- Visual feedback.
    border_size = 2,

    colors = {
        valid   = "rgb(33ccff)",
        invalid = "rgb(ff3344)",
    },

    gesture = {
        candidate = false,
        direction = nil,
        window    = nil,
        double_click_pending = false,
    },
}


---------------------------
---- SPLAY HELPERS --------
---------------------------

local function stop_splay_gesture()
    splay.gesture.candidate = false
    splay.gesture.direction = nil
    splay.gesture.window = nil
end


local function set_splay_border(color)
    hl.config({
        general = {
            border_size = splay.border_size,
        },

        ["general.col.active_border"] = color,
    })
end


local function clear_splay_border()
    hl.config({
        general = {
            border_size = 0,
        },
    })
end


local function get_window_geometry(window)
    if window == nil then
        return nil
    end

    local position = window.at
    local size = window.size

    if position == nil or size == nil then
        return nil
    end

    return {
        x = position.x,
        y = position.y,
        width = size.x,
        height = size.y,
    }
end


local function get_border_direction(window)
    local geometry = get_window_geometry(window)

    if geometry == nil then
        return nil
    end

    local cursor = hl.get_cursor_pos()

    if cursor == nil then
        return nil
    end

    local left   = math.abs(cursor.x - geometry.x)
    local right  = math.abs(cursor.x - (geometry.x + geometry.width))
    local top    = math.abs(cursor.y - geometry.y)
    local bottom = math.abs(cursor.y - (geometry.y + geometry.height))

    local nearest = math.min(left, right, top, bottom)

    if nearest > splay.border_zone then
        return nil
    end

    if nearest == left then
        return "l"
    elseif nearest == right then
        return "r"
    elseif nearest == top then
        return "u"
    else
        return "d"
    end
end


local function begin_splay_candidate()
    local window = hl.get_active_window()

    if window == nil then
        stop_splay_gesture()
        return
    end

    -- Splay operates on tiled windows.
    if window.floating then
        stop_splay_gesture()
        return
    end

    local direction = get_border_direction(window)

    if direction == nil then
        stop_splay_gesture()
        return
    end

    splay.gesture.candidate = true
    splay.gesture.direction = direction
    splay.gesture.window = window

    set_splay_border(splay.colors.valid)
end


local function create_tile()
    local direction = splay.gesture.direction
    local window = splay.gesture.window

    if direction == nil or window == nil then
        stop_splay_gesture()
        clear_splay_border()
        return
    end

    -- One-shot Dwindle split direction.
    hl.dispatch(
        hl.dsp.layout("preselect " .. direction)
    )

    -- The new tile is a real terminal window.
    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )

    stop_splay_gesture()
    clear_splay_border()
end


local function register_click()
    local window = hl.get_active_window()

    if window == nil then
        stop_splay_gesture()
        clear_splay_border()
        return
    end

    local direction = get_border_direction(window)

    if direction == nil then
        stop_splay_gesture()
        clear_splay_border()
        return
    end

    -- First click.
    if not splay.gesture.double_click_pending then
        splay.gesture.double_click_pending = true

        hl.timer(
            function()
                splay.gesture.double_click_pending = false
            end,
            {
                timeout = splay.double_click_time,
                type = "oneshot",
            }
        )

        return
    end

    -- Second click within the double-click interval.
    splay.gesture.double_click_pending = false

    splay.gesture.candidate = true
    splay.gesture.direction = direction
    splay.gesture.window = window

    create_tile()
end


-------------------------------
---- SPLAY MOUSE INTERACTION ---
-------------------------------

hl.config({
    binds = {
        -- Small enough to distinguish a click from an intentional drag.
        drag_threshold = 8,
    },
})


-- Mouse press:
--
-- Splay only records whether the cursor is on a valid tile border.
-- Hyprland itself continues handling the pointer interaction.
hl.bind(
    "mouse:272",
    begin_splay_candidate,
    {
        mouse = true,
        non_consuming = true,
    }
)


-- Mouse click:
--
-- Two consecutive clicks on a tile border become a Splay
-- "create tile" gesture.
hl.bind(
    "mouse:272",
    register_click,
    {
        mouse = true,
        click = true,
        non_consuming = true,
    }
)


-- Mouse drag:
--
-- The actual border resize remains Hyprland's responsibility.
-- Splay only observes the final geometry and rejects a tile
-- that ended below the minimum size.
hl.bind(
    "mouse:272",
    function()
        if not splay.gesture.candidate then
            stop_splay_gesture()
            clear_splay_border()
            return
        end

        local window = splay.gesture.window

        if window ~= nil and window.size ~= nil then
            if window.size.x < splay.minimum_size
                or window.size.y < splay.minimum_size then

                hl.dispatch(
                    hl.dsp.window.close({
                        window = window,
                    })
                )

                set_splay_border(splay.colors.invalid)
            end
        end

        stop_splay_gesture()
        clear_splay_border()
    end,
    {
        mouse = true,
        drag = true,
        non_consuming = true,
    }
)


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
        gaps_in  = 10,
        gaps_out = 20,

        border_size = 0,

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
