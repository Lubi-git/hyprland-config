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

local launcher = "kitty -o confirm_os_window_close=0 -e lapi-launcher"


--------------------------------
---- SPLAY STATE ---------------
--------------------------------

local splay_mouse_down = false

local splay_press_kind = nil
local splay_press_direction = nil
local splay_press_window = nil


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
local splay_spawn_parent_dimension = 0
local splay_spawn_generation = 0


--------------------------------
---- SPLAY RESIZE STATE --------
--------------------------------

-- nil / "native" / "spawn"
local splay_resize_mode = nil

local splay_resize_active = false
local splay_resize_committed = false

local splay_resize_window = nil

local splay_resize_initial_width = 0
local splay_resize_initial_height = 0

local splay_resize_last_x = 0
local splay_resize_last_y = 0

local splay_resize_spawn_direction = nil
local splay_resize_parent_dimension = 0

local splay_resize_valid = true
local splay_resize_feedback_state = nil

local splay_resize_timer = nil


--------------------------------
---- SPLAY INTERNAL STATE ------
--------------------------------

local splay_native_resize_enabled = true
local splay_focus_locked = false

-- Prevent duplicate automatic launcher spawns
-- while the root tile is still opening.
local splay_root_launch_pending = false


--------------------------------
---- SPLAY SETTINGS ------------
--------------------------------

-- New tiles try to appear as a thin
-- extrusion of this many pixels.
local SPLAY_SPAWN_SIZE = 96

-- Tile survival threshold.
local SPLAY_MIN_WIDTH  = 50
local SPLAY_MIN_HEIGHT = 50

-- Detect that a native Hyprland resize
-- actually changed the tile.
local SPLAY_RESIZE_EPSILON = 1

-- Observer / extrusion update interval.
local SPLAY_RESIZE_INTERVAL = 16

-- Cyan / red resize feedback.
local SPLAY_FEEDBACK_BORDER = 5

local SPLAY_FEEDBACK_KEEP =
    "rgb(00D9FF)"

local SPLAY_FEEDBACK_CLOSE =
    "rgb(FF3B30)"

