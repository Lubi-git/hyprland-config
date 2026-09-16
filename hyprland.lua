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

-- Physical edge being manipulated.
local splay_resize_edge = nil

-- Side from which the new tile was created.
local splay_resize_spawn_direction = nil

local splay_resize_start_x = 0
local splay_resize_start_y = 0

local splay_resize_last_x = 0
local splay_resize_last_y = 0

-- Used to convert cursor pixels into
-- Dwindle split-ratio deltas.
local splay_resize_split_scale = 1

local splay_resize_valid = true
local splay_resize_feedback_state = nil

local splay_resize_timer = nil


--------------------------------
---- SPLAY SETTINGS ------------
--------------------------------

local SPLAY_MIN_WIDTH  = 160
local SPLAY_MIN_HEIGHT = 120

local SPLAY_DRAG_THRESHOLD = 10

local SPLAY_RESIZE_INTERVAL = 16

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
        -- Splay owns border resizing.
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

    local window =
        splay_resize_window


    if not window then
        return
    end


    local state

    if valid then
        state = "keep"
    else
        state = "close"
    end


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
    splay_resize_spawn_direction = nil

    splay_resize_start_x = 0
    splay_resize_start_y = 0

    splay_resize_last_x = 0
    splay_resize_last_y = 0

    splay_resize_split_scale = 1

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


    --------------------------------
    ---- NEWLY SPAWNED TILE -------
    --------------------------------
    --
    -- IMPORTANT:
    --
    -- Do NOT use window.resize()
    -- here.
    --
    -- The newly-created Dwindle tile
    -- belongs to the split we just
    -- inserted. We manipulate that
    -- split directly.
    --
    --
    -- Positive splitratio:
    --
    -- horizontal -> divider right
    -- vertical   -> divider down
    --
    -- Negative:
    --
    -- horizontal -> divider left
    -- vertical   -> divider up
    --
    --
    -- Therefore NO directional sign
    -- inversion is required:
    --
    -- SPAWN LEFT
    --   cursor right = grow
    --
    -- SPAWN RIGHT
    --   cursor left  = grow
    --
    -- SPAWN UP
    --   cursor down  = grow
    --
    -- SPAWN DOWN
    --   cursor up    = grow
    --------------------------------

    if splay_resize_spawned
        and splay_resize_spawn_direction then


        local direction =
            splay_resize_spawn_direction


        local pixels = 0


        if direction == "l"
            or direction == "r" then

            pixels = dx

        else

            pixels = dy

        end


        if pixels == 0 then
            return
        end


        --------------------------------
        -- Ensure splitratio targets the
        -- split containing the newly
        -- spawned tile.
        --
        -- follow_mouse may have changed
        -- focus while dragging across
        -- the neighbouring tile.
        --------------------------------

        hl.dispatch(
            hl.dsp.focus({
                window = window,
            })
        )


        --------------------------------
        -- Convert physical cursor
        -- movement to Dwindle ratio.
        --
        -- splay_resize_split_scale is
        -- calculated when the new tile
        -- appears.
        --------------------------------

        local delta =
            pixels
            / splay_resize_split_scale


        --------------------------------
        -- Avoid microscopic messages.
        --------------------------------

        if math.abs(delta) < 0.000001 then
            return
        end


        hl.dispatch(
            hl.dsp.layout(
                "splitratio "
                .. string.format(
                    "%.6f",
                    delta
                )
            )
        )


        return

    end


    --------------------------------
    ---- EXISTING TILE ------------
    --------------------------------
    --
    -- Existing tiles keep using the
    -- explicit resize dispatcher.
    --------------------------------

    local rx = 0
    local ry = 0


    -----------------------------
    -- RIGHT EDGE
    -----------------------------

    if edge == "r" then

        rx = dx


    -----------------------------
    -- LEFT EDGE
    -----------------------------

    elseif edge == "l" then

        rx = -dx


    -----------------------------
    -- BOTTOM EDGE
    -----------------------------

    elseif edge == "d" then

        ry = dy


    -----------------------------
    -- TOP EDGE
    -----------------------------

    elseif edge == "u" then

        ry = -dy

    end


    if rx == 0
        and ry == 0 then

        return
    end


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


    local window =
        splay_resize_window


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
    -- Existing tile waits until the
    -- drag threshold is crossed.
    --
    -- Spawned tile starts committed.
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

            distance =
                math.abs(dx)

        else

            distance =
                math.abs(dy)

        end


        if distance <
            SPLAY_DRAG_THRESHOLD then

            return
        end


        splay_resize_committed = true


        --------------------------------
        -- First normal resize consumes
        -- all accumulated cursor travel.
        --------------------------------

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
        -- Incremental resize.
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
    -- Feedback uses the ACTUAL tile
    -- geometry after Dwindle updates.
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
    spawned,
    spawn_direction
)

    if not window
        or not window.size
        or not edge then

        return
    end


    --------------------------------
    -- Clean stale operation.
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


    splay_resize_window =
        window

    splay_resize_edge =
        edge

    splay_resize_spawn_direction =
        spawn_direction


    splay_resize_start_x =
        cursor.x

    splay_resize_start_y =
        cursor.y

    splay_resize_last_x =
        cursor.x

    splay_resize_last_y =
        cursor.y


    --------------------------------
    -- Spawned tile is already in
    -- resize mode immediately.
    --------------------------------

    splay_resize_committed =
        spawned == true


    splay_resize_valid =
        splay_tile_is_valid(window)

    splay_resize_feedback_state = nil


    --------------------------------
    -- SPLIT SCALE
    --
    -- default_split_ratio uses:
    --
    --   0.1 for left/up
    --   1.9 for right/down
    --
    -- In both cases the newly-created
    -- tile starts at roughly 5% of its
    -- parent split.
    --
    -- Therefore:
    --
    -- parent dimension ≈ new size * 20
    --
    -- One splitratio unit represents
    -- roughly half the parent dimension,
    -- giving:
    --
    -- pixels per ratio ≈ new size * 10
    --
    -- This makes cursor movement track
    -- the divider much more naturally
    -- than a hard-coded sensitivity.
    --------------------------------

    if splay_resize_spawned
        and spawn_direction then


        if spawn_direction == "l"
            or spawn_direction == "r" then

            splay_resize_split_scale =
                math.max(
                    window.size.x * 10,
                    1
                )

        else

            splay_resize_split_scale =
                math.max(
                    window.size.y * 10,
                    1
                )

        end


    else

        splay_resize_split_scale = 1

    end


    --------------------------------
    -- Immediate feedback for new
    -- tile.
    --------------------------------

    if splay_resize_committed then

        splay_set_feedback(
            splay_resize_valid
        )

    end


    --------------------------------
    -- Resize is entirely driven by
    -- cursor sampling.
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
    -- Consume final mouse movement.
    --------------------------------

    splay_resize_tick()


    local window =
        splay_resize_window

    local committed =
        splay_resize_committed

    local valid =
        splay_resize_valid


    splay_stop_resize_timer()


    --------------------------------
    -- Not a resize:
    -- it was only the first click.
    --------------------------------

    if not committed then

        splay_reset_resize()

        return false

    end


    --------------------------------
    -- CYAN → keep.
    --------------------------------

    if valid then

        splay_clear_feedback(
            window
        )


    --------------------------------
    -- RED → close.
    --------------------------------

    else

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
    --
    -- New tile starts very small.
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
    -- Preselect requested side.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Mark before spawning.
    --------------------------------

    splay_spawn_generation =
        splay_spawn_generation + 1


    splay_spawn_pending = true
    splay_spawn_direction = direction


    --------------------------------
    -- Tile appears on the second
    -- press: click-and-a-half.
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
        -- Give Dwindle one tick to
        -- finish creating its split.
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
                -- User already released.
                --------------------------------

                if not splay_mouse_down then
                    return
                end


                --------------------------------
                -- Focus exact new tile.
                --------------------------------

                hl.dispatch(
                    hl.dsp.focus({
                        window = window,
                    })
                )


                --------------------------------
                -- Physical edge of the NEW
                -- tile touching the old one.
                --------------------------------

                local edge =
                    splay_opposite_edge(
                        direction
                    )


                --------------------------------
                -- Enter resize immediately.
                --
                -- Spawn direction is retained
                -- because splitratio uses the
                -- orientation of the split.
                --------------------------------

                splay_begin_resize(
                    window,
                    edge,
                    true,
                    direction
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
        -- Not on a tile edge.
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
        -- Same edge direction inside
        -- the 250 ms interval.
        --------------------------------

        if splay_click_pending
            and splay_click_direction
                == direction then


            splay_cancel_click()


            splay_press_kind =
                "spawn"

            splay_press_direction =
                direction


            --------------------------------
            -- Instantiate immediately.
            --------------------------------

            splay_spawn_tile(
                direction
            )


            return

        end


        --------------------------------
        -- Different edge cancels old
        -- click sequence.
        --------------------------------

        if splay_click_pending then
            splay_cancel_click()
        end


        --------------------------------
        -- Possible normal resize.
        --------------------------------

        splay_press_kind =
            "normal"

        splay_press_direction =
            direction


        splay_begin_resize(
            window,
            direction,
            false,
            nil
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
        -- Finish active resize.
        --------------------------------

        local resized =
            splay_end_resize()


        if resized then

            splay_press_kind = nil
            splay_press_direction = nil

            return
        end


        --------------------------------
        -- Second press created a tile.
        --
        -- Do not reinterpret it as the
        -- first click of another cycle.
        --------------------------------

        if press_kind == "spawn" then

            splay_spawn_pending = false
            splay_spawn_direction = nil

            splay_press_kind = nil
            splay_press_direction = nil

            return
        end


        --------------------------------
        -- No resize occurred:
        --
        -- this was the first click.
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
