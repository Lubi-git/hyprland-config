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
local splay_resize_stable = nil
local splay_resize_timer = nil

-- Minimum dimension for a tile to be considered stable.
local SPLAY_MIN_TILE_SIZE = 200

-- Temporary resize border.
local SPLAY_RESIZE_BORDER_SIZE = 5

-- Neon colors.
local SPLAY_STABLE_COLOR = "rgb(00BFFF)"
local SPLAY_UNSTABLE_COLOR = "rgb(FF004D)"


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
    speed = 1.73,
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
---- SPLAY RESIZE RULES --------
--------------------------------
--
-- Instead of modifying the window
-- directly with set_prop(), Splay
-- marks the active tile with a
-- dynamic tag.
--
-- Hyprland then applies the correct
-- border rule automatically.
--

hl.window_rule({
    name = "splay-resize-stable",

    match = {
        tag = "splay-resize-stable",
    },

    border_size = SPLAY_RESIZE_BORDER_SIZE,

    border_color =
        SPLAY_STABLE_COLOR
        .. " "
        .. SPLAY_STABLE_COLOR,
})


hl.window_rule({
    name = "splay-resize-unstable",

    match = {
        tag = "splay-resize-unstable",
    },

    border_size = SPLAY_RESIZE_BORDER_SIZE,

    border_color =
        SPLAY_UNSTABLE_COLOR
        .. " "
        .. SPLAY_UNSTABLE_COLOR,
})


--------------------------------
---- SPLAY RESIZE TAG STATE ----
--------------------------------

local function splay_set_resize_state(stable)

    --------------------------------
    -- Remove both possible states
    --------------------------------

    hl.dispatch(
        hl.dsp.window.tag({
            tag = "-splay-resize-stable",
        })
    )

    hl.dispatch(
        hl.dsp.window.tag({
            tag = "-splay-resize-unstable",
        })
    )


    --------------------------------
    -- Apply current state
    --------------------------------

    if stable then

        hl.dispatch(
            hl.dsp.window.tag({
                tag = "+splay-resize-stable",
            })
        )

    else

        hl.dispatch(
            hl.dsp.window.tag({
                tag = "+splay-resize-unstable",
            })
        )

    end
end


--------------------------------
---- RESIZE STATE UPDATE -------
--------------------------------

local function splay_update_resize_state()

    if not splay_resize_active then
        return
    end


    --------------------------------
    -- Always inspect active tile
    --------------------------------

    local window = hl.get_active_window()

    if not window then
        return
    end


    local size = window.size

    if not size then
        return
    end


    --------------------------------
    -- Determine manipulated dimension
    --------------------------------

    local dimension

    if splay_resize_direction == "l"
        or splay_resize_direction == "r" then

        dimension = size.x

    else

        dimension = size.y

    end


    --------------------------------
    -- Determine stability
    --------------------------------

    local stable =
        dimension >= SPLAY_MIN_TILE_SIZE


    --------------------------------
    -- Only change tag when state changes
    --------------------------------

    if stable ~= splay_resize_stable then

        splay_resize_stable = stable

        splay_set_resize_state(stable)

    end
end


--------------------------------
---- START RESIZE FEEDBACK ----
--------------------------------

local function splay_start_resize_feedback(direction)

    splay_resize_active = true
    splay_resize_direction = direction
    splay_resize_stable = nil


    --------------------------------
    -- Evaluate immediately
    --------------------------------

    splay_update_resize_state()


    --------------------------------
    -- Monitor continuously
    --------------------------------

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


--------------------------------
---- END RESIZE FEEDBACK -------
--------------------------------

local function splay_end_resize_feedback()

    if not splay_resize_active then
        return false
    end


    --------------------------------
    -- Get final tile
    --------------------------------

    local window = hl.get_active_window()

    local stable = splay_resize_stable


    --------------------------------
    -- Stop monitoring
    --------------------------------

    if splay_resize_timer then

        splay_resize_timer:set_enabled(false)

        splay_resize_timer = nil

    end


    --------------------------------
    -- Clear Splay resize state
    --------------------------------

    splay_resize_active = false
    splay_resize_direction = nil
    splay_resize_stable = nil


    --------------------------------
    -- Unstable tile
    --------------------------------

    if not stable then

        --------------------------------
        -- Remove temporary tag
        --------------------------------

        if window then

            hl.dispatch(
                hl.dsp.window.tag({
                    tag = "-splay-resize-unstable",
                })
            )

            hl.dispatch(
                hl.dsp.window.close()
            )

        end

        return true
    end


    --------------------------------
    -- Stable tile
    --------------------------------

    if window then

        hl.dispatch(
            hl.dsp.window.tag({
                tag = "-splay-resize-stable",
            })
        )

    end


    return false
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
    -- Register new Splay tile
    --------------------------------

    splay_spawn_pending = true
    splay_spawn_direction = direction


    --------------------------------
    -- Configure ratio for direction
    --------------------------------

    if direction == "r" or direction == "d" then

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
    -- Preselect split direction
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Create new tile
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )


    --------------------------------
    -- Start native resize
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


            --------------------------------
            -- Start native resize
            --------------------------------

            hl.dispatch(
                hl.dsp.window.resize()
            )


            --------------------------------
            -- Start Splay resize feedback
            --------------------------------

            splay_start_resize_feedback(
                splay_spawn_direction
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