-- Normal Dwindle ratio outside the
-- temporary Splay extrusion operation.
local SPLAY_DEFAULT_SPLIT_RATIO = 1.0


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
        -- NORMAL RESIZING IS NATIVE.
        --------------------------------

        resize_on_border = true,
        extend_border_grab_area = 10,

        allow_tearing = false,

        layout = "dwindle",
    },

    --------------------------------
    -- Focus changes must never move
    -- the user's physical pointer.
    --------------------------------

    cursor = {
        no_warps = true,
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

        -- Let Hyprland determine native
        -- resize direction using cursor
        -- position around the tile.
        smart_resizing = true,

        -- Explicitly prefer active tile
        -- for preselect / split messages.
        use_active_for_splits = true,

        split_bias = 0,

        default_split_ratio =
            SPLAY_DEFAULT_SPLIT_RATIO,
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

        -- Our gesture listener must not
        -- prevent Hyprland from performing
        -- its native border drag.
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


--------------------------------
---- SPLAY EDGE FOR WINDOW -----
--------------------------------

local function splay_edge_for_window(
    window,
    cursor
)

    if not window
        or not window.at
        or not window.size then

        return nil
    end


    local x = window.at.x
    local y = window.at.y

    local w = window.size.x
    local h = window.size.y

    local cx = cursor.x
    local cy = cursor.y


    if cx >= x - 10
        and cx <= x + 10
        and cy >= y
        and cy <= y + h then

        return "l"
    end


    if cx >= x + w - 10
        and cx <= x + w + 10
        and cy >= y
        and cy <= y + h then

        return "r"
    end


    if cy >= y - 10
        and cy <= y + 10
        and cx >= x
        and cx <= x + w then

        return "u"
    end


    if cy >= y + h - 10
        and cy <= y + h + 10
        and cx >= x
        and cx <= x + w then

        return "d"
    end


    return nil

end


--------------------------------
---- SPLAY EDGE DETECTION ------
--------------------------------

local function get_splay_edge()

    local cursor = hl.get_cursor_pos()

    if not cursor then
        return nil, nil
    end


    --------------------------------
    -- Prefer active tile because a
    -- shared gap may match both.
    --------------------------------

    local active =
        hl.get_active_window()


    if active then

        local direction =
            splay_edge_for_window(
                active,
                cursor
            )


        if direction then
            return direction, active
        end

    end


    --------------------------------
    -- Fallback to all other tiles.
    --------------------------------

    local windows =
        hl.get_windows()


    for _, window in ipairs(windows) do

        local same = false


        if active
            and active.address
            and window.address then

            same =
                active.address
                == window.address
        end


        if not same then

            local direction =
                splay_edge_for_window(
                    window,
                    cursor
                )


            if direction then
                return direction, window
            end

        end

    end


    return nil, nil

end


--------------------------------
---- TILE VALIDITY -------------
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
---- SET WINDOW PROP -----------
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
---- RESIZE FEEDBACK -----------
--------------------------------

local function splay_set_feedback(valid)

    local window =
        splay_resize_window


    if not window then
        return
    end


    local state =
        valid and "keep" or "close"


    if state ==
        splay_resize_feedback_state then

        return
    end


    splay_resize_feedback_state =
        state


    local color =
        valid
        and SPLAY_FEEDBACK_KEEP
        or SPLAY_FEEDBACK_CLOSE


    splay_set_prop(
        window,
        "border_size",
        tostring(SPLAY_FEEDBACK_BORDER)
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
---- CLEAR FEEDBACK ------------
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
---- NATIVE RESIZE SWITCH ------
--------------------------------

local function splay_set_native_resize(enabled)

    if splay_native_resize_enabled
        == enabled then

        return
    end


    splay_native_resize_enabled =
        enabled


    hl.config({
        general = {
            resize_on_border =
                enabled,
        },
    })

end


--------------------------------
---- FOCUS LOCK ----------------
--------------------------------

local function splay_lock_focus()

    if splay_focus_locked then
        return
    end


    splay_focus_locked = true


    hl.config({
        input = {
            follow_mouse = 0,
        },
    })

end


local function splay_unlock_focus()

    if not splay_focus_locked then
        return
    end


    splay_focus_locked = false


    hl.config({
        input = {
            follow_mouse = 1,
        },
    })

end


--------------------------------
---- RESTORE SPLIT DEFAULT -----
--------------------------------

local function splay_restore_split_default()

    hl.config({
        dwindle = {
            default_split_ratio =
                SPLAY_DEFAULT_SPLIT_RATIO,
        },
    })

end


--------------------------------
---- STOP RESIZE TIMER ---------
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
---- RESET RESIZE --------------
--------------------------------

local function splay_reset_resize()

    splay_stop_resize_timer()


    splay_resize_mode = nil

    splay_resize_active = false
    splay_resize_committed = false

    splay_resize_window = nil

    splay_resize_initial_width = 0
    splay_resize_initial_height = 0

    splay_resize_last_x = 0
    splay_resize_last_y = 0

    splay_resize_spawn_direction = nil
    splay_resize_parent_dimension = 0

    splay_resize_valid = true
    splay_resize_feedback_state = nil

end


--------------------------------
---- CLOSE TILE ----------------
--------------------------------

local function splay_close_tile(window)

    if not window then
        return
    end


    --------------------------------
    -- Let Hyprland finish the mouse
    -- release / native resize first.
    --------------------------------

    hl.timer(
        function()

            hl.dispatch(
                hl.dsp.window.close({
                    window = window,
                })
            )

        end,
        {
            timeout = 1,
            type = "oneshot",
        }
    )

end


--------------------------------
---- NATIVE RESIZE OBSERVER ----
--------------------------------

local function splay_begin_native_resize(
    window
)

    if not window
        or not window.size then

        return
    end


    if splay_resize_active then
        splay_reset_resize()
    end


    splay_resize_mode =
        "native"

    splay_resize_active =
        true

    splay_resize_committed =
        false

    splay_resize_window =
        window

    splay_resize_initial_width =
        window.size.x

    splay_resize_initial_height =
        window.size.y

    splay_resize_valid =
        splay_tile_is_valid(window)

    splay_resize_feedback_state =
        nil


    --------------------------------
    -- IMPORTANT:
    --
    -- We do NOT resize anything.
    --
    -- Hyprland's native
    -- resize_on_border is doing it.
    --
    -- Lua merely observes geometry.
    --------------------------------

    splay_resize_timer = hl.timer(
        function()

            if not splay_resize_active
                or splay_resize_mode
                    ~= "native" then

                return
            end


            local current =
                splay_resize_window


            if not current
                or not current.size then

                return
            end


            local dw =
                math.abs(
                    current.size.x
                    - splay_resize_initial_width
                )

            local dh =
                math.abs(
                    current.size.y
                    - splay_resize_initial_height
                )


            if not splay_resize_committed then

                if dw >= SPLAY_RESIZE_EPSILON
                    or dh >= SPLAY_RESIZE_EPSILON then

                    splay_resize_committed =
                        true

                else

                    return

                end

            end


            splay_resize_valid =
                splay_tile_is_valid(
                    current
                )


            splay_set_feedback(
                splay_resize_valid
            )

        end,
        {
            timeout = SPLAY_RESIZE_INTERVAL,
            type = "repeat",
        }
    )

end


--------------------------------
---- SPAWN RESIZE TICK ---------
--------------------------------

local function splay_spawn_resize_tick()

    if not splay_resize_active
        or splay_resize_mode
            ~= "spawn" then

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


    local dx =
        cursor.x
        - splay_resize_last_x

    local dy =
        cursor.y
        - splay_resize_last_y


    local pixels = 0


    if splay_resize_spawn_direction == "l"
        or splay_resize_spawn_direction == "r" then

        pixels = dx

    else

        pixels = dy

    end


    --------------------------------
    -- The Dwindle ratio represents
    -- twice the top/left fraction.
    --
    -- Therefore:
    --
    -- delta_ratio =
    --     2 * delta_pixels
    --       / original_parent_size
    --
    -- No directional sign inversion is
    -- needed:
    --
    -- LEFT  : right grows new tile
    -- RIGHT : left grows new tile
    -- UP    : down grows new tile
    -- DOWN  : up grows new tile
    --------------------------------

    if pixels ~= 0
        and splay_resize_parent_dimension > 0 then


        local delta =
            (2 * pixels)
            / splay_resize_parent_dimension


        if math.abs(delta) >= 0.000001 then

            hl.dispatch(
                hl.dsp.layout(
                    "splitratio "
                    .. string.format(
                        "%+.6f",
                        delta
                    )
                )
            )

        end

    end


    splay_resize_last_x =
        cursor.x

    splay_resize_last_y =
        cursor.y


    splay_resize_valid =
        splay_tile_is_valid(
            window
        )


    splay_set_feedback(
        splay_resize_valid
    )

end


--------------------------------
---- BEGIN SPAWN RESIZE --------
--------------------------------

local function splay_begin_spawn_resize(
    window,
    direction,
    parent_dimension
)

    if not window
        or not window.size then

        return
    end


    if splay_resize_active then

        splay_reset_resize()

    end


    local cursor =
        hl.get_cursor_pos()


    if not cursor then

        splay_unlock_focus()
        splay_set_native_resize(true)

        return

    end


    --------------------------------
    -- Native border resize remains
    -- disabled only for this special
    -- click-and-a-half extrusion.
    --------------------------------

    splay_resize_mode =
        "spawn"

    splay_resize_active =
        true

    splay_resize_committed =
        true

    splay_resize_window =
        window

    splay_resize_spawn_direction =
        direction

    splay_resize_parent_dimension =
        math.max(
            parent_dimension,
            1
        )

    splay_resize_last_x =
        cursor.x

    splay_resize_last_y =
        cursor.y

    splay_resize_valid =
        splay_tile_is_valid(
            window
        )

    splay_resize_feedback_state =
        nil


    --------------------------------
    -- A freshly extruded tile is
    -- already in resize state before
    -- any cursor movement.
    --------------------------------

    splay_set_feedback(
        splay_resize_valid
    )


    splay_resize_timer = hl.timer(
        function()

            splay_spawn_resize_tick()

        end,
        {
            timeout = SPLAY_RESIZE_INTERVAL,
            type = "repeat",
        }
    )

end


--------------------------------
---- END RESIZE ----------------
--------------------------------

local function splay_end_resize()

    if not splay_resize_active then
        return false
    end


    local mode =
        splay_resize_mode


    --------------------------------
    -- Consume final cursor position
    -- for initial extrusion.
    --------------------------------

    if mode == "spawn" then

        splay_spawn_resize_tick()

    end


    local window =
        splay_resize_window

    local committed =
        splay_resize_committed

    local valid =
        splay_resize_valid


    --------------------------------
    -- Native resize gets one final
    -- direct geometry sample.
    --------------------------------

    if mode == "native"
        and window
        and window.size then


        local dw =
            math.abs(
                window.size.x
                - splay_resize_initial_width
            )

        local dh =
            math.abs(
                window.size.y
                - splay_resize_initial_height
            )


        if dw >= SPLAY_RESIZE_EPSILON
            or dh >= SPLAY_RESIZE_EPSILON then

            committed = true

            valid =
                splay_tile_is_valid(
                    window
                )

        end

    end


    splay_stop_resize_timer()


    --------------------------------
    -- Plain press/release:
    -- this was a click, not a resize.
    --------------------------------

    if not committed then

        splay_reset_resize()

        return false

    end


    --------------------------------
    -- CYAN -> keep.
    --------------------------------

    if valid then

        splay_clear_feedback(
            window
        )


    --------------------------------
    -- RED -> collapse.
    --------------------------------

    else

        splay_close_tile(
            window
        )

    end


    splay_reset_resize()


    --------------------------------
    -- Spawn extrusion temporarily
    -- owns focus and disables native
    -- border resize.
    --------------------------------

    if mode == "spawn" then

        splay_unlock_focus()
        splay_set_native_resize(true)
        splay_restore_split_default()

    end


    return true

end


--------------------------------
---- ARM FIRST CLICK -----------
--------------------------------

local function splay_arm_click(
    direction
)

    splay_click_generation =
        splay_click_generation + 1


    local generation =
        splay_click_generation


    splay_click_pending =
        true

    splay_click_direction =
        direction


    --------------------------------
    -- During the 250 ms window we
    -- disable native border resize.
    --
    -- This prevents the SECOND PRESS
    -- from beginning a resize on the
    -- old tile before Splay spawns
    -- the new one.
    --------------------------------

    splay_set_native_resize(false)


    hl.timer(
        function()

            if generation ~=
                splay_click_generation then

                return
            end


            splay_click_pending =
                false

            splay_click_direction =
                nil


            splay_set_native_resize(
                true
            )

        end,
        {
            timeout = 250,
            type = "oneshot",
        }
    )

end


--------------------------------
---- CANCEL CLICK --------------
--------------------------------

local function splay_cancel_click(
    keep_native_locked
)

    splay_click_generation =
        splay_click_generation + 1


    splay_click_pending =
        false

    splay_click_direction =
        nil


    if not keep_native_locked then

        splay_set_native_resize(
            true
        )

    end

end


--------------------------------
---- COMPUTE SPAWN RATIO -------
--------------------------------

local function splay_get_spawn_ratio(
    direction,
    source_window
)

    if not source_window
        or not source_window.size then

        return nil, nil
    end


    local dimension


    if direction == "l"
        or direction == "r" then

        dimension =
            source_window.size.x

    else

        dimension =
            source_window.size.y

    end


    if not dimension
        or dimension <= 0 then

        return nil, nil
    end


    --------------------------------
    -- Desired fixed-pixel extrusion.
    --------------------------------

    local fraction =
        SPLAY_SPAWN_SIZE
        / dimension


    --------------------------------
    -- Dwindle supports ratios
    -- 0.1 .. 1.9, corresponding to
    -- approximately 5% .. 95%.
    --------------------------------

    fraction =
        math.max(
            0.05,
            math.min(
                0.95,
                fraction
            )
        )


    local ratio


    if direction == "l"
        or direction == "u" then

        --------------------------------
        -- New tile occupies top/left
        -- half of split.
        --------------------------------

        ratio =
            2 * fraction

    else

        --------------------------------
        -- New tile occupies bottom/right
        -- half, so top/left keeps the
        -- remaining fraction.
        --------------------------------

        ratio =
            2 * (1 - fraction)

    end


    ratio =
        math.max(
            0.1,
            math.min(
                1.9,
                ratio
            )
        )


    return ratio, dimension

end


--------------------------------
---- CANCEL SPAWN --------------
--------------------------------

local function splay_cancel_spawn()

    splay_spawn_generation =
        splay_spawn_generation + 1


    splay_spawn_pending =
        false

    splay_spawn_direction =
        nil

    splay_spawn_parent_dimension =
        0


    splay_restore_split_default()

    splay_unlock_focus()

    splay_set_native_resize(
        true
    )

end


--------------------------------
---- SPAWN TILE ----------------
--------------------------------

local function splay_spawn_tile(
    direction,
    source_window
)

    local ratio, dimension =
        splay_get_spawn_ratio(
            direction,
            source_window
        )


    if not ratio
        or not dimension then

        splay_set_native_resize(
            true
        )

        return
    end


    --------------------------------
    -- Lock focus for the duration of
    -- the click-and-a-half extrusion.
    --------------------------------

    splay_lock_focus()


    --------------------------------
    -- Ensure Dwindle splits exactly
    -- the tile whose edge generated
    -- the gesture.
    --------------------------------

    hl.dispatch(
        hl.dsp.focus({
            window = source_window,
        })
    )


    --------------------------------
    -- Fixed-pixel visual extrusion.
    --------------------------------

    hl.config({
        dwindle = {
            default_split_ratio =
                ratio,
        },
    })


    --------------------------------
    -- New tile grows inward from the
    -- selected edge.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect "
            .. direction
        )
    )


    splay_spawn_generation =
        splay_spawn_generation + 1


    splay_spawn_pending =
        true

    splay_spawn_direction =
        direction

    splay_spawn_parent_dimension =
        dimension


    --------------------------------
    -- Tile is instantiated on the
    -- SECOND PRESS, not release.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(
            launcher
        )
    )

