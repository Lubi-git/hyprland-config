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

local splay_mouse_down = false

local splay_press_kind = nil
local splay_press_direction = nil


--------------------------------
---- SPLAY CLICK STATE ---------
--------------------------------

local splay_click_pending = false
local splay_click_direction = nil
local splay_click_generation = 0


--------------------------------
---- SPLAY SPAWN STATE ---------
--------------------------------

local splay_spawn_pending = false
local splay_spawn_direction = nil
local splay_spawn_generation = 0


--------------------------------
---- SPLAY RESIZE STATE --------
--------------------------------

local splay_resize_active = false
local splay_resize_committed = false
local splay_resize_spawned = false

local splay_resize_window = nil
local splay_resize_edge = nil

local splay_resize_start_x = 0
local splay_resize_start_y = 0

local splay_resize_last_x = 0
local splay_resize_last_y = 0

local splay_resize_valid = true
local splay_resize_feedback_state = nil

local splay_resize_timer = nil


--------------------------------
---- SPLAY SETTINGS ------------
--------------------------------

-- Minimum usable tile size.
local SPLAY_MIN_WIDTH  = 160
local SPLAY_MIN_HEIGHT = 120

-- A normal edge interaction must move
-- this much before it becomes a resize.
local SPLAY_DRAG_THRESHOLD = 10

-- Poll cursor / geometry at ~60 Hz.
local SPLAY_RESIZE_INTERVAL = 16

-- Temporary resize feedback.
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
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 10,
        gaps_out = 20,

        border_size = 0,

        --------------------------------
        -- Splay performs border resize
        -- itself using explicit deltas.
        --------------------------------

        resize_on_border = false,

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
        return nil, nil
    end


    local windows = hl.get_windows()


    for _, window in ipairs(windows) do

        if window.at
            and window.size then


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

                return "l", window

            end


            -----------------
            -- RIGHT EDGE --
            -----------------

            if cx >= x + w - 10
                and cx <= x + w + 10
                and cy >= y
                and cy <= y + h then

                return "r", window

            end


            ----------------
            -- TOP EDGE --
            ----------------

            if cy >= y - 10
                and cy <= y + 10
                and cx >= x
                and cx <= x + w then

                return "u", window

            end


            -------------------
            -- BOTTOM EDGE ----
            -------------------

            if cy >= y + h - 10
                and cy <= y + h + 10
                and cx >= x
                and cx <= x + w then

                return "d", window

            end

        end

    end


    return nil, nil

end


--------------------------------
---- SPLAY OPPOSITE EDGE -------
--------------------------------

local function splay_opposite_edge(direction)

    if direction == "l" then
        return "r"

    elseif direction == "r" then
        return "l"

    elseif direction == "u" then
        return "d"

    elseif direction == "d" then
        return "u"
    end


    return nil

end


--------------------------------
---- SPLAY TILE VALIDITY -------
--------------------------------

local function splay_tile_is_valid(window)

    if not window
        or not window.size then

        return true
    end


    return window.size.x >= SPLAY_MIN_WIDTH
        and window.size.y >= SPLAY_MIN_HEIGHT

end


--------------------------------
---- SPLAY SET PROP ------------
--------------------------------

local function splay_set_prop(
    window,
    prop,
    value
)

    if not window then
        return
    end


    hl.dispatch(
        hl.dsp.window.set_prop({
            window = window,
            prop = prop,
            value = value,
        })
    )

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
    -- Do not resend the same props
    -- every timer tick.
    --------------------------------

    if state ==
        splay_resize_feedback_state then

        return
    end


    splay_resize_feedback_state =
        state


    local color

    if valid then
        color = SPLAY_FEEDBACK_KEEP
    else
        color = SPLAY_FEEDBACK_CLOSE
    end


    splay_set_prop(
        window,
        "border_size",
        tostring(
            SPLAY_FEEDBACK_BORDER
        )
    )


    splay_set_prop(
        window,
        "active_border_color",
        color
    )


    splay_set_prop(
        window,
        "inactive_border_color",
        color
    )


    --------------------------------
    -- Only refresh when state
    -- actually changes cyan/red.
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


    splay_set_prop(
        window,
        "border_size",
        "unset"
    )


    splay_set_prop(
        window,
        "active_border_color",
        "-1"
    )


    splay_set_prop(
        window,
        "inactive_border_color",
        "-1"
    )


    hl.exec_scheduled_prop_refresh_immediately()

