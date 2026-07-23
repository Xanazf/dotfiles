hl.window_rule({
	match = {
		class = "^(org\\.wezfurlong\\.wezterm)$",
	},
	tile = true,
})

hl.window_rule({
	match = {
		class = "^(org\\.gnome\\.)",
	},
	rounding = 12,
})

hl.window_rule({
	match = {
		class = "^(gnome-control-center)$",
	},
	tile = true,
})

hl.window_rule({
	match = {
		class = "^(pavucontrol)$",
	},
	tile = true,
})

hl.window_rule({
	match = {
		class = "^(nm-connection-editor)$",
	},
	tile = true,
})

hl.window_rule({
	match = {
		class = "^(gnome-calculator)$",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "^(galculator)$",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "^(blueman-manager)$",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "^(org\\.gnome\\.Nautilus)$",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "^(xdg-desktop-portal)$",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "^(steam)$",
		title = "^(notificationtoasts)",
	},
	no_initial_focus = true,
	pin = true,
})

hl.window_rule({
	match = {
		class = "^(firefox)$",
		title = "^(Picture-in-Picture)$",
	},
	float = true,
})

hl.window_rule({
	match = {
		class = "^(zoom)$",
	},
	float = true,
})

hl.layer_rule({
	match = { namespace = "^(quickshell)$" },
	no_anim = true,
})

hl.layer_rule({
	match = { namespace = "^dms:.*" },
	no_anim = true,
})

-- layerrule = blur on, match:namespace ^dms:.*

-- GLOB
-- -- rule setting
hl.window_rule({
	name = "windowrule-8",
	match = {
		tag = "pop",
	},
	size = "(monitor_w*0.35) (monitor_h*0.35)",
	float = true,
	center = true,
})

hl.window_rule({
	name = "windowrule-9",
	match = {
		tag = "decor",
	},
	persistent_size = true,
	pin = true,
	no_follow_mouse = true,
	no_initial_focus = true,
})

hl.window_rule({
	name = "windowrule-10",
	match = {
		tag = "util",
	},
	float = true,
	border_size = 0,
})

hl.window_rule({
	name = "windowrule-11",
	match = {
		tag = "important",
	},
	opaque = true,
	no_dim = true,
})

-- -- variable/tag setting
hl.window_rule({
	name = "windowrule-1",
	match = {
		class = "^(.*showmethekey)$",
	},
	tag = "+decor, util",
})

hl.window_rule({
	name = "windowrule-4",
	match = {
		class = "^([tT]hunar|.*pavucontrol)$",
	},
	tag = "+pop",
})

hl.window_rule({
	name = "windowrule-5",
	match = {
		class = "^(firefox-.*)$",
	},
	tag = "+important",
})

hl.window_rule({
	name = "windowrule-6",
	match = {
		class = "^(zen-.*)$",
	},
	tag = "+important",
})

hl.window_rule({
	name = "windowrule-7",
	match = {
		class = "^(kitty)$",
	},
	tag = "+important",
})

-- -- LAYER
hl.layer_rule({
	name = "layerrule-1",
	match = {
		namespace = "notifications",
	},
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "layerrule-2",
	match = {
		namespace = "quickshell",
	},
	blur = true,
	blur_popups = true,
	ignore_alpha = 0,
})

-- -- Caelestia Layer rules
hl.layer_rule({
	name = "layerrule-3",
	match = {
		namespace = "hyprpicker",
	},
	animation = "fade",
})

hl.layer_rule({
	name = "layerrule-4",
	match = {
		namespace = "logout_dialog",
	},
	animation = "fade",
})

hl.layer_rule({
	name = "layerrule-5",
	match = {
		namespace = "selection",
	},
	animation = "fade",
})

hl.layer_rule({
	name = "layerrule-6",
	match = {
		namespace = "wayfreeze",
	},
	animation = "fade",
})

-- Fuzzel
hl.layer_rule({
	name = "layerrule-7",
	match = {
		namespace = "launcher",
	},
	animation = "popin 80%",
	blur = true,
})

-- Shell
hl.layer_rule({
	name = "layerrule-8",
	match = {
		namespace = "caelestia-(border-exclusion|area-picker)",
	},
	no_anim = true,
})

hl.layer_rule({
	name = "layerrule-9",
	match = {
		namespace = "caelestia-(drawers|background)",
	},
	animation = "fade",
})

hl.layer_rule({
	name = "layerrule-10",
	match = {
		namespace = "caelestia-drawers",
	},
	blur = true,
	ignore_alpha = 0.57,
})

-- Special workspaces
hl.window_rule({
	name = "windowrule-12",
	match = {
		class = "btop",
	},
	workspace = "special:sysmon",
})

hl.window_rule({
	name = "windowrule-13",
	match = {
		class = "feishin|Spotify|Supersonic",
	},
	workspace = "special:music",
})

