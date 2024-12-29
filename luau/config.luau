--!strict

local Username = Shell.system.username
local Hostname = Shell.system.hostname

Shell.prompt = `{Username}@{Hostname} λ `