-- by XNZF
-- we Wayland already
-- mom's spaghetti
-- v0.54.0

-- monitors
-- monitor = DP-1, 2560x1440@165, 0x0, 1, bitdepth, 10, cm, auto

-- source = ./dms/outputs.conf

local monitor0 = "DP-1"
local monitor1 = "DP-2"

-- hl.monitor({
-- 	output = monitor0,
-- 	mode = "2560x1440@165",
-- 	position = "0x0",
-- 	scale = 1,
-- 	supports_wide_color = 1,
-- 	supports_hdr = 1,
-- 	bitdepth = 10,
-- 	cm = "auto",
-- 	vrr = 2,
-- 	sdr_eotf = "srgb",
-- 	sdrbrightness = 1.2,
-- 	sdrsaturation = 0.99,
-- 	sdr_min_luminance = 0.027,
-- 	sdr_max_luminance = 1000,
-- 	max_avg_luminance = 300,
-- })
--
-- hl.monitor({
-- 	output = monitor1,
-- 	mode = "1920x1200@60",
-- 	position = "2561x0",
-- 	scale = 1,
-- 	transform = 1,
-- })

-- hl.device({
-- 	name = "dualsense-wireless-controller-touchpad",
-- 	enabled = false,
-- })
-- hl.device({
-- 	name = "sony-interactive-entertainment-dualsense-wireless-controller-touchpad",
-- 	enabled = false,
-- })

-- -- laptop
-- monitor = eDP-1, 1920x1080@60, 0x0, 1

-- execute at launch

-- plugins
-- exec-once = hyprpm reload -n
-- plugin = /usr/lib/libhy3.so
-- -- source
-- source = ~/.config/hypr/modules/plugins.conf

-- env vars
-- env = DRI_PRIME,1
hl.env("TERMINAL", "/usr/bin/kitty")
hl.env("EDITOR", "/usr/bin/nvim")

-- - Aquamarine
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")

-- - cursor
hl.env("HYPRCURSOR_THEME", "Moga-Neon-Green")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XCURSOR_THEME", "Moga-Neon-Green")
hl.env("XCURSOR_SIZE", "24")

-- - platform vars
hl.env("GTK_THEME", "Sweet:dark")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QS_ICON_THEME", "candy-icons")

hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- env = QT_QUICK_BACKEND,vulkan
-- env = QSG_RHI_BACKEND,vulkan

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_DATA_HOME", "/home/xnzf")
hl.env("XDG_CONFIG_HOME", "/home/xnzf/.config")
hl.env("XDG_CACHE_HOME", "/home/xnzf/.cache")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- - AMD
hl.env("AMD_VULKAN_ICD", "radv")
hl.env("WLR_DRM_DEVICES", "/dev/dri/by-path/pci-0000:03:00.0-card")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "mesa")
hl.env("MESA_LOADER_DRIVER_OVERRIDE", "radeonsi")
hl.env("MESA_VK_DEVICE_SELECT", "1002:7550")
hl.env("MESA_GPU_SELECTION", "1002:7550")
-- hl.env("RADV_EXPERIMENTAL", "transfer_queue")

-- - VULKAN
hl.env(
	"VK_ICD_FILENAMES",
	"/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json"
)
hl.env("WLR_DRM_NO_ATOMIC", "0")
hl.env("FOSSILIZE_REPLAY_THREAD_COUNT", "4")
-- env = VK_DRIVER_FILES,/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
-- env = VULKAN_SDK,/home/xnzf/vulkan/1.4.335.0/x86_64
-- env = DXVK_FRAME_RATE,144
-- env = VKD3D_FRAME_RATE,144
-- env = VKD3D_HDR,1
-- env = VKD3D_CONFIG, dxr # force_static_cbv # nvidia only

-- - wine/proton
hl.env("PROTON_WAYLAND_MONITOR", "$monitor0")