end


--------------------------------
---- NEW TILE OPENED -----------
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

        local parent_dimension =
            splay_spawn_parent_dimension


        --------------------------------
        -- Let Dwindle complete insertion
        -- before touching the new split.
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


                splay_spawn_pending =
                    false

                splay_spawn_direction =
                    nil

                splay_spawn_parent_dimension =
                    0


                --------------------------------
                -- Ratio only applies to this
                -- insertion.
                --------------------------------

                splay_restore_split_default()


                --------------------------------
                -- User released before the
                -- client became usable.
                --------------------------------

                if not splay_mouse_down then

                    splay_unlock_focus()

                    splay_set_native_resize(
                        true
                    )

                    return

                end


                --------------------------------
                -- splitratio acts on the active
                -- Dwindle split.
                --
                -- Focus the new tile ONCE.
                --------------------------------

                hl.dispatch(
                    hl.dsp.focus({
                        window = window,
                    })
                )


                --------------------------------
                -- Same held second press now
                -- becomes the extrusion resize.
                --------------------------------

                splay_begin_spawn_resize(
                    window,
                    direction,
                    parent_dimension
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
---- MOUSE PRESS ---------------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        splay_mouse_down =
            true

        splay_press_kind =
            nil

        splay_press_direction =
            nil

        splay_press_window =
            nil


        local direction, window =
            get_splay_edge()


        --------------------------------
        -- Ordinary click away from an
        -- edge: Splay does nothing.
        --------------------------------

        if not direction
            or not window then

            if splay_click_pending then

                splay_cancel_click(
                    false
                )

            end

            return

        end


        --------------------------------
        -- SECOND PRESS:
        --
        -- same edge direction inside
        -- the 250 ms Splay window.
        --------------------------------

        if splay_click_pending
            and splay_click_direction
                == direction then


            --------------------------------
            -- Keep native resize disabled:
            -- this press belongs to Splay's
            -- extrusion gesture.
            --------------------------------

            splay_cancel_click(
                true
            )


            splay_press_kind =
                "spawn"

            splay_press_direction =
                direction

            splay_press_window =
                window


            splay_spawn_tile(
                direction,
                window
            )


            return

        end


        --------------------------------
        -- Different edge ends previous
        -- click sequence.
        --------------------------------

        if splay_click_pending then

            splay_cancel_click(
                false
            )

        end


        --------------------------------
        -- NORMAL PRESS:
        --
        -- Hyprland performs the actual
        -- border resize natively.
        --
        -- Splay only watches geometry.
        --------------------------------

        splay_press_kind =
            "normal"

        splay_press_direction =
            direction

        splay_press_window =
            window


        splay_begin_native_resize(
            window
        )

    end
)


