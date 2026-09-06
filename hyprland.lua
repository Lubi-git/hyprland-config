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
---- ENVIRONMENT VARIABLES ----
--------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- LOOK AND FEEL ---
-----------------------

hl.config({
    general = {
        -- 10 px inward from each tile.
        -- Two adjacent tiles therefore create
        -- a 20 px visual gap.
        gaps_in = 10,
        gaps_out = 20,

        -- Splay does not use Hyprland window borders.
        border_size = 0,

        -- Native Hyprland border/gap resizing.
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
        -- Preserve the spatial subdivision tree.
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


--------------------------------
---- SPLAY ---------------------
--------------------------------

local splay = {
    -- Adjacent tiles have a 20 px visual gap:
    --
    --       TILE A    20px    TILE B
    --                  ↑
    --              10px | 10px
    --
    -- Each tile therefore owns 10 px
    -- of the shared spatial boundary.
    edge = 10,

    double_click_time = 250,

    waiting_second_click = false,
    first_direction = nil,
}


---------------------------
---- SPLAY GEOMETRY -------
---------------------------

local function get_splay_target()
    local cursor = hl.get_cursor_pos()

    if cursor == nil then
        return nil
    end

    local windows = hl.get_windows()

    if windows == nil then
        return nil
    end

    local best_window = nil
    local best_direction = nil
    local best_distance = math.huge

    for _, window in ipairs(windows) do
        if
            window ~= nil
            and not window.floating
            and window.at ~= nil
            and window.size ~= nil
        then
            local left =
                cursor.x - window.at.x

            local right =
                (window.at.x + window.size.x) - cursor.x

            local top =
                cursor.y - window.at.y

            local bottom =
                (window.at.y + window.size.y) - cursor.y


            --------------------------------
            -- Left edge
            --------------------------------

            if left >= 0 and left <= splay.edge then
                if left < best_distance then
                    best_window = window
                    best_direction = "l"
                    best_distance = left
                end
            end


            --------------------------------
            -- Right edge
            --------------------------------

            if right >= 0 and right <= splay.edge then
                if right < best_distance then
                    best_window = window
                    best_direction = "r"
                    best_distance = right
                end
            end


            --------------------------------
            -- Top edge
            --------------------------------

            if top >= 0 and top <= splay.edge then
                if top < best_distance then
                    best_window = window
                    best_direction = "u"
                    best_distance = top
                end
            end


            --------------------------------
            -- Bottom edge
            --------------------------------

            if bottom >= 0 and bottom <= splay.edge then
                if bottom < best_distance then
                    best_window = window
                    best_direction = "d"
                    best_distance = bottom
                end
            end
        end
    end


    if best_window == nil then
        return nil
    end


    return {
        window = best_window,
        direction = best_direction,
    }
end


---------------------------
---- SPLAY DOUBLE CLICK --
---------------------------

local function splay_click()
    local target = get_splay_target()

    -- A click outside Splay's edge domain
    -- has no Splay meaning.
    if target == nil then
        splay.waiting_second_click = false
        splay.first_direction = nil
        return
    end


    local direction = target.direction


    --------------------------------
    -- First click
    --------------------------------

    if not splay.waiting_second_click then
        splay.waiting_second_click = true
        splay.first_direction = direction

        hl.timer(
            function()
                splay.waiting_second_click = false
                splay.first_direction = nil
            end,
            {
                timeout = splay.double_click_time,
                type = "oneshot",
            }
        )

        return
    end


    --------------------------------
    -- Second click
    --------------------------------

    if splay.first_direction ~= direction then
        -- The user changed edge between clicks.
        -- Start a new sequence from this edge.
        splay.first_direction = direction
        return
    end


    splay.waiting_second_click = false
    splay.first_direction = nil


    --------------------------------
    -- Tell Dwindle the direction.
    --------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------
    -- Create the new Splay tile.
    --------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )
end


---------------------------
---- SPLAY OBSERVER -------
---------------------------

-- IMPORTANT:
--
-- This is only the semantic layer for a click.
-- It does NOT implement movement or resizing.
--
-- Hyprland remains responsible for:
--
--   * border resizing
--   * gap resizing
--   * mouse movement
--   * window dragging
--   * tiled geometry
--
-- Splay only adds:
--
--   double click + edge → create tile
--
hl.bind(
    "mouse:272",
    splay_click,
    {
        mouse = true,
        click = true,
        non_consuming = true,
    }
)


---------------------------
---- KEYBINDINGS ----------
---------------------------

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
