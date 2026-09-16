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

local splay_press_action = nil
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
local splay_spawn_generation = 0


--------------------------------
---- SPLAY RESIZE STATE --------
--------------------------------

local splay_resize_tracking = false
local splay_resize_committed = false

local splay_resize_window = nil

local splay_resize_initial_width = 0
local splay_resize_initial_height = 0

local splay_resize_valid = true
local splay_resize_feedback_state = nil

local splay_resize_timer = nil


--------------------------------
---- SPLAY RESIZE SETTINGS -----
--------------------------------

local SPLAY_MIN_WIDTH  = 160
local SPLAY_MIN_HEIGHT = 120

local SPLAY_RESIZE_EPSILON = 1

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
    -- BOTTOM EDGE ----
    -------------------

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

    local cursor =
        hl.get_cursor_pos()


    if not cursor then
        return nil, nil
    end


    --------------------------------
    -- Prefer active tile.
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
    -- Fallback to every other tile.
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
---- SPLAY TILE VALIDITY -------
--------------------------------

local function splay_tile_is_valid(window)

    if not window
        or not window.size then

        return true
    end


    return window.size.x
            >= SPLAY_MIN_WIDTH

        and window.size.y
            >= SPLAY_MIN_HEIGHT

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


    --------------------------------
    -- Avoid repeatedly sending the
    -- same properties every 16 ms.
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


    splay_resize_tracking = false
    splay_resize_committed = false

    splay_resize_window = nil

    splay_resize_initial_width = 0
    splay_resize_initial_height = 0

    splay_resize_valid = true
    splay_resize_feedback_state = nil

end


--------------------------------
---- SPLAY RESIZE TICK ---------
--------------------------------

local function splay_resize_tick()

    if not splay_resize_tracking then
        return
    end


    local window =
        splay_resize_window


    if not window
        or not window.size then

        return
    end


    --------------------------------
    -- Normal edge press:
    --
    -- it only becomes a resize once
    -- geometry actually changes.
    --
    -- Initial spawn resize starts
    -- committed immediately.
    --------------------------------

    if not splay_resize_committed then

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

            splay_resize_committed = true

        else

            return

        end

    end


    --------------------------------
    -- The value stored here is the
    -- exact state represented by the
    -- cyan/red border.
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
    immediate
)

    if not window
        or not window.size then

        return
    end


    --------------------------------
    -- Clean stale state.
    --------------------------------

    if splay_resize_tracking then

        splay_clear_feedback(
            splay_resize_window
        )

        splay_reset_resize()

    end


    --------------------------------
    -- Interactive resize works on
    -- the active window.
    --------------------------------

    hl.dispatch(
        hl.dsp.focus({
            window = window,
        })
    )


    splay_resize_tracking = true
    splay_resize_window = window

    splay_resize_initial_width =
        window.size.x

    splay_resize_initial_height =
        window.size.y


    --------------------------------
    -- Newly spawned tiles enter
    -- resize state immediately.
    --------------------------------

    splay_resize_committed =
        immediate == true


    splay_resize_valid =
        splay_tile_is_valid(window)

    splay_resize_feedback_state = nil


    --------------------------------
    -- New tiles show feedback from
    -- their very first frame.
    --------------------------------

    if splay_resize_committed then

        splay_set_feedback(
            splay_resize_valid
        )

    end


    --------------------------------
    -- Track real geometry.
    --------------------------------

    splay_resize_timer = hl.timer(
        function()

            splay_resize_tick()

        end,
        {
            timeout = 16,
            type = "repeat",
        }
    )


    --------------------------------
    -- Begin interactive resize using
    -- the currently held button.
    --------------------------------

    hl.dispatch(
        hl.dsp.window.resize()
    )

end


--------------------------------
---- SPLAY CLOSE TILE ----------
--------------------------------

local function splay_close_tile(window)

    if not window then
        return
    end


    --------------------------------
    -- Preserve a stable selector.
    --
    -- Closing one event-loop tick
    -- later prevents competing with
    -- Hyprland finishing the active
    -- mouse resize.
    --------------------------------

    local target = nil


    if window.address then

        target =
            "address:"
            .. tostring(window.address)

    end


    hl.timer(
        function()

            if target then

                hl.dispatch(
                    hl.dsp.window.close({
                        window = target,
                    })
                )

            else

                hl.dispatch(
                    hl.dsp.window.close({
                        window = window,
                    })
                )

            end

        end,
        {
            timeout = 1,
            type = "oneshot",
        }
    )

end


--------------------------------
---- SPLAY END RESIZE ----------
--------------------------------

