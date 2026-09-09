```lua
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

local splay_click_pending = false
local splay_click_direction = nil

local splay_spawn_pending = false
local splay_spawn_direction = nil

local splay_new_tile = false


--------------------------------
---- SPLAY RESIZE STATE --------
--------------------------------

local splay_resize_active = false
local splay_resize_direction = nil

local splay_resize_start_x = 0
local splay_resize_start_y = 0

local splay_resize_valid = false
local splay_resize_timer = nil


--------------------------------
---- SPLAY RESIZE SETTINGS -----
--------------------------------

local SPLAY_MIN_SIZE = 120

-- Border feedback width.
local SPLAY_FEEDBACK_BORDER = 4


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
    speed = 1.46,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "linear",
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

        split_bias = 0,

        default_split_ratio = 1.9,
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
---- SPLAY DISTANCE ------------
--------------------------------

local function splay_get_distance()

    local cursor = hl.get_cursor_pos()

    if not cursor then
        return 0
    end


    local dx = cursor.x - splay_resize_start_x
    local dy = cursor.y - splay_resize_start_y


    if splay_resize_direction == "l"
        or splay_resize_direction == "r" then

        return math.abs(dx)

    elseif splay_resize_direction == "u"
        or splay_resize_direction == "d" then

        return math.abs(dy)

    end


    return 0
end


--------------------------------
---- SPLAY FEEDBACK ------------
--------------------------------

local function splay_update_feedback()

    if not splay_resize_active then
        return
    end


    local distance = splay_get_distance()

    local valid = distance >= SPLAY_MIN_SIZE


    if valid ~= splay_resize_valid then

        splay_resize_valid = valid

        --------------------------------
        -- Border width is the only
        -- feedback we can safely change
        -- with the currently verified ABI.
        --------------------------------

        if valid then

            hl.config({
                general = {
                    border_size = SPLAY_FEEDBACK_BORDER,
                },
            })

        else

            hl.config({
                general = {
                    border_size = SPLAY_FEEDBACK_BORDER,
                },
            })

        end

    end

end


--------------------------------
---- SPLAY START RESIZE --------
--------------------------------

local function splay_start_resize()

    local cursor = hl.get_cursor_pos()

    if not cursor then
        return
    end


    splay_resize_active = true

    splay_resize_start_x = cursor.x
    splay_resize_start_y = cursor.y

    splay_resize_valid = false


    --------------------------------
    -- Show feedback border.
    --------------------------------

    hl.config({
        general = {
            border_size = SPLAY_FEEDBACK_BORDER,
        },
    })


    --------------------------------
    -- Track cursor distance.
    --------------------------------

    if splay_resize_timer then

        splay_resize_timer:stop()
        splay_resize_timer = nil

    end


    splay_resize_timer = hl.timer(
        function()

            splay_update_feedback()

        end,
        {
            timeout = 16,
            type = "repeat",
        }
    )

end


--------------------------------
---- SPLAY END RESIZE ----------
--------------------------------

local function splay_end_resize()

    if not splay_resize_active then
        return
    end


    splay_update_feedback()


    local valid = splay_resize_valid


    splay_resize_active = false


    if splay_resize_timer then

        splay_resize_timer:stop()
        splay_resize_timer = nil

    end


    --------------------------------
    -- Remove tile if below minimum.
    --------------------------------

    if not valid then

        hl.dispatch(
            hl.dsp.window.close()
        )

    end


    --------------------------------
    -- Restore borderless layout.
    --------------------------------

    hl.config({
        general = {
            border_size = 0,
        },
    })


    splay_resize_direction = nil

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


    --------------------------------
    -- Register new tile.
    --------------------------------

    splay_spawn_pending = true
    splay_spawn_direction = direction

    splay_resize_direction = direction


    --------------------------------
    -- Configure split ratio.
    --------------------------------

    if direction == "r"
        or direction == "d" then

        hl.config({
            dwindle = {
                default_split_ratio = 1.9,
            },
        })

    else

        hl.config({
            dwindle = {
                default_split_ratio = 0.1,
            },
        })

    end


    --------------------------------
    -- Preselect.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Create tile.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )


    --------------------------------
    -- Next press starts resize.
    --------------------------------

    splay_new_tile = true

end


--------------------------------
---- SPLAY MOUSE BIND ----------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        if splay_new_tile then

            splay_new_tile = false

            splay_start_resize()


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

            splay_end_resize()

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