hl.window_rule({
	name = "windowrule-14",
	match = {
		initial_title = "Spotify( Free)?",
	},
	workspace = "special:music",
})

hl.window_rule({
	name = "windowrule-15",
	match = {
		class = "discord|equibop|vesktop|whatsapp",
	},
	workspace = "special:social",
})

hl.window_rule({
	name = "windowrule-16",
	match = {
		class = "Todoist",
	},
	workspace = "special:todo",
})

-- Dialogs
hl.window_rule({
	name = "windowrule-17",
	match = {
		title = "(Select|Open)( a)? (File|Folder)(s)?",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-18",
	match = {
		title = "(Вибрати|Відкрити) ([Фф]айл|[Тт]теку)(и)?",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-19",
	match = {
		title = "File (Operation|Upload)( Progress)?",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-20",
	match = {
		title = "^.*(Properties|Властивості).*$",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-21",
	match = {
		title = "^(Export.* as|Зберегти).*",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-22",
	match = {
		title = "GIMP Crash Debug",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-23",
	match = {
		title = "^(Library|Бібліотека).*$",
	},
	float = true,
})

hl.window_rule({
	name = "windowrule-24",
	match = {
		title = "^(Information|Інформація).*$",
	},
	float = true,
})

-- Picture in picture (resize and move done via script)
hl.window_rule({
	name = "windowrule-25",
	match = {
		title = "Зображення(-| )в(-| )[Зз]ображенні",
	},
	move = "((monitor_w*1)-window_w-(monitor_w*0.02)) ((monitor_h*1)-window_h-(monitor_h*0.03))",
})

hl.window_rule({
	name = "windowrule-26",
	match = {
		title = "Зображення(-| )в(-| )[Зз]ображенні",
	},
	keep_aspect_ratio = true,
	float = true,
	pin = true,
})

-- DEV
hl.window_rule({
	name = "wr-cpp",
	match = {
		title = "^(Downloading CPP).*$",
	},
	float = true,
})

-- GAMES
hl.window_rule({
	name = "windowrule-24",
	match = {
		title = "^(SSEEdit|xEdit|Synthesis|DynDOLOD|LOD Gen)$",
	},
	-- stay_focused = on
	allows_input = true,
	render_unfocused = true,
	tag = "+modding",
	-- match:class = ^(steam_app_0)$
})

hl.window_rule({
	name = "windowrule-24",
	match = {
		class = "^(sseedit.exe)$",
	},
	stay_focused = true,
	allows_input = true,
	render_unfocused = true,
})

hl.window_rule({
	name = "windowrule-27",
	match = {
		class = "^([Ff]actorio.*)$",
	},
	content = "game",
})

hl.window_rule({
	name = "windowrule-30",
	match = {
		class = "^(Warframe*)$",
	},
	content = "game",
})

hl.window_rule({
	name = "steam-overlay",
	match = {
		class = "(steam)",
		title = "(^$)",
	},
	stay_focused = true,
	min_size = "1 1",
})

hl.window_rule({
	name = "steam-general",
	match = {
		class = "^(Warframe.*|[Ff]actorio.*|steam_app_.*)$",
	},
	fullscreen = true,
	monitor = "0",
	content = "game",
	allows_input = true,
	no_anim = true,
	no_blur = true,
	no_dim = true,
	no_shadow = true,
	decorate = false,
	opaque = true,
	immediate = true,
	render_unfocused = true,
	keep_aspect_ratio = true,
})

hl.window_rule({
	name = "redlauncher-fix",
	match = {
		class = "^(steam_app_1091500)$",
		title = "^(REDlauncher)$",
	},
	fullscreen = false,
	float = true,
	center = true,
})

hl.window_rule({
	name = "cyberpunk-hdr",
	match = {
		class = "^(steam_app_1091500)$",
		title = "^(Cyberpunk 2077)$",
	},
	fullscreen = true,
	force_rgbx = true,
})

-- UTILS
-- -- term
hl.window_rule({
	name = "windowrule-32",
	match = {
		class = "^(showmethekey.*)$",
	},
	size = "597>600 60>63",
	monitor = "DP-1",
	move = "((monitor_w*1)-window_w-60) (1320)",
	decorate = true,
})

-- -- image
hl.window_rule({
	name = "windowrule-imv",
	match = {
		title = "^(imv).*$",
	},
	opaque = true,
	no_dim = true,
})

hl.window_rule({
	name = "windowrule-mpv",
	match = {
		title = "^.*(mpv)$",
	},
	opaque = true,
	no_dim = true,
})

-- -- video

-- -- browser
hl.window_rule({
	name = "windowrule-34",
	match = {
		class = "^(zen-.*)$",
	},
	focus_on_activate = true,
})
