--!strict

local function rainbowify_foreground(message: string): string
	local parsed_terminal_message: {string} = {}
	local color_map = {
		TERMINAL.OUT.FOREGROUND.RED,
		TERMINAL.OUT.FOREGROUND.YELLOW,
		TERMINAL.OUT.FOREGROUND.GREEN,
		TERMINAL.OUT.FOREGROUND.BLUE,
		TERMINAL.OUT.FOREGROUND.MAGENTA,
	}

	for i, char in message:split('') do
		table.insert(parsed_terminal_message, char ~= ' ' and color_map[i%5+1](char) or char)
	end
	return table.concat(parsed_terminal_message)
end

local function rainbowify_background(message: string): string
	local parsed_terminal_message: {string} = {}
	local color_map = {
		TERMINAL.OUT.BACKGROUND.RED,
		TERMINAL.OUT.BACKGROUND.YELLOW,
		TERMINAL.OUT.BACKGROUND.GREEN,
		TERMINAL.OUT.BACKGROUND.BLUE,
		TERMINAL.OUT.BACKGROUND.MAGENTA,
	}

	for i, char in message:split('') do
		table.insert(parsed_terminal_message, char ~= ' ' and color_map[i%5+1](char) or char)
	end
	return table.concat(parsed_terminal_message)
end

print(rainbowify_foreground("Rainbow foreground"))
print(rainbowify_background("Rainbow background"))
print(
	TERMINAL.OUT.BACKGROUND.DARK_GREY(rainbowify_foreground("Rainbow foreground on a dark grey background"))
)