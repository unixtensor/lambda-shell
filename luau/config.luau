--!strict

local username = SHELL.SYSTEM.USERNAME
local hostname = SHELL.SYSTEM.HOSTNAME

SHELL.PROMPT = `{username}@{hostname} λ `