end


--------------------------------
---- SPLAY STOP TIMER ----------
--------------------------------

local function splay_stop_resize_timer()

    if not splay_resize_timer then
        return
    end


    splay_resize_timer:
        set_enabled(false)


    splay_resize_timer = nil

end


--------------------------------
---- SPLAY RESET RESIZE --------
--------------------------------

local function splay_reset_resize()

    splay_stop_resize_timer()


    splay_resize_active = false
    splay_resize_committed = false
    splay_resize_spawned = false

    splay_resize_window = nil
    splay_resize_edge = nil

    splay_resize_start_x = 0
    splay_resize_start_y = 0

    splay_resize_last_x = 0
    splay_resize_last_y = 0

    splay_resize_valid = true
    splay_resize_feedback_state = nil

end


--------------------------------
---- SPLAY APPLY RESIZE --------
--------------------------------

local function splay_apply_resize(
    window,
    edge,
    dx,
    dy
)

    if not window
        or not edge then

        return
    end


    local rx = 0
    local ry = 0


    --------------------------------
    -- Convert cursor movement into
    -- desired size change.
    --
    -- RIGHT:
    -- drag right => larger
    --
    -- LEFT:
    -- drag right => smaller
    --
    -- BOTTOM:
    -- drag down => larger
    --
    -- TOP:
    -- drag down => smaller
    --------------------------------

    if edge == "r" then

        rx = dx


    elseif edge == "l" then

        rx = -dx


    elseif edge == "d" then

        ry = dy


    elseif edge == "u" then

        ry = -dy

    end


    --------------------------------
    -- Nothing changed.
    --------------------------------

    if rx == 0
        and ry == 0 then

        return
    end


    --------------------------------
    -- IMPORTANT:
    --
    -- This is NOT the interactive
    -- mouse-resize dispatcher.
    --
    -- It is an explicit relative
    -- window resize.
    --------------------------------

    hl.dispatch(
        hl.dsp.window.resize({
            x = rx,
            y = ry,
            relative = true,
            window = window,
        })
    )

end


--------------------------------
---- SPLAY RESIZE TICK ---------
--------------------------------

local function splay_resize_tick()

    if not splay_resize_active then
        return
    end


    local window = splay_resize_window

    if not window
        or not window.size then

        return
    end


    local cursor =
        hl.get_cursor_pos()


    if not cursor then
        return
    end


    --------------------------------
    -- A normal tile does not resize
    -- until drag threshold is crossed.
    --
    -- A newly spawned tile starts in
    -- committed resize immediately.
    --------------------------------

    if not splay_resize_committed then

        local dx =
            cursor.x
            - splay_resize_start_x

        local dy =
            cursor.y
            - splay_resize_start_y


        local distance


        if splay_resize_edge == "l"
            or splay_resize_edge == "r" then

            distance = math.abs(dx)

        else

            distance = math.abs(dy)

        end


        if distance <
            SPLAY_DRAG_THRESHOLD then

            return
        end


        --------------------------------
        -- First resize update uses the
        -- entire movement accumulated
        -- since mouse press.
        --------------------------------

        splay_resize_committed = true


        splay_apply_resize(
            window,
            splay_resize_edge,
            dx,
            dy
        )


        splay_resize_last_x =
            cursor.x

        splay_resize_last_y =
            cursor.y


    else

        --------------------------------
        -- Subsequent updates are
        -- incremental.
        --------------------------------

        local dx =
            cursor.x
            - splay_resize_last_x

        local dy =
            cursor.y
            - splay_resize_last_y


        if dx ~= 0
            or dy ~= 0 then

            splay_apply_resize(
                window,
                splay_resize_edge,
                dx,
                dy
            )


            splay_resize_last_x =
                cursor.x

            splay_resize_last_y =
                cursor.y

        end

    end


    --------------------------------
    -- Feedback follows actual tile
    -- geometry as reported by
    -- Hyprland.
    --------------------------------

    splay_resize_valid =
        splay_tile_is_valid(window)


    splay_set_feedback(
        splay_resize_valid
    )

end


--------------------------------
---- SPLAY BEGIN RESIZE --------
--------------------------------

