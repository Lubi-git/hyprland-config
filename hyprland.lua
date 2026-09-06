```lua
-- SplayDE
-- Mouse-oriented tiling environment
--
-- Hyprland is the compositor and tiling/layout backend.
-- Splay is the spatial interaction layer.
--


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

local splay_click_pending = false
local splay_click_direction = nil
local splay_new_tile = false

-- Resize feedback state.
local splay_resize_active = false
local splay_resize_window = nil
local splay_resize_direction = nil
local splay_resize_stable = true
local splay_resize_timer = nil


--------------------------------
---- SPLAY RESIZE SETTINGS -----
--------------------------------

-- Visual/semantic minimum.
-- This is NOT a hard Hyprland minimum.
local SPLAY_MIN_TILE_SIZE = 120

-- Temporary resize border.
local SPLAY_RESIZE_BORDER_SIZE = 5

-- Stable / unstable colors.
local SPLAY_STABLE_COLOR = "rgb(00FFFF)"
local SPLAY_UNSTABLE_COLOR = "rgb(FF0055)"


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

        -- Splay manages temporary resize borders itself.
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
    bezier = "linear",
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


            -- Left edge.
            if cx >= x - 10
                and cx <= x + 10
                and cy >= y
                and cy <= y + h then

                return "l"
            end


            -- Right edge.
            if cx >= x + w - 10
                and cx <= x + w + 10
                and cy >= y
                and cy <= y + h then

                return "r"
            end


            -- Top edge.
            if cy >= y - 10
                and cy <= y + 10
                and cx >= x
                and cx <= x + w then

                return "u"
            end


            -- Bottom edge.
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
---- SPLAY RESIZE FEEDBACK -----
--------------------------------

local function splay_set_resize_border(stable)

    local color

    if stable then
        color = SPLAY_STABLE_COLOR
    else
        color = SPLAY_UNSTABLE_COLOR
    end


    -- Border size.
    hl.dsp.window.set_prop({
        prop = "border_size",
        value = tostring(SPLAY_RESIZE_BORDER_SIZE),
    })


    -- Set both active and inactive colors.
    -- This guarantees that the feedback remains visible
    -- regardless of the active/inactive border state.

    hl.dsp.window.set_prop({
        prop = "active_border_color",
        value = color,
    })

    hl.dsp.window.set_prop({
        prop = "inactive_border_color",
        value = color,
    })
end


local function splay_clear_resize_border()

    hl.dsp.window.set_prop({
        prop = "border_size",
        value = "0",
    })

    hl.dsp.window.set_prop({
        prop = "active_border_color",
        value = "unset",
    })

    hl.dsp.window.set_prop({
        prop = "inactive_border_color",
        value = "unset",
    })
end


local function splay_update_resize_state()

    if not splay_resize_active then
        return
    end


    -- Always use the currently active window.
    -- During native resize this is the tile being manipulated.

    local window = hl.get_active_window()

    if not window or not window.size then
        return
    end


    local width  = window.size.x
    local height = window.size.y

    local manipulated_size


    if splay_resize_direction == "l"
        or splay_resize_direction == "r" then

        manipulated_size = width

    elseif splay_resize_direction == "u"
        or splay_resize_direction == "d" then

        manipulated_size = height

    else
        return
    end


    local stable = manipulated_size >= SPLAY_MIN_TILE_SIZE


    -- Only change the border when the state changes.
    -- This avoids repeatedly sending the same property.

    if stable ~= splay_resize_stable then
        splay_resize_stable = stable

        splay_set_resize_border(stable)
    end
end


local function splay_start_resize_feedback(direction)

    local window = hl.get_active_window()

    if not window then
        return
    end


    splay_resize_active = true
    splay_resize_window = window
    splay_resize_direction = direction
    splay_resize_stable = true


    -- IMPORTANT:
    -- Apply the border BEFORE native resize starts.
    -- hl.dsp.window.resize() enters the interactive resize
    -- operation, so doing this afterwards can happen too late.

    splay_set_resize_border(true)


    -- Update approximately every frame.

    if splay_resize_timer then
        splay_resize_timer:stop()
        splay_resize_timer = nil
    end


    splay_resize_timer = hl.timer(
        function()
            splay_update_resize_state()
        end,
        {
            timeout = 16,
            type = "repeat",
        }
    )
end


local function splay_end_resize_feedback()

    if not splay_resize_active then
        return
    end


    local stable = splay_resize_stable


    splay_resize_active = false
    splay_resize_direction = nil
    splay_resize_window = nil


    if splay_resize_timer then
        splay_resize_timer:stop()
        splay_resize_timer = nil
    end


    if stable then

        -- Valid tile:
        -- remove the temporary visual feedback.

        splay_clear_resize_border()

    else

        -- Invalid tile:
        -- close the newly-created program/tile.

        hl.dispatch(
            hl.dsp.window.close()
        )

        -- Also make sure the temporary border is removed
        -- from the active window if possible.

        splay_clear_resize_border()
    end
end


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

    splay_new_tile = true


    --------------------------------
    -- DWINDLE SPLIT RATIO
    --------------------------------
    --
    -- Right / Down:
    -- the new tile is created toward the
    -- dragged direction.
    --
    -- Left / Up:
    -- the inverse split ratio is required.

    if direction == "r"
        or direction == "d" then

        hl.config({
            dwindle = {
                default_split_ratio = 1.9,
            },
        })

    elseif direction == "l"
        or direction == "u" then

        hl.config({
            dwindle = {
                default_split_ratio = 0.1,
            },
        })
    end


    --------------------------------
    -- PRESELECT
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- CREATE TILE
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )
end


--------------------------------
---- SPLAY MOUSE BIND ----------
--------------------------------

-- LMB is used for the Splay gesture.
--
-- First click:
--     detect edge
--
-- Second click:
--     create the new tile
--
-- Next press:
--     start native resize


hl.bind(
    "mouse:272",
    function()

        if splay_new_tile then

            splay_new_tile = false


            --------------------------------
            -- START FEEDBACK FIRST
            --------------------------------
            --
            -- This MUST happen before resize().
            --

            splay_start_resize_feedback(
                splay_click_direction
            )


            --------------------------------
            -- NATIVE RESIZE
            --------------------------------

            hl.dispatch(
                hl.dsp.window.resize()
            )

            return
        end


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

        if splay_resize_active then

            splay_end_resize_feedback()

            return
        end


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
```
