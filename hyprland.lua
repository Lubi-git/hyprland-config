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

local terminal    = "kitty"
local fileManager = terminal .. " -e yazi"
local launcher    = terminal .. " -e fsel"


--------------------------------
---- SPLAY STATE ---------------
--------------------------------

local splay_click_pending = false
local splay_click_direction = nil

local splay_new_tile = false


--------------------------------
---- SPLAY RESIZE STATE --------
--------------------------------

local splay_resize_active = false
local splay_resize_window = nil

local splay_resize_valid = true

local splay_resize_feedback_state = nil
local splay_resize_timer = nil


--------------------------------
---- SPLAY RESIZE SETTINGS -----
--------------------------------

-- If either dimension falls below its limit,
-- releasing the resize closes the tile.

local SPLAY_MIN_WIDTH  = 160
local SPLAY_MIN_HEIGHT = 120


-- Resize feedback border.

local SPLAY_FEEDBACK_BORDER = 5

local SPLAY_FEEDBACK_KEEP =
    "rgb(00D9FF)"

local SPLAY_FEEDBACK_CLOSE =
    "rgb(FF3B30)"


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
---- INPUT ----------
---------------------

hl.config({
    input = {
        kb_layout  = "es",
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
---- APPLICATIONS ---------
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
---- WINDOW BEHAVIOUR -----
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
---- FOCUS ----------------
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

    if not cursor then
        return nil
    end


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
---- SPLAY TILE VALIDITY -------
--------------------------------

local function splay_tile_is_valid(window)

    if not window then
        return true
    end


    if not window.size then
        return true
    end


    local width = window.size.x
    local height = window.size.y


    if width < SPLAY_MIN_WIDTH then
        return false
    end


    if height < SPLAY_MIN_HEIGHT then
        return false
    end


    return true

end


--------------------------------
---- SPLAY SET FEEDBACK --------
--------------------------------

local function splay_set_feedback(valid)

    local window = splay_resize_window

    if not window then
        return
    end


    local state

    if valid then
        state = "keep"
    else
        state = "close"
    end


    --------------------------------
    -- Do nothing if feedback
    -- already matches current state.
    --------------------------------

    if state == splay_resize_feedback_state then
        return
    end


    splay_resize_feedback_state = state


    local color

    if valid then
        color = SPLAY_FEEDBACK_KEEP
    else
        color = SPLAY_FEEDBACK_CLOSE
    end


    --------------------------------
    -- Show border only on the tile
    -- currently being resized.
    --------------------------------

    hl.dispatch(
        hl.dsp.window.set_prop({
            window = window,
            prop = "border_size",
            value = tostring(
                SPLAY_FEEDBACK_BORDER
            ),
        })
    )


    hl.dispatch(
        hl.dsp.window.set_prop({
            window = window,
            prop = "border_color",
            value = color,
        })
    )


    --------------------------------
    -- Force the newly changed
    -- properties to be visible now.
    --
    -- This only runs when changing
    -- cyan <-> red, not every frame.
    --------------------------------

    hl.exec_scheduled_prop_refresh_immediately()

end


--------------------------------
---- SPLAY CLEAR FEEDBACK ------
--------------------------------

local function splay_clear_feedback(window)

    if not window then
        return
    end


    --------------------------------
    -- Return the tile to its normal
    -- rules/configuration.
    --------------------------------

    hl.dispatch(
        hl.dsp.window.set_prop({
            window = window,
            prop = "border_size",
            value = "unset",
        })
    )


    hl.dispatch(
        hl.dsp.window.set_prop({
            window = window,
            prop = "border_color",
            value = "unset",
        })
    )


    hl.exec_scheduled_prop_refresh_immediately()

end


--------------------------------
---- SPLAY UPDATE FEEDBACK -----
--------------------------------

local function splay_update_feedback()

    if not splay_resize_active then
        return
    end


    local window = splay_resize_window

    if not window then
        return
    end


    local valid =
        splay_tile_is_valid(window)


    splay_resize_valid = valid


    splay_set_feedback(valid)

end


--------------------------------
---- SPLAY STOP TIMER ----------
--------------------------------

local function splay_stop_resize_timer()

    if not splay_resize_timer then
        return
    end


    splay_resize_timer:set_enabled(false)

    splay_resize_timer = nil

end


--------------------------------
---- SPLAY START RESIZE --------
--------------------------------

local function splay_start_resize()

    local window = hl.get_active_window()

    if not window then
        return
    end


    if not window.size then
        return
    end


    splay_resize_active = true
    splay_resize_window = window

    splay_resize_feedback_state = nil


    --------------------------------
    -- Evaluate initial tile size.
    --------------------------------

    splay_resize_valid =
        splay_tile_is_valid(window)


    --------------------------------
    -- Show initial cyan/red state.
    --------------------------------

    splay_set_feedback(
        splay_resize_valid
    )


    --------------------------------
    -- Stop old timer if one somehow
    -- survived a previous resize.
    --------------------------------

    splay_stop_resize_timer()


    --------------------------------
    -- Poll tile geometry while
    -- interactive resize is active.
    --------------------------------

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


    local window = splay_resize_window


    --------------------------------
    -- Always evaluate actual final
    -- geometry on mouse release.
    --------------------------------

    local valid =
        splay_tile_is_valid(window)


    splay_resize_valid = valid
    splay_resize_active = false


    --------------------------------
    -- Stop geometry polling.
    --------------------------------

    splay_stop_resize_timer()


    --------------------------------
    -- Remove cyan/red feedback.
    --------------------------------

    splay_clear_feedback(window)


    --------------------------------
    -- If the tile crossed either
    -- minimum dimension, close it.
    --------------------------------

    if not valid and window then

        hl.dispatch(
            hl.dsp.window.close({
                window = window,
            })
        )

    end


    --------------------------------
    -- Reset resize state.
    --------------------------------

    splay_resize_window = nil
    splay_resize_feedback_state = nil
    splay_resize_valid = true

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


        hl.timer(
            function()

                splay_click_pending = false
                splay_click_direction = nil

            end,
            {
                timeout = 250,
                type = "oneshot",
            }
        )


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
    -- Preselect new split.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Create new tile.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )


    --------------------------------
    -- The next mouse press begins
    -- resizing the newly created tile.
    --------------------------------

    splay_new_tile = true

end


--------------------------------
---- SPLAY MOUSE PRESS ---------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        --------------------------------
        -- A tile was just created.
        --
        -- Next press begins Splay's
        -- interactive resize state.
        --------------------------------

        if splay_new_tile then

            splay_new_tile = false


            splay_start_resize()


            if splay_resize_active then

                hl.dispatch(
                    hl.dsp.window.resize()
                )

            end


            return

        end


        --------------------------------
        -- Otherwise detect Splay's
        -- double-click edge gesture.
        --------------------------------

        splay_click()

    end,
    {
        mouse = true,
    }
)


--------------------------------
---- SPLAY MOUSE RELEASE -------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        --------------------------------
        -- Releasing the mouse ends the
        -- current Splay resize.
        --------------------------------

        if splay_resize_active then

            splay_end_resize()

            return

        end


        --------------------------------
        -- IMPORTANT:
        --
        -- Do NOT clear splay_new_tile
        -- here.
        --
        -- The second click that creates
        -- the tile necessarily generates
        -- a release event. Clearing the
        -- flag here would make the next
        -- press resize path impossible.
        --------------------------------

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
