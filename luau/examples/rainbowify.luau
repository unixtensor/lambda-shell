--!strict

local function rainbowify(message: string): string
	local parsed_terminal_message: {string} = {}
	local color_map = {
		TERMINAL.OUT.STYLE.RED,
		TERMINAL.OUT.STYLE.YELLOW,
		TERMINAL.OUT.STYLE.GREEN,
		TERMINAL.OUT.STYLE.BLUE,
		TERMINAL.OUT.STYLE.MAGENTA,
	}

	for i, char in message:split('') do
		table.insert(parsed_terminal_message, char ~= ' ' and color_map[i%5+1](char) or char)
	end
	return table.concat(parsed_terminal_message)
end

print(rainbowify("rainbow text"))
print(rainbowify("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))