-- - nvidia
-- env = LIBVA_DRIVER_NAME,nvidia
-- env = PROTON_ENABLE_NVAPI,1
-- env = XDG_SESSION_TYPE,wayland
-- env = GBM_BACKEND,nvidia-drm
-- env = NVD_BACKEND,direct
-- env = __GLX__VENDOR_LIBRARY_NAME,nvidia
-- env = __GL_THREADED_OPTIMIZATION,1
-- env = __GL_SHADER_DISK_CACHE,1
-- env = __GL_SHADER_DISK_CACHE_PATH,/home/xnzf/.cache/nvidia/GLCache/

-- - screenshots
hl.env("SLURP_ARGS", "-d -B F050F022 -b 10101022 -c ff00ff")
hl.env("GRIMBLAST_EDITOR", "swappy")
hl.env("HYPRSHOT_DIR", "/home/xnzf/Pictures/screenshots/")
hl.env("XDG_PICTURES_DIR", "/home/xnzf/Pictures/screenshots/")

-- source = ./dms/layout.conf
require("dms.layout")
require("dms.outputs")
-- baseline

hl.curve("expOutOvershot", { type = "bezier", points = { { -0.15, 1.15 }, { -0.05, 1.05 } } })
hl.curve("expOut", { type = "bezier", points = { { 0.05, 0.95 }, { 0.035, 1.05 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 4,
	bezier = "overshot",
	style = "slide",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 6,
	bezier = "overshot",
	style = "slide",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 0.6,
	bezier = "default",
})
hl.animation({
	leaf = "borderangle",
	enabled = true,
	speed = 60,
	bezier = "default",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 10,
	bezier = "default",
})

local primary = "rgb(74d7cc)"
local outline = "rgb(9b8c9b)"
local error = "rgb(ffb4ab)"

require("dms.windowrules")

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "thunar"

-- hl.define_submap("global", function()
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("hyprctl setprop active opaque toggle"))

require("dms.cursor")
require("dms.binds")

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

hl.bind(mainMod .. " + Q", hl.dsp.workspace.toggle_special("social"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.move({ workspace = "special:social" }))
-- end)

hl.workspace_rule({
	workspace = "1",
	default_name = "initial",
	monitor = monitor0,
	no_border = true,
	no_rounding = true,
	decorate = false,
	persistent = true,
})

hl.workspace_rule({
	workspace = "2",
	default_name = "web",
	monitor = monitor0,
	default = true,
	persistent = true,
})

hl.workspace_rule({
	workspace = "special:scratchpad",
	-- default_name = "scratchpad",
	monitor = monitor0,
	on_created_empty = terminal,
})

hl.workspace_rule({
	workspace = "special:social",
	-- default_name = "social",
	monitor = monitor1,
	on_created_empty = "vesktop",
})

hl.workspace_rule({
	workspace = "3",
	-- default_name = "notes",
	monitor = monitor1,
	on_created_empty = "nvim",
	default = true,
	persistent = true,
})

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
	general = {
		locale = "uk",
		border_size = 1,
		gaps_in = 8,
		gaps_out = 15,
		col = {
			active_border = {
				colors = {
					"rgba(89b4fa00)",
					"rgba(89b4fa00)",
					"rgba(ff225bdf)",
					"rgba(89b4fa00)",
					"rgba(89b4fa00)",
					"rgba(4e44ffd0)",
					"rgba(89b4fa00)",
					"rgba(89b4fa00)",
				},
				angle = 75,
			},
			inactive_border = {
				colors = {
					"rgba(89b4fa00)",
					"rgba(89b4fa00)",
					"rgba(ff668d59)",
					"rgba(89b4fa00)",
					"rgba(89b4fa00)",
					"rgba(8e88ff9a)",
					"rgba(89b4fa00)",
					"rgba(89b4fa00)",
				},
				angle = 75,
			},
		},
		-- col.inactive_border=0xff45475a 0xff45475a 0xff454700 -75deg
		-- col.active_border = rgb(4a7bff) rgb(56bbf1) rgb(00dfa2) 45deg
		-- col.inactive_border = rgb(4a7bff) rgb(56bbf1) rgb(00dfa2) -45deg
		layout = "dwindle",
		-- -- fullscreen apps
		allow_tearing = true,
		no_focus_fallback = true,
		snap = {
			enabled = false,
			window_gap = 8,
			monitor_gap = 15,
			respect_gaps = true,
		},
	},
	decoration = {
		rounding = 15,
		rounding_power = 3.3,
		active_opacity = 1.0,
		inactive_opacity = 0.75,
		fullscreen_opacity = 1.0,
		dim_modal = false,
		dim_inactive = true,
		dim_strength = 0.15,
		dim_special = 0.3,
		border_part_of_window = true,
		blur = {
			enabled = true,
			size = 6,
			passes = 3,
			ignore_opacity = true,
			new_optimizations = true,
			xray = true,
			noise = 0.0117,
			contrast = 1.6816,
			brightness = 0.8172,
			vibrancy = 0.9126,
			vibrancy_darkness = 0.1696,
			input_methods = true,
			input_methods_ignorealpha = 0.2,
		},
		shadow = {
			enabled = true,
			range = 3,
			render_power = 3,
			color = "rgba(7233de42)",
			color_inactive = "rgba(5421bf21)",
			-- offset = 0.5 40
		},
	},
	animations = {
		enabled = true,
		workspace_wraparound = true,
		-- animation definitions
		-- window bobbing
		-- border spin
	},
	input = {
		-- kb_model =
		kb_layout = "us,ua,us",
		kb_variant = ",,dvorak",
		kb_options = "grp:alt_shift_toggle",
		kb_rules = "",
		resolve_binds_by_sym = false,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		accel_profile = "adaptive",
		follow_mouse = 1,
		mouse_refocus = false,
		float_switch_override_focus = 2,
		touchpad = {
			natural_scroll = false,
		},
		touchdevice = {
			output = monitor0,
		},
		virtualkeyboard = {
			release_pressed_on_close = true,
		},
		tablet = {
			output = monitor0,
		},
		-- Example per-device config
		-- See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
		-- device:epic-mouse-v1 {
		--    sensitivity = -0.5
		-- }
	},
	-- source = ./dms/colors.conf
	group = {
		col = {
			border_active = primary,
			border_inactive = outline,
			border_locked_active = error,
			border_locked_inactive = outline,
		},
		groupbar = {
			col = {
				active = primary,
				inactive = outline,
				locked_active = error,
				locked_inactive = outline,
			},
		},
	},
	misc = {
		disable_splash_rendering = true,
		font_family = "Hack Nerd Font",
		force_default_wallpaper = -1,
		layers_hog_keyboard_focus = true,
		animate_manual_resizes = true,
		animate_mouse_windowdragging = true,
		enable_swallow = false,
		focus_on_activate = true,
		anr_missed_pings = 3,
	},
	binds = {
		hide_special_on_workspace_change = true,
		workspace_center_on = 1,
	},
	xwayland = {
		use_nearest_neighbor = false,
		force_zero_scaling = true,
		create_abstract_socket = false,
	},
	render = {
		direct_scanout = 2,
		cm_enabled = true,
		cm_sdr_eotf = "gamma22",
		cm_auto_hdr = 2,
		non_shader_cm = 3,
		send_content_type = true,
		new_render_scheduling = true,
	},
	quirks = {
		prefer_hdr = 1,
	},
	cursor = {
		no_hardware_cursors = 2, -- tearing only
		no_break_fs_vrr = 2, -- auto
		persistent_warps = true,
		default_monitor = monitor0,
		warp_on_change_workspace = true,
		enable_hyprcursor = true,
		sync_gsettings_theme = true,
		-- use_cpu_buffer = 2 # nvidia only
	},
	debug = {
		disable_logs = false,
		disable_time = false,
		damage_blink = false,
		enable_stdout_logs = true,
		colored_stdout_logs = false,
		-- vfr = false
		-- full_cm_proto = true
	},
	dwindle = {
		-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
		preserve_split = true, -- you probably want this
	},
	master = {
		-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
		new_status = "master",
		orientation = "left",
	},
})

hl.on("hyprland.start", function()
	hl.exec_cmd(os.getenv("XDG_CONFIG_HOME") .. "/hypr/scripts/autostart")
end)

hl.on("config.reloaded", function()
	hl.exec_cmd("hyprctl dispatch submap global")
end)
