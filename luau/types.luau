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
type func_map<T, A...> = (A...) -> T
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
type text_colors = {
	RED:          func_map<string, string>,
	YELLOW:       func_map<string, string>,
	GREEN:        func_map<string, string>,
	BLUE:         func_map<string, string>,
	MAGENTA:      func_map<string, string>,
	GREY:         func_map<string, string>,
	BLACK:        func_map<string, string>,
	CYAN:         func_map<string, string>,
	WHITE:        func_map<string, string>,
	DARK_GREY:    func_map<string, string>,
	DARK_RED:     func_map<string, string>,
	DARK_GREEN:   func_map<string, string>,
	DARK_CYAN:    func_map<string, string>,
	DARK_YELLOW:  func_map<string, string>,
	DARK_MAGENTA: func_map<string, string>,
	DARK_BLUE:    func_map<string, string>,
}
type TERMINAL = {
	OUT: {
		STYLE: text_colors,
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