---@type Wezterm
local wezterm = require("wezterm")
---@type Action
local act = wezterm.action
---@type Config
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Frappe"
config.bold_brightens_ansi_colors = true

-- Font configuration
config.font = wezterm.font("VictorMono Nerd Font Mono", { weight = "Medium" })
config.font_size = 14
config.line_height = 1.0

require("tabline").apply_to_config(config)
config.window_decorations = "RESIZE"
config.window_padding = { top = "0.5cell", right = "1cell", bottom = 0, left = "1cell" }
config.window_background_opacity = 0.97
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }
config.macos_window_background_blur = 20
config.native_macos_fullscreen_mode = true

config.skip_close_confirmation_for_processes_named = { "bash", "sh", "zsh", "tmux" }

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  { mods = "LEADER|CTRL", key = "a",          action = act.SendKey({ key = "a", mods = "CTRL" }) },

  -- Manage splits
  { mods = "CMD",         key = "w",          action = act.CloseCurrentPane({ confirm = true }) },
  { mods = "CMD",         key = "d",          action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { mods = "CMD",         key = "Enter",      action = act.TogglePaneZoomState },
  { mods = "CMD|SHIFT",   key = "d",          action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { mods = "CMD|CTRL",    key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 1 }) },
  { mods = "CMD|CTRL",    key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
  { mods = "CMD|CTRL",    key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 1 }) },
  { mods = "CMD|CTRL",    key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 1 }) },

  -- Edit settings using nvim
  {
    mods = "CMD",
    key = ",",
    action = act.SpawnCommandInNewTab({
      args = { "nvim", os.getenv("WEZTERM_CONFIG_FILE") },
      cwd = os.getenv("WEZTERM_CONFIG_DIR"),
      set_environment_variables = {
        PATH = os.getenv("PATH") .. ":/opt/homebrew/bin/",
      },
    }),
  },
}

require("splits-navigation").apply_to_config(config)

return config