local function splay_end_resize()

    if not splay_resize_tracking then
        return false
    end


    --------------------------------
    -- One last sample.
    --
    -- IMPORTANT:
    -- afterwards we use the stored
    -- splay_resize_valid value.
    --
    -- Therefore the action always
    -- agrees with the last cyan/red
    -- feedback shown to the user.
    --------------------------------

    splay_resize_tick()


    local window =
        splay_resize_window


    local committed =
        splay_resize_committed


    --------------------------------
    -- No geometry change:
    -- ordinary click, not resize.
    --------------------------------

    if not committed then

        splay_reset_resize()

        return false

    end


    --------------------------------
    -- This is deliberately NOT a new
    -- independent size calculation.
    --
    -- Red must always mean CLOSE.
    -- Cyan must always mean KEEP.
    --------------------------------

    local valid =
        splay_resize_valid


    splay_stop_resize_timer()


    if valid then

        --------------------------------
        -- CYAN → keep tile.
        --------------------------------

        splay_clear_feedback(window)

    else

        --------------------------------
        -- RED → close tile.
        --
        -- Keep the red border visible
        -- until the tile disappears.
        --------------------------------

        splay_close_tile(window)

    end


    --------------------------------
    -- Reset interaction state.
    --------------------------------

    splay_resize_tracking = false
    splay_resize_committed = false

    splay_resize_window = nil

    splay_resize_initial_width = 0
    splay_resize_initial_height = 0

    splay_resize_valid = true
    splay_resize_feedback_state = nil


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
    -- Double-click time window.
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
    -- Tell Dwindle which side gets
    -- the new tile.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Mark the spawn BEFORE exec so
    -- window.open can claim it.
    --------------------------------

    splay_spawn_generation =
        splay_spawn_generation + 1


    splay_spawn_pending = true
    splay_spawn_direction = direction


    --------------------------------
    -- SECOND PRESS:
    --
    -- The tile is instantiated NOW,
    -- not after releasing.
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
        -- Hyprland 0.56.x may require
        -- one event-loop iteration after
        -- window.open before doing layout
        -- interaction.
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


                --------------------------------
                -- This new window belongs to
                -- our pending Splay spawn.
                --------------------------------

                splay_spawn_pending = false
                splay_spawn_direction = nil


                --------------------------------
                -- CLICK AND A HALF:
                --
                -- The user's second press is
                -- still physically held.
                --
                -- Immediately turn this new
                -- tile into an active resize.
                --------------------------------

                if splay_mouse_down then

                    splay_begin_resize(
                        window,
                        true
                    )

                end

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

        splay_press_action = nil
        splay_press_direction = nil
        splay_press_window = nil


        local direction, window =
            get_splay_edge()


        if not direction
            or not window then

            return
        end


        --------------------------------
        -- SECOND PRESS
        --
        -- We deliberately require only
        -- the same edge direction.
        --
        -- Shared tiled edges can change
        -- which adjacent window Hyprland
        -- reports under the cursor, so
        -- comparing window addresses here
        -- makes the double-click fragile.
        --------------------------------

        if splay_click_pending
            and splay_click_direction
                == direction then


            splay_cancel_click()


            splay_press_action =
                "spawn"

            splay_press_direction =
                direction

            splay_press_window =
                window


            --------------------------------
            -- CLICK AND A HALF:
            -- create immediately.
            --------------------------------

            splay_spawn_tile(
                direction
            )


            return

        end


        --------------------------------
        -- A different edge starts a new
        -- click sequence.
        --------------------------------

        if splay_click_pending then
            splay_cancel_click()
        end


        --------------------------------
        -- NORMAL EDGE PRESS
        --
        -- Begin a possible resize.
        --
        -- If geometry never changes,
        -- release reinterprets this as
        -- the first click.
        --------------------------------

        splay_press_action =
            "normal"

        splay_press_direction =
            direction

        splay_press_window =
            window


        splay_begin_resize(
            window,
            false
        )

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

        splay_mouse_down = false


        --------------------------------
        -- Preserve press information
        -- before anything resets state.
        --------------------------------

        local action =
            splay_press_action

        local direction =
            splay_press_direction


        --------------------------------
        -- Finalize active resize.
        --------------------------------

        local resized =
            splay_end_resize()


        --------------------------------
        -- Real resize completed:
        -- cyan kept it / red closed it.
        --------------------------------

        if resized then

            splay_press_action = nil
            splay_press_direction = nil
            splay_press_window = nil

            return

        end


        --------------------------------
        -- SECOND PRESS that created a
        -- tile must never be interpreted
        -- as another "first click".
        --------------------------------

        if action == "spawn" then

            splay_press_action = nil
            splay_press_direction = nil
            splay_press_window = nil

            return

        end


        --------------------------------
        -- No geometry changed.
        --
        -- This was therefore the first
        -- click of the click-and-a-half
        -- subdivision gesture.
        --------------------------------

        if action == "normal"
            and direction then

            splay_arm_click(
                direction
            )

        end


        splay_press_action = nil
        splay_press_direction = nil
        splay_press_window = nil

    end,
    {
        --------------------------------
        -- Plain release callback.
        --
        -- In 0.56.2 there have been
        -- reports involving mouse bind
        -- release state; keeping this
        -- separate from the interactive
        -- mouse dispatcher makes our
        -- state transition idempotent.
        --------------------------------

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
