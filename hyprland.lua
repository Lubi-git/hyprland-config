local terminal = "ghostty"

-- Splay interaction state.
local splay_click_pending = false
local splay_click_direction = nil

-- Direction of the tile that is currently being created.
local splay_new_tile_direction = nil
local splay_new_tile = false

-- Geometry constants.
--
-- Hyprland uses 10 px gaps inside the layout.
-- Therefore each adjacent tile owns 10 px of the visual gap.
local SPLAY_EDGE_ZONE = 10

-- Desired initial size of the newly created tile.
local SPLAY_INITIAL_SIZE = 20


hl.config({
    general = {
        gaps_in = 10,
        gaps_out = 20,

        border_size = 0,

        resize_on_border = true,
        extend_border_grab_area = 10,

        allow_tearing = false,

        layout = "dwindle",
    },

    dwindle = {
        force_split = 0,
        preserve_split = false,
        smart_split = false,

        smart_resizing = true,

        permanent_direction_override = false,

        special_scale_factor = 1,

        split_width_multiplier = 1.0,

        use_active_for_splits = true,

        default_split_ratio = 1.0,

        split_bias = 0,

        precise_mouse_move = false,
    },

    binds = {
        drag_threshold = 10,

        pass_mouse_when_bound = true,
    },
})


------------------------------------------------------------
-- SPLAY EDGE DETECTION
------------------------------------------------------------

local function get_splay_edge()
    local cursor = hl.get_cursor_pos()
    local windows = hl.get_windows()

    if not cursor or not windows then
        return nil
    end

    local cx = cursor.x
    local cy = cursor.y

    for _, window in ipairs(windows) do
        if window.at and window.size then
            local x = window.at.x
            local y = window.at.y

            local w = window.size.x
            local h = window.size.y

            ------------------------------------------------
            -- LEFT
            ------------------------------------------------

            if cx >= x - SPLAY_EDGE_ZONE
                and cx <= x + SPLAY_EDGE_ZONE
                and cy >= y
                and cy <= y + h then

                return "l"
            end

            ------------------------------------------------
            -- RIGHT
            ------------------------------------------------

            if cx >= x + w - SPLAY_EDGE_ZONE
                and cx <= x + w + SPLAY_EDGE_ZONE
                and cy >= y
                and cy <= y + h then

                return "r"
            end

            ------------------------------------------------
            -- TOP
            ------------------------------------------------

            if cy >= y - SPLAY_EDGE_ZONE
                and cy <= y + SPLAY_EDGE_ZONE
                and cx >= x
                and cx <= x + w then

                return "u"
            end

            ------------------------------------------------
            -- BOTTOM
            ------------------------------------------------

            if cy >= y + h - SPLAY_EDGE_ZONE
                and cy <= y + h + SPLAY_EDGE_ZONE
                and cx >= x
                and cx <= x + w then

                return "d"
            end
        end
    end

    return nil
end


------------------------------------------------------------
-- INITIAL SPLIT GEOMETRY
------------------------------------------------------------

local function get_initial_split_ratio(direction)
    local window = hl.get_active_window()

    if not window or not window.size then
        return 1.0
    end

    local dimension

    --------------------------------------------------------
    -- Horizontal split:
    -- left / right
    --------------------------------------------------------

    if direction == "l" or direction == "r" then
        dimension = window.size.x

    --------------------------------------------------------
    -- Vertical split:
    -- up / down
    --------------------------------------------------------

    elseif direction == "u" or direction == "d" then
        dimension = window.size.y

    else
        return 1.0
    end

    if dimension <= 0 then
        return 1.0
    end

    --------------------------------------------------------
    -- Dwindle's exact ratio:
    --
    -- 1.0 = 50 / 50
    --
    -- We want the new tile to begin approximately
    -- SPLAY_INITIAL_SIZE pixels from the originating edge.
    --
    -- The ratio is therefore calculated from the available
    -- parent dimension rather than passing "20" directly
    -- to splitratio.
    --------------------------------------------------------

    local ratio

    if direction == "l" or direction == "u" then
        ----------------------------------------------------
        -- New tile is on the beginning side of the axis.
        ----------------------------------------------------

        ratio =
            SPLAY_INITIAL_SIZE /
            math.max(1, dimension - SPLAY_INITIAL_SIZE)

    else
        ----------------------------------------------------
        -- New tile is on the ending side of the axis.
        ----------------------------------------------------

        ratio =
            (dimension - SPLAY_INITIAL_SIZE) /
            math.max(1, SPLAY_INITIAL_SIZE)
    end

    --------------------------------------------------------
    -- Hyprland limits exact Dwindle ratios to 0.1 - 1.9.
    --------------------------------------------------------

    if ratio < 0.1 then
        ratio = 0.1
    elseif ratio > 1.9 then
        ratio = 1.9
    end

    return ratio
