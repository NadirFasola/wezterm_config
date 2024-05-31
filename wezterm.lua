-- Import the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Set the initial size of the terminal
config.initial_cols = 128
config.initial_rows = 48

-- Set the title bar
config.window_decorations = "RESIZE"
config.window_padding = {
	left = "0 cell",
	right = "0 cell",
	top = "0 cell",
	bottom = "0 cell",
}
config.window_frame = {
	font = wezterm.font({
		family = "Rotobo",
		weight = "Bold",
	}),
	font_size = 12,
}

-- Hide tab bar + don't show its index
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = true
config.tab_and_split_indices_are_zero_based = false
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 64

-- TODO: Make some fancier tab bar!

-- set background opacity to something less than 1
config.color_scheme = "Monokai Pro Ristretto (Gogh)"
-- If we are running Linux, set some transparency
if wezterm.target_triple:find("linux") ~= nil then
	config.window_background_opacity = 0.9
elseif wezterm.target_triple:find("windows") ~= nil then
	config.window_background_opacity = 0
	config.win32_system_backdrop = "Tabbed"
end

-- Some font options
config.font_size = 14.0
config.font = wezterm.font({
	family = "Fira Code",
	weight = "Regular",
	harfbuzz_features = {
		"cv06",
		"zero",
		"ss04",
		"cv16",
		"ss09",
		"cv25",
		"cv26",
		"cv32",
		"cv28",
		"ss07",
		"ss10",
	},
})

-- Set mouse bindings to behave in a clever way
-- Also set the mouse wheel to change the font size when combined
-- with CTRL
config.mouse_bindings = {
	-- Change the default click behaviour so that it only
	-- selects text and doesn't open hyperlink
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	-- make CTRL-CLICK open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.Nop,
	},
	-- Scrolling up while holding CTRL increases the font size
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	-- Scrolling down while holding CTRL decreases the font size
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
}

-- Show the character selection tool with SHIT + CTRL + u
config.keys = {
	{
		key = "u",
		mods = "SHIFT|CTRL",
		action = wezterm.action.CharSelect({
			copy_on_select = true,
			copy_to = "ClipboardAndPrimarySelection",
		}),
	},
}

return config