--------------------------------
---- MOUSE RELEASE -------------
--------------------------------

hl.bind(
    "mouse:272",
    function()

        splay_mouse_down =
            false


        local press_kind =
            splay_press_kind

        local press_direction =
            splay_press_direction


        --------------------------------
        -- Finalize native observation
        -- or initial extrusion.
        --------------------------------

        local resized =
            splay_end_resize()


        if resized then

            splay_press_kind = nil
            splay_press_direction = nil
            splay_press_window = nil

            return

        end


        --------------------------------
        -- Spawn press released before
        -- window.open claimed it.
        --------------------------------

        if press_kind ==
            "spawn" then


            if splay_spawn_pending then

                splay_cancel_spawn()

            else

                splay_unlock_focus()

                splay_set_native_resize(
                    true
                )

                splay_restore_split_default()

            end


            splay_press_kind = nil
            splay_press_direction = nil
            splay_press_window = nil

            return

        end


        --------------------------------
        -- No geometry changed:
        --
        -- this was the FIRST click of
        -- the Splay click-and-a-half.
        --------------------------------

        if press_kind ==
            "normal"
            and press_direction then


            splay_arm_click(
                press_direction
            )

        end


        splay_press_kind = nil
        splay_press_direction = nil
        splay_press_window = nil

    end,
    {
        release = true,
    }
)


