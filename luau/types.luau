--!strict
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type class_constructor<CON, F, EXT = {}> = {
	__index: CON,
	new: F,
} & EXT
type map_functions = {
	len:        () -> number,
	len_keys:   () -> number,
	len_values: () -> number,
	for_each:   lambda<string, string>
}
type class_method<Self, R, T...> = (self: Self, T...) -> R
type map<V, K = string>          = {[K]: V}
type lambda<T...>                = (f: (T...) -> ()) -> ()
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type SHELL = {
	SYSTEM: {
		DESKTOP_ENV: string,
		DEVICENAME:  string,
		USERNAME:    string,
		HOSTNAME:    string,
		REALNAME:    string,
		PLATFORM:    string,
		DISTRO:      string
	},
	ENV: {
		VAR:     (string) -> string?,
		VARS:    {string},
		SET_VAR: (K: string, V: string) -> (),
		CURRENT_DIR: {
			FILE_NAME: string,
		},
	},
	PROCESS: {
		EXIT_STATUS: string,
		EXIT_STATUS_CHANGED: lambda<()>
	},
	CONFIG: {
		EXTRA_COLOR: boolean,
		VERBOSE: boolean
	},
	PROMPT: string,
	INFO: string,
	TERMINATE: () -> ()
}
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type background_styles = {
	RED:          (string) -> string,
	YELLOW:       (string) -> string,
	GREEN:        (string) -> string,
	BLUE:         (string) -> string,
	MAGENTA:      (string) -> string,
	GREY:         (string) -> string,
	BLACK:        (string) -> string,
	CYAN:         (string) -> string,
	WHITE:        (string) -> string,
	DARK_GREY:    (string) -> string,
	DARK_RED:     (string) -> string,
	DARK_GREEN:   (string) -> string,
	DARK_CYAN:    (string) -> string,
	DARK_YELLOW:  (string) -> string,
	DARK_MAGENTA: (string) -> string,
	DARK_BLUE:    (string) -> string,
	UNDERLINED:   (string) -> string,
	UNDERLINE_DARK_GREY:    (string) -> string,
	UNDERLINE_DARK_RED:     (string) -> string,
	UNDERLINE_DARK_GREEN:   (string) -> string,
	UNDERLINE_DARK_CYAN:    (string) -> string,
	UNDERLINE_DARK_YELLOW:  (string) -> string,
	UNDERLINE_DARK_MAGENTA: (string) -> string,
	UNDERLINE_DARK_BLUE:    (string) -> string,
	UNDERLINE_RED:          (string) -> string,
	UNDERLINE_GREY:         (string) -> string,
	UNDERLINE_BLACK:        (string) -> string,
	UNDERLINE_GREEN:        (string) -> string,
	UNDERLINE_YELLOW:       (string) -> string,
	UNDERLINE_BLUE:         (string) -> string,
	UNDERLINE_MAGENTA:      (string) -> string,
	UNDERLINE_CYAN:         (string) -> string,
	UNDERLINE_WHITE:        (string) -> string,
	BOLD:                   (string) -> string,
}
type foreground_styles = {
	RED:          (string) -> string,
	GREY:         (string) -> string,
	BLACK:        (string) -> string,
	GREEN:        (string) -> string,
	YELLOW:       (string) -> string,
	BLUE:         (string) -> string,
	MAGENTA:      (string) -> string,
	CYAN:         (string) -> string,
	WHITE:        (string) -> string,
	DARK_GREY:    (string) -> string,
	DARK_RED:     (string) -> string,
	DARK_GREEN:   (string) -> string,
	DARK_CYAN:    (string) -> string,
	DARK_YELLOW:  (string) -> string,
	DARK_MAGENTA: (string) -> string,
	DARK_BLUE:    (string) -> string,
}
type TERMINAL = {
	OUT: {
		BACKGROUND: background_styles,
		FOREGROUND: foreground_styles
	}
}
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type command_input = string | command | command_spawn | (command_arg & command_spawn)
type command_arg   = {arg: (string) -> command_arg & command_spawn}
type command_args  = {args: ({string}) -> command_spawn}
type command_spawn = {spawn: () -> boolean}

type command_builder = {
	new: (string) -> command
}
type command = {
	arg: (string) -> command_arg & command_spawn,
} & command_args & command_spawn
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type alias = typeof(setmetatable({} :: alias_properties, {} :: alias_constructor))
type alias_properties = {}

type alias_init = (string, command_input) -> alias
type alias_constructor = class_constructor<alias_constructor, alias_init, {
	map: (map<command_input>) -> map_functions,
	Remove: class_method<alias, nil>
}>
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
export type Alias = alias
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
local Alias = {} :: alias_constructor
Alias.__index = Alias

local SHELL = {} :: SHELL
local TERMINAL = {} :: TERMINAL
local Command = {} :: command_builder

local OUT_COLOR = TERMINAL.OUT.COLOR.BLUE("hi")

local username = SHELL.SYSTEM.USERNAME
local hostname = SHELL.SYSTEM.HOSTNAME

SHELL.PROMPT = `{username}@{hostname} λ `

local command_builder = Command.new("yt-dlp")
					  .arg('--format')
					  .arg('"bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"')
					  .arg('-S')
					  .arg('vcodec:h264,res,acodec:opus')

local command_builder_array = Command.new("yt-dlp").args({
	"--format";
	'"bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"';
	'-S';
	'vcodec:h264,res,acodec:opus'
})

local aliases = Alias.map({
	["weather"] = "curl wttr.in",
	["yt-dlp"]  = command_builder_array
})

local weather_curl = Alias.new("weather", "curl wttr.in")