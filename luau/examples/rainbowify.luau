--!strict

local function rainbowify_foreground(message: string): string
	local parsed_terminal_message: {string} = {}
	local color_map = {
		TERMINAL.OUT.STYLE.FOREGROUND.RED,
		TERMINAL.OUT.STYLE.FOREGROUND.YELLOW,
		TERMINAL.OUT.STYLE.FOREGROUND.GREEN,
		TERMINAL.OUT.STYLE.FOREGROUND.BLUE,
		TERMINAL.OUT.STYLE.FOREGROUND.MAGENTA,
	}

	for i, char in message:split('') do
		table.insert(parsed_terminal_message, char ~= ' ' and color_map[i%5+1](char) or char)
	end
	return table.concat(parsed_terminal_message)
end

local function rainbowify_background(message: string): string
	local parsed_terminal_message: {string} = {}
	local color_map = {
		TERMINAL.OUT.STYLE.BACKGROUND.RED,
		TERMINAL.OUT.STYLE.BACKGROUND.YELLOW,
		TERMINAL.OUT.STYLE.BACKGROUND.GREEN,
		TERMINAL.OUT.STYLE.BACKGROUND.BLUE,
		TERMINAL.OUT.STYLE.BACKGROUND.MAGENTA,
	}

	for i, char in message:split('') do
		table.insert(parsed_terminal_message, char ~= ' ' and color_map[i%5+1](char) or char)
	end
	return table.concat(parsed_terminal_message)
end

print(rainbowify_background("Rainbow background"))
print(rainbowify_foreground("Rainbow foreground"))
print(rainbowify_background(rainbowify_foreground("Rainbow background and foreground")))