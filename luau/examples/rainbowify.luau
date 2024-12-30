--!strict

local color_map = {
	[1] = TERMINAL.OUT.STYLE.RED,
	[2] = TERMINAL.OUT.STYLE.YELLOW,
	[3] = TERMINAL.OUT.STYLE.GREEN,
	[4] = TERMINAL.OUT.STYLE.BLUE,
	[5] = TERMINAL.OUT.STYLE.MAGENTA,
}

local function rainbowify(message)
	local iter = 1
	local parsed_terminal_message = {}

	for _, char in message:split('') do
		local styled = char
		if char ~= ' ' then
			styled = color_map[iter%5+1](char)
			iter += 1
		end
		table.insert(parsed_terminal_message, styled)
	end

	return table.concat(parsed_terminal_message)
end

print(rainbowify("rainbow text"))
print(rainbowify("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))