end


------------------------------------------------------------
-- APPLY INITIAL SPLIT
------------------------------------------------------------

local function apply_initial_split(direction)
    if not direction then
        return
    end

    local ratio = get_initial_split_ratio(direction)

    hl.dispatch(
        hl.dsp.layout(
            "splitratio " .. tostring(ratio) .. " exact"
        )
    )
end


------------------------------------------------------------
-- SPLAY DOUBLE CLICK
------------------------------------------------------------

local function splay_click()
    local direction = get_splay_edge()

    if not direction then
        return
    end

    --------------------------------------------------------
    -- First click.
    --------------------------------------------------------

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


    --------------------------------------------------------
    -- Second click must occur on the same edge.
    --------------------------------------------------------

    if splay_click_direction ~= direction then
        splay_click_direction = direction
        return
    end


    --------------------------------------------------------
    -- Double click confirmed.
    --------------------------------------------------------

    splay_click_pending = false
    splay_click_direction = nil


    --------------------------------------------------------
    -- Preserve the direction independently.
    --
    -- This is important: the previous implementation cleared
    -- splay_click_direction before the next mouse callback,
    -- which meant the geometry code no longer knew which side
    -- had generated the split.
    --------------------------------------------------------

    splay_new_tile_direction = direction
    splay_new_tile = true


    --------------------------------------------------------
    -- Tell Dwindle where the new tile must be created.
    --------------------------------------------------------

    hl.dispatch(
        hl.dsp.layout(
            "preselect " .. direction
        )
    )


    --------------------------------------------------------
    -- Open the actual tile.
    --------------------------------------------------------

    hl.dispatch(
        hl.dsp.exec_cmd(terminal)
    )
end


------------------------------------------------------------
-- LEFT MOUSE BUTTON
------------------------------------------------------------

hl.bind(
    "mouse:272",
    function()
        ----------------------------------------------------
        -- This click is the continuation of a Splay tile
        -- creation operation.
        ----------------------------------------------------

        if splay_new_tile then
            splay_new_tile = false


            ------------------------------------------------
            -- Preserve the direction before clearing state.
            ------------------------------------------------

            local direction = splay_new_tile_direction


            ------------------------------------------------
            -- The new Ghostty has now been created.
            --
            -- Apply the initial 20 px geometry first.
            ------------------------------------------------

            if direction then
                apply_initial_split(direction)
            end


            ------------------------------------------------
            -- Immediately hand control to Hyprland's native
            -- interactive resize mechanism.
            ------------------------------------------------

            hl.dispatch(
                hl.dsp.window.resize()
            )


            ------------------------------------------------
            -- The resize operation now belongs to Hyprland.
            ------------------------------------------------

            splay_new_tile_direction = nil

            return
        end


        ----------------------------------------------------
        -- Normal Splay interaction.
        ----------------------------------------------------

        splay_click()
    end,
    {
        mouse = true,
    }
)


------------------------------------------------------------
-- LEFT MOUSE BUTTON RELEASE
------------------------------------------------------------

hl.bind(
    "mouse:272",
    function()
        ----------------------------------------------------
        -- Do not cancel the direction here.
        --
        -- Hyprland's native resize operation is responsible
        -- for the actual drag/resize state.
        ----------------------------------------------------

        splay_new_tile = false
    end,
    {
        mouse = true,
        release = true,
    }
)
