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


--------------------------------
---- SPLAY CLICK STATE ---------
--------------------------------

local splay_click_pending = false
local splay_click_direction = nil
local splay_click_window_address = nil
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
local splay_resize_changed = false

local splay_resize_window = nil
local splay_resize_direction = nil

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

-- Geometry must actually change before
-- the interaction counts as a resize.
local SPLAY_RESIZE_EPSILON = 1

-- Temporary feedback border.
local SPLAY_FEEDBACK_BORDER = 5

-- Tile survives.
local SPLAY_FEEDBACK_KEEP =
    "rgb(00D9FF)"

-- Tile will be removed.
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

    if not window then
        return nil
    end


    if not window.at
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
    -- Prefer the active tile.
    --
    -- Shared tiled borders can belong
    -- geometrically to two windows.
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
    -- Fallback for any other tile
    -- under the cursor.
    --------------------------------

    local windows =
        hl.get_windows()


    for _, window in ipairs(windows) do

        local same_as_active = false


        if active
            and active.address
            and window.address then

            same_as_active =
                active.address
                == window.address

        end


        if not same_as_active then

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


    local width =
        window.size.x

    local height =
        window.size.y


    return width >= SPLAY_MIN_WIDTH
        and height >= SPLAY_MIN_HEIGHT

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
    -- Do not dispatch identical
    -- properties every 16 ms.
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


    --------------------------------
    -- Hyprland 0.56.2 dynamic
    -- window properties.
    --------------------------------

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


    --------------------------------
    -- Return to normal SplayDE
    -- borderless state.
    --------------------------------

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
    splay_resize_changed = false

    splay_resize_window = nil
    splay_resize_direction = nil

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


    local width =
        window.size.x

    local height =
        window.size.y


    --------------------------------
    -- Detect whether the interaction
    -- has actually become a resize.
    --
    -- This keeps a normal click from
    -- flashing a feedback border.
    --------------------------------

    if not splay_resize_changed then

        local dw =
            math.abs(
                width
                - splay_resize_initial_width
            )


        local dh =
            math.abs(
                height
                - splay_resize_initial_height
            )


        if dw >= SPLAY_RESIZE_EPSILON
            or dh >= SPLAY_RESIZE_EPSILON then

            splay_resize_changed = true

        else

            return

        end

    end


    --------------------------------
    -- Once actual resizing exists,
    -- continuously evaluate whether
    -- releasing now keeps or closes
    -- the tile.
    --------------------------------

    local valid =
        splay_tile_is_valid(window)


    splay_resize_valid =
        valid


    splay_set_feedback(valid)

end


--------------------------------
---- SPLAY BEGIN RESIZE --------
--------------------------------