local function splay_begin_resize(
    window,
    edge,
    spawned
)

    if not window
        or not window.size
        or not edge then

        return
    end


    --------------------------------
    -- Never allow overlapping resize
    -- state.
    --------------------------------

    if splay_resize_active then

        splay_clear_feedback(
            splay_resize_window
        )

        splay_reset_resize()

    end


    local cursor =
        hl.get_cursor_pos()


    if not cursor then
        return
    end


    splay_resize_active = true
    splay_resize_spawned =
        spawned == true

    splay_resize_window = window
    splay_resize_edge = edge


    splay_resize_start_x =
        cursor.x

    splay_resize_start_y =
        cursor.y

    splay_resize_last_x =
        cursor.x

    splay_resize_last_y =
        cursor.y


    --------------------------------
    -- A spawned tile is already in
    -- resize mode from its first frame.
    --
    -- An existing tile waits for
    -- movement past the threshold.
    --------------------------------

    splay_resize_committed =
        spawned == true


    splay_resize_valid =
        splay_tile_is_valid(window)

    splay_resize_feedback_state = nil


    --------------------------------
    -- Initial spawned-tile feedback
    -- is immediate.
    --------------------------------

    if splay_resize_committed then

        splay_set_feedback(
            splay_resize_valid
        )

    end


    --------------------------------
    -- No Hyprland interactive resize
    -- dispatcher is started here.
    --------------------------------

    splay_resize_timer = hl.timer(
        function()

            splay_resize_tick()

        end,
        {
            timeout = SPLAY_RESIZE_INTERVAL,
            type = "repeat",
        }
    )

end


--------------------------------
---- SPLAY END RESIZE ----------
--------------------------------

local function splay_end_resize()

    if not splay_resize_active then
        return false
    end


    --------------------------------
    -- Final timer sample.
    --------------------------------

    splay_resize_tick()


    local window =
        splay_resize_window

    local committed =
        splay_resize_committed

    local valid =
        splay_resize_valid


    --------------------------------
    -- Stop processing BEFORE close.
    --------------------------------

    splay_stop_resize_timer()


    --------------------------------
    -- No real resize:
    --
    -- this was a plain first click.
    --------------------------------

    if not committed then

        splay_reset_resize()

        return false

    end


    --------------------------------
    -- CYAN → keep tile.
    --------------------------------

    if valid then

        splay_clear_feedback(window)


    else

        --------------------------------
        -- RED → close this exact tile.
        --
        -- There is no interactive
        -- Hyprland resize state to
        -- compete with anymore, so the
        -- close can happen directly.
        --------------------------------

        if window then

            hl.dispatch(
                hl.dsp.window.close({
                    window = window,
                })
            )

        end

    end


    splay_reset_resize()


    return true

end


--------------------------------
---- SPLAY ARM CLICK -----------
--------------------------------

local function splay_arm_click(direction)

    splay_click_generation =
        splay_click_generation + 1


    local generation =
        splay_click_generation


    splay_click_pending = true
    splay_click_direction = direction


    --------------------------------
    -- User has 250 ms to begin the
    -- second press.
    --------------------------------

    hl.timer(
        function()

            if generation ~=
                splay_click_generation then

                return

            end


            splay_click_pending = false
            splay_click_direction = nil

        end,
        {
            timeout = 250,
            type = "oneshot",
        }
    )

end


--------------------------------
---- SPLAY CANCEL CLICK --------
--------------------------------

local function splay_cancel_click()

    splay_click_generation =
        splay_click_generation + 1


    splay_click_pending = false
    splay_click_direction = nil

end


--------------------------------
---- SPLAY SPAWN TILE ----------
--------------------------------

local function splay_spawn_tile(direction)

    --------------------------------
    -- Configure insertion ratio.
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
    -- Preselect requested edge.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Mark BEFORE spawning so
    -- window.open claims exactly the
    -- next Splay-created tile.
    --------------------------------

    splay_spawn_generation =
        splay_spawn_generation + 1


    splay_spawn_pending = true
    splay_spawn_direction = direction


    --------------------------------
    -- Tile appears on the SECOND
    -- PRESS: the "click and a half".
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )

end


--------------------------------
---- SPLAY WINDOW OPEN ---------
--------------------------------

