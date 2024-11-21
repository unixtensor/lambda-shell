--!strict
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type class_constructor<CON, F, EXT = {}> = {
	__index: CON,
	new: F,
} & EXT
type class_method<Self, R, T...> = (self: Self, T...) -> R

type map<V, K = string> = {
	[K]: V
}
type lambda<T...> = (f: (T...) -> ()) -> ()
type map_functions = {
	len:        () -> number,
	len_keys:   () -> number,
	len_values: () -> number,
	for_each:   lambda<string, string>
}
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
type shell = {
	system: {
		desktop_env: string,
		devicename:  string,
		username:    string,
		hostname:    string,
		realname:    string,
		platform:    string,
		distro:      string
	},
	env: {
		var:     (string) -> string?,
		vars:    {string},
		set_var: (K: string, V: string) -> (),
		current_dir: {
			file_name: string,
		},
	},
	process: {
		exit_status: string,
		exit_status_changed: lambda<()>
	},
	config: {
		extra_color: boolean,
		verbose: boolean
	},
	prompt: string,
	info: string,
	terminate: () -> ()
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

local Shell = {} :: shell
local Command = {} :: command_builder

local Username = Shell.system.username
local Hostname = Shell.system.hostname

Shell.prompt = `{Username}@{Hostname} λ `

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