local function splay_begin_resize(
    window,
    direction
)

    if not window
        or not window.size then

        return
    end


    --------------------------------
    -- Clean stale state first.
    --------------------------------

    if splay_resize_tracking then

        splay_clear_feedback(
            splay_resize_window
        )

        splay_reset_resize()

    end


    splay_resize_tracking = true
    splay_resize_changed = false

    splay_resize_window = window
    splay_resize_direction = direction

    splay_resize_initial_width =
        window.size.x

    splay_resize_initial_height =
        window.size.y

    splay_resize_valid =
        splay_tile_is_valid(window)

    splay_resize_feedback_state = nil


    --------------------------------
    -- Track the real tile geometry.
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
    -- Begin Hyprland's actual
    -- interactive resize.
    --------------------------------

    hl.dispatch(
        hl.dsp.window.resize()
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
    -- Take one final geometry sample
    -- on the release event.
    --------------------------------

    splay_resize_tick()


    local window =
        splay_resize_window


    local changed =
        splay_resize_changed


    --------------------------------
    -- If geometry never changed,
    -- this was just a click.
    --------------------------------

    if not changed then

        splay_reset_resize()

        return false

    end


    local valid =
        splay_tile_is_valid(window)


    --------------------------------
    -- Remove temporary border before
    -- potentially closing the client.
    --------------------------------

    splay_clear_feedback(window)


    --------------------------------
    -- Finish state before destroying
    -- the tile.
    --------------------------------

    splay_reset_resize()


    --------------------------------
    -- Tile collapsed below threshold.
    --------------------------------

    if not valid
        and window then

        hl.dispatch(
            hl.dsp.window.close({
                window = window,
            })
        )

    end


    return true

end


--------------------------------
---- SPLAY ARM CLICK -----------
--------------------------------

local function splay_arm_click(
    direction,
    window
)

    splay_click_generation =
        splay_click_generation + 1


    local generation =
        splay_click_generation


    splay_click_pending = true
    splay_click_direction = direction


    if window
        and window.address then

        splay_click_window_address =
            window.address

    else

        splay_click_window_address =
            nil

    end


    --------------------------------
    -- Double-click window.
    --------------------------------

    hl.timer(
        function()

            if generation ~=
                splay_click_generation then

                return
            end


            splay_click_pending = false
            splay_click_direction = nil
            splay_click_window_address = nil

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
    splay_click_window_address = nil

end


--------------------------------
---- SPLAY SPAWN TILE ----------
--------------------------------

local function splay_spawn_tile(direction)

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
    -- Preselect split.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Mark the spawn BEFORE exec.
    --
    -- window.open will claim the
    -- newly created tile.
    --------------------------------

    splay_spawn_generation =
        splay_spawn_generation + 1


    splay_spawn_pending = true
    splay_spawn_direction = direction


    --------------------------------
    -- Create the new tile.
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
        -- Hyprland 0.56 changed the
        -- timing around window.open.
        --
        -- Defer layout interaction by
        -- one event-loop tick.
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
                -- This is now the tile Splay
                -- associates with the spawn.
                --------------------------------

                splay_spawn_pending = false
                splay_spawn_direction = nil


                --------------------------------
                -- If the button has already
                -- been released, simply keep
                -- the newly created tile.
                --------------------------------

                if not splay_mouse_down then
                    return
                end


                --------------------------------
                -- Focus the new tile.
                --------------------------------

                hl.dispatch(
                    hl.dsp.focus({
                        window = window,
                    })
                )


                --------------------------------
                -- The SECOND click that spawned
                -- this window now becomes its
                -- initial resize gesture.
                --------------------------------

                splay_begin_resize(
                    window,
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
        splay_press_action = nil


        local direction, window =
            get_splay_edge()


        --------------------------------
        -- Cursor is not on a tile edge.
        --------------------------------

        if not direction
            or not window then

            return
        end


        --------------------------------
        -- Determine whether this is the
        -- second click of the Splay
        -- subdivision gesture.
        --------------------------------

        local same_window = false


        if splay_click_window_address
            and window.address then

            same_window =
                splay_click_window_address
                == window.address

        end


        --------------------------------
        -- SECOND CLICK
        --
        -- Do not resize the old tile.
        -- Spawn the new one instead.
        --------------------------------

        if splay_click_pending
            and splay_click_direction
                == direction
            and same_window then


            splay_cancel_click()


            splay_press_action =
                "spawn"


            splay_spawn_tile(
                direction
            )


            return

        end


        --------------------------------
        -- A pending click on another
        -- edge/window cannot complete
        -- this double click.
        --------------------------------

        if splay_click_pending then
            splay_cancel_click()
        end


        --------------------------------
        -- NORMAL EDGE PRESS
        --
        -- Start interactive resize.
        --
        -- If geometry never changes,
        -- release will reinterpret this
        -- as a normal click.
        --------------------------------

        splay_press_action =
            "normal"


        splay_begin_resize(
            window,
            direction
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
        -- Complete resize operation.
        --------------------------------

        local changed =
            splay_end_resize()


        --------------------------------
        -- It was an actual resize.
        --------------------------------

        if changed then

            splay_press_action = nil

            return

        end


        --------------------------------
        -- SECOND CLICK / SPAWN
        --
        -- Never reinterpret it as a new
        -- first click.
        --------------------------------

        if splay_press_action ==
            "spawn" then


            --------------------------------
            -- If kitty had not opened
            -- before release, cancel
            -- automatic resize ownership.
            --
            -- The tile itself can still
            -- appear normally.
            --------------------------------

            splay_spawn_pending = false
            splay_spawn_direction = nil


            splay_press_action = nil

            return

        end


        --------------------------------
        -- No geometry changed.
        --
        -- Therefore this was a click,
        -- not a resize.
        --------------------------------

        if splay_press_action ==
            "normal" then


            local direction, window =
                get_splay_edge()


            if direction
                and window then

                splay_arm_click(
                    direction,
                    window
                )

            end

        end


        splay_press_action = nil

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