hl.on(
    "window.open",
    function(window)

        if not splay_spawn_pending then
            return
        end


        local generation =
            splay_spawn_generation

        local direction =
            splay_spawn_direction


        --------------------------------
        -- Let Dwindle finish inserting
        -- the new target first.
        --------------------------------

        hl.timer(
            function()

                if generation ~=
                    splay_spawn_generation then

                    return
                end


                if not splay_spawn_pending then
                    return
                end


                splay_spawn_pending = false
                splay_spawn_direction = nil


                --------------------------------
                -- If the user already released
                -- the second press, leave the
                -- newly spawned tile normally.
                --------------------------------

                if not splay_mouse_down then
                    return
                end


                --------------------------------
                -- The new tile normally gains
                -- focus anyway, but make the
                -- target explicit.
                --------------------------------

                hl.dispatch(
                    hl.dsp.focus({
                        window = window,
                    })
                )


                --------------------------------
                -- User clicked an edge of the
                -- OLD tile.
                --
                -- The corresponding grabbed
                -- edge of the NEW tile is the
                -- opposite one.
                --
                -- Example:
                --
                -- old right edge → new tile is
                -- on the right → cursor is on
                -- the NEW tile's LEFT edge.
                --------------------------------

                local edge =
                    splay_opposite_edge(
                        direction
                    )


                --------------------------------
                -- New tile immediately enters
                -- resize state.
                --------------------------------

                splay_begin_resize(
                    window,
                    edge,
                    true
                )

            end,
            {
                timeout = 1,
                type = "oneshot",
            }
        )

    end
)


--------------------------------
---- SPLAY MOUSE PRESS ---------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        splay_mouse_down = true

        splay_press_kind = nil
        splay_press_direction = nil


        local direction, window =
            get_splay_edge()


        --------------------------------
        -- Click somewhere else:
        -- cancel any pending first click
        -- but otherwise leave mouse
        -- behavior untouched.
        --------------------------------

        if not direction
            or not window then

            if splay_click_pending then
                splay_cancel_click()
            end

            return
        end


        --------------------------------
        -- SECOND PRESS
        --
        -- First click was completed and
        -- this press is on the same edge
        -- direction.
        --------------------------------

        if splay_click_pending
            and splay_click_direction
                == direction then


            splay_cancel_click()


            splay_press_kind = "spawn"
            splay_press_direction =
                direction


            --------------------------------
            -- Instantiate immediately.
            --
            -- Do NOT wait for release.
            --------------------------------

            splay_spawn_tile(
                direction
            )


            return

        end


        --------------------------------
        -- Different edge invalidates an
        -- old first click.
        --------------------------------

        if splay_click_pending then
            splay_cancel_click()
        end


        --------------------------------
        -- Possible normal resize.
        --
        -- Nothing actually changes until
        -- cursor movement crosses
        -- SPLAY_DRAG_THRESHOLD.
        --------------------------------

        splay_press_kind = "normal"
        splay_press_direction = direction


        splay_begin_resize(
            window,
            direction,
            false
        )

    end
)


--------------------------------
---- SPLAY MOUSE RELEASE -------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        splay_mouse_down = false


        local press_kind =
            splay_press_kind

        local press_direction =
            splay_press_direction


        --------------------------------
        -- Complete current resize.
        --------------------------------

        local resized =
            splay_end_resize()


        --------------------------------
        -- Resize completed:
        --
        -- CYAN preserved it.
        -- RED closed it.
        --------------------------------

        if resized then

            splay_press_kind = nil
            splay_press_direction = nil

            return

        end


        --------------------------------
        -- Second press was released
        -- before window.open managed to
        -- enter resize mode.
        --
        -- Cancel resize ownership but
        -- allow the process/window itself
        -- to appear normally.
        --------------------------------

        if press_kind == "spawn" then

            splay_spawn_pending = false
            splay_spawn_direction = nil

            splay_press_kind = nil
            splay_press_direction = nil

            return

        end


        --------------------------------
        -- Normal press produced no drag:
        --
        -- that is the FIRST CLICK.
        --------------------------------

        if press_kind == "normal"
            and press_direction then

            splay_arm_click(
                press_direction
            )

        end


        splay_press_kind = nil
        splay_press_direction = nil

    end,
    {
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