--------------------------------
---- SPLAY ROOT TILE -----------
--------------------------------

local function splay_active_workspace_has_tile()

    local workspace =
        hl.get_active_workspace()


    if not workspace then
        return false
    end


    local windows =
        hl.get_windows()


    for _, window in ipairs(windows) do

        if window
            and window.workspace == workspace
            and window.mapped
            and not window.floating then

            return true

        end

    end


    return false

end


--------------------------------
---- ENSURE ROOT TILE ----------
--------------------------------

local function splay_ensure_root_tile()

    if splay_active_workspace_has_tile() then

        splay_root_launch_pending =
            false

        return

    end


    if splay_root_launch_pending then
        return
    end


    splay_root_launch_pending =
        true


    --------------------------------
    -- An empty Splay workspace has
    -- a single neutral state:
    -- LAPI Launcher as its root tile.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(
            launcher
        )
    )

end


--------------------------------
---- SCHEDULE ROOT CHECK -------
--------------------------------

local function splay_schedule_root_check()

    hl.timer(
        function()

            splay_ensure_root_tile()

        end,
        {
            timeout = 1,
            type = "oneshot",
        }
    )

end


--------------------------------
---- ROOT TILE EVENTS ----------
--------------------------------

hl.on(
    "hyprland.start",
    function()

        splay_schedule_root_check()

    end
)


hl.on(
    "config.reloaded",
    function()

        splay_schedule_root_check()

    end
)


hl.on(
    "workspace.active",
    function()

        splay_schedule_root_check()

    end
)


hl.on(
    "window.destroy",
    function()

        splay_schedule_root_check()

    end
)


hl.on(
    "window.move_to_workspace",
    function()

        splay_schedule_root_check()

    end
)


--------------------------------
---- ROOT TILE OPENED ----------
--------------------------------

hl.on(
    "window.open",
    function(window)

        local workspace =
            hl.get_active_workspace()


        if not workspace
            or not window then

            return

        end


        if window.workspace == workspace
            and window.mapped
            and not window.floating then

            splay_root_launch_pending =
                false

        else

            --------------------------------
            -- A floating window is not a tile.
            -- If it is the only window visible,
            -- preserve the Splay root beneath it.
            --------------------------------

            splay_schedule_root_check()

        end

    end
)


--------------------------------
---- INITIAL ROOT CHECK --------
--------------------------------

-- Also covers config evaluation paths where
-- hyprland.start has already fired.
splay_schedule_root_check()


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
