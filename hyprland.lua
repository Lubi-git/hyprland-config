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
        border_size = 0,

        -- Native Hyprland border/gap resizing.
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
        -- Distance used to distinguish a click from a drag.
        drag_threshold = 10,

        -- Let mouse events continue through a bound mouse event.
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

-- True after the click-and-a-half gesture has been
-- recognized and while the second button remains held.
local splay_resizing = false


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
---- WINDOW OPEN EVENT ---------
--------------------------------

hl.on("window.open", function(window)

    if not splay_resizing then
        return
    end


    -- The window has been created, but layout operations
    -- must wait until the current compositor operation
    -- has completed.
    hl.timer(function()

        if not splay_resizing then
            return
        end

        -- Start native Hyprland resize on the new tile.
        hl.dispatch(
            hl.dsp.window.resize()
        )

    end, {
        timeout = 1,
        type = "oneshot",
    })
end)


--------------------------------
---- SPLAY PRESS ---------------
--------------------------------

local function splay_press()

    local direction = splay_get_edge()

    if direction == nil then
        return
    end


    local now = os.clock() * 1000


    --------------------------------
    -- SECOND PRESS
    --------------------------------

    if splay_last_direction == direction
        and now - splay_last_time <= splay_double_click_time
    then

        -- Gesture recognized.
        splay_last_direction = nil
        splay_last_time = 0

        -- The next window.open belongs to Splay.
        splay_resizing = true


        --------------------------------
        -- PRESELECT SPLIT
        --------------------------------

        hl.dispatch(
            hl.dsp.layout("preselect " .. direction)
        )


        --------------------------------
        -- CREATE TILE
        --------------------------------

        hl.dispatch(
            hl.dsp.exec_cmd(terminal)
        )

        -- Resize is deliberately NOT started here.
        --
        -- Ghostty does not exist yet.
        -- window.open will start it once the
        -- new tile has been initialized.

        return
    end


    --------------------------------
    -- FIRST PRESS
    --------------------------------

    splay_last_direction = direction
    splay_last_time = now
end


--------------------------------
---- SPLAY RELEASE -------------
--------------------------------

local function splay_release()

    if splay_resizing then

        -- The second click was being held.
        --
        -- Native Hyprland resize ends with
        -- the release of the mouse button.

        splay_resizing = false

        splay_last_direction = nil
        splay_last_time = 0

        return
    end

    -- This is the release of the first click.
    --
    -- Do NOT clear the pending click.
    --
    -- The second press still needs to be able
    -- to recognize the click-and-a-half gesture.
end


--------------------------------
---- EXPIRE FIRST CLICK --------
--------------------------------

hl.timer(function()

    if splay_last_direction ~= nil then

        local now = os.clock() * 1000

        if now - splay_last_time > splay_double_click_time then

            splay_last_direction = nil
            splay_last_time = 0

        end
    end

end, {
    timeout = 50,
    type = "persistent",
})


--------------------------------
---- SPLAY MOUSE BINDS ---------
--------------------------------

-- LMB PRESS.
--
-- This is deliberately NOT "click = true".
-- Splay must react to the second PRESS while
-- the button is still physically held.
hl.bind(
    "mouse:272",
    splay_press,
    {
        mouse = true,
    }
)


-- LMB RELEASE.
--
-- Only terminates the click-and-a-half state.
hl.bind(
    "mouse:272",
    splay_release,
    {
        mouse = true,
        release = true,
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
