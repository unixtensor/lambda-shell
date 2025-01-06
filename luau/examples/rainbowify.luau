--!strict

type term_color_func = (string) -> string

local function rainbowify(str: string, color_map: {term_color_func}): string
	local chars = str:split('')
	for i, char in chars do
		chars[i] = char ~= ' ' and color_map[i%5+1](char) or char
	end
	return table.concat(chars)
end

local function rainbowify_foreground(message: string): string
	return rainbowify(message, {
		TERMINAL.OUT.FOREGROUND.RED,
		TERMINAL.OUT.FOREGROUND.YELLOW,
		TERMINAL.OUT.FOREGROUND.GREEN,
		TERMINAL.OUT.FOREGROUND.BLUE,
		TERMINAL.OUT.FOREGROUND.MAGENTA,
	})
end

local function rainbowify_background(message: string): string
	return rainbowify(message, {
		TERMINAL.OUT.BACKGROUND.RED,
		TERMINAL.OUT.BACKGROUND.YELLOW,
		TERMINAL.OUT.BACKGROUND.GREEN,
		TERMINAL.OUT.BACKGROUND.BLUE,
		TERMINAL.OUT.BACKGROUND.MAGENTA,
	})
end

print(rainbowify_foreground("Rainbow foreground"))
print(
	TERMINAL.OUT.FOREGROUND.BLACK(rainbowify_background("Rainbow background with black text"))
)
print(
	TERMINAL.OUT.BACKGROUND.DARK_GREY(rainbowify_foreground("Rainbow foreground on a dark grey background"))
)