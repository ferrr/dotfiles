local wezterm = require 'wezterm'

local config = wezterm.config_builder()

local C_ACTIVE_BG = "#264F78";
local C_ACTIVE_FG = "#D4D4D4";
local C_INACTIVE_FG = "#839496";

config = {
    window_decorations = "RESIZE",
    scrollback_lines = 10000,
    audible_bell = "Disabled",
    window_close_confirmation = 'NeverPrompt',
    font = wezterm.font('JetBrains Mono'),
    font_size = 15,
    -- https://github.com/wez/wezterm/issues/4522
    hide_tab_bar_if_only_one_tab = true,
    default_cwd = '~/dev',
    use_fancy_tab_bar = false,
    tab_max_width = 96,

    colors = {
        tab_bar = {
            background = 'rgba(0,0,0,0)',

            new_tab = {
                bg_color = 'rgba(0,0,0,0)',
                fg_color = C_INACTIVE_FG,
            },
            active_tab = {
                bg_color = C_ACTIVE_BG,
                fg_color = C_ACTIVE_FG,
                intensity = 'Bold',
            },
            inactive_tab = {
                bg_color = 'rgba(0,0,0,0)',
                fg_color = C_INACTIVE_FG,
            },
            inactive_tab_hover = {
                bg_color = 'rgba(0,0,0,0)',
                fg_color = C_INACTIVE_FG,
            }
        }
    },

    keys = {
        {
            key = 'Tab',
            mods = 'CTRL',
            action = wezterm.action.DisableDefaultAssignment,
        },
        {
            key = 'RightArrow',
            mods = 'SUPER',
            action = wezterm.action.ActivateTabRelative(1),
        },
        {
            key = 'LeftArrow',
            mods = 'SUPER',
            action = wezterm.action.ActivateTabRelative(-1),
        },
    },
    bypass_mouse_reporting_modifiers = 'ALT',
}

wezterm.on('gui-startup', function()
    local tab, pane, window = wezterm.mux.spawn_window({})
    window:gui_window():maximize()
end)

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Builtin Solarized Dark'
    else
        return 'Builtin Solarized Light'
    end
end

wezterm.on('window-config-reloaded', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    local appearance = window:get_appearance()
    local scheme = scheme_for_appearance(appearance)
    if overrides.color_scheme ~= scheme then
        overrides.color_scheme = scheme
        window:set_config_overrides(overrides)
    end
end)

return config
