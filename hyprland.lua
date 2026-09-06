-- SplayDE
-- Mouse-oriented tiling environment
--
-- Hyprland is the compositor and tiling/layout backend.
-- Splay provides the spatial interaction layer.


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

        -- No compositor border.
        -- The 20 px visual separation is produced
        -- by the 10 px gap owned by each adjacent tile.
        border_size = 0,

        -- Hyprland handles native tile resizing.
        resize_on_border = true,

        -- Extend the native resize grab area.
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


----------------
---- BINDS -----
----------------

hl.config({
    binds = {
        -- Determines when a mouse interaction becomes a drag
        -- instead of a click.
        drag_threshold = 10,

        -- Allows the native mouse behaviour to coexist with
        -- Splay's mouse binding.
        pass_mouse_when_bound = true,
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"


---------------------------
---- APPLICATIONS --------
---------------------------

-- Open terminal.
hl.bind(
    mainMod .. " + Q",
    hl.dsp.exec_cmd(terminal)
)

-- Open file manager.
-- Yazi is a TUI and runs inside Ghostty.
hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(fileManager)
)

-- Open application launcher.
-- fsel is currently a placeholder launcher for SplayDE.
hl.bind(
    mainMod .. " + R",
    hl.dsp.exec_cmd(launcher)
)

-- Close current tile/window.
hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)


---------------------------
---- WINDOW BEHAVIOUR ----
---------------------------

-- Temporary escape hatch while Splay is being developed.
hl.bind(
    mainMod .. " + V",
    hl.dsp.window.float({
        action = "toggle",
    })
)

-- Toggle the current Dwindle split.
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
---- SPLAY INTERACTION ---------
--------------------------------

local splay_last_direction = nil
local splay_last_time = 0

local splay_double_click_time = 250
local splay_edge_size = 10


--------------------------------
---- EDGE DETECTION ------------
--------------------------------

local function splay_get_edge()
    local cursor = hl.get_cursor_pos()
    local windows = hl.get_windows()

    for _, window in ipairs(windows) do
        if window.workspace and window.workspace.id > 0 then
            local x = window.at.x
            local y = window.at.y
            local w = window.size.x
            local h = window.size.y

            local right  = x + w
            local bottom = y + h


            -- Left edge.
            --
            -- The tile owns 10 px of the adjacent gap.
            if cursor.x >= x - splay_edge_size
                and cursor.x <= x + splay_edge_size
                and cursor.y >= y
                and cursor.y <= bottom
            then
                return "l"
            end


            -- Right edge.
            if cursor.x >= right - splay_edge_size
                and cursor.x <= right + splay_edge_size
                and cursor.y >= y
                and cursor.y <= bottom
            then
                return "r"
            end


            -- Top edge.
            if cursor.y >= y - splay_edge_size
                and cursor.y <= y + splay_edge_size
                and cursor.x >= x
                and cursor.x <= right
            then
                return "u"
            end


            -- Bottom edge.
            if cursor.y >= bottom - splay_edge_size
                and cursor.y <= bottom + splay_edge_size
                and cursor.x >= x
                and cursor.x <= right
            then
                return "d"
            end
        end
    end

    return nil
end


--------------------------------
---- SPLAY CLICK ---------------
--------------------------------

local function splay_click()
    local direction = splay_get_edge()

    -- Click was not on a manipulable tile edge.
    if direction == nil then
        splay_last_direction = nil
        return
    end


    local now = os.clock() * 1000


    --------------------------------
    -- SECOND CLICK
    --------------------------------

    if splay_last_direction == direction
        and now - splay_last_time <= splay_double_click_time
    then
        -- Consume the double-click state.
        splay_last_direction = nil
        splay_last_time = 0


        --------------------------------
        -- PRESELECT SPLIT DIRECTION
        --------------------------------

        hl.dispatch(
            hl.dsp.layout("preselect " .. direction)
        )


        --------------------------------
        -- CREATE NEW TILE
        --------------------------------

        hl.dispatch(
            hl.dsp.exec_cmd(terminal)
        )


        --------------------------------
        -- ENTER RESIZE
        --------------------------------
        --
        -- The newly created Ghostty should become
        -- the active tiled window. Hyprland's native
        -- resize dispatcher is then invoked on it.
        --

        hl.dispatch(
            hl.dsp.window.resize()
        )

        return
    end


    --------------------------------
    -- FIRST CLICK
    --------------------------------

    splay_last_direction = direction
    splay_last_time = now
end


--------------------------------
---- SPLAY MOUSE BIND ----------
--------------------------------

hl.bind(
    "mouse:272",
    splay_click,
    {
        mouse = true,
        click = true,
    }
)


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore application maximize requests.
hl.window_rule({
    name = "suppress-maximize-events",

    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})


-- Fix XWayland dragging issues.
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


-- Hyprland-run window.
hl.window_rule({
    name = "move-hyprland-run",

    match = {
        class = "hyprland-run",
    },

    move  = "20 monitor_h-120",
    float = true,
})
