--!strict

--scuffed fastfetch
--"rapidfetch"

local arch_ascii_art = [[
                  -`
                 .o+`
                `ooo/
               `+oooo:
              `+oooooo:
              -+oooooo+:
            `/:-:++oooo+:
           `/++++/+++++++:
          `/++++++++++++++:
         `/+++ooooooooooooo/`
        ./ooosssso++osssssso+`
       .oossssso-````/ossssss+`
      -osssssso.      :ssssssso.
     :osssssss/        osssso+++.
    /ossssssss/        +ssssooo/-
  `/ossssso+/:-        -:/+osssso+-
 `+sso+:-`                 `.-/+oso:
`++:.                           `-/+/
.`                                 `/
]]

local BOLD, CYAN = TERMINAL.OUT.FOREGROUND.BOLD, TERMINAL.OUT.FOREGROUND.CYAN
local USER, HOST = BOLD(SHELL.SYSTEM.USERNAME), BOLD(SHELL.SYSTEM.HOSTNAME)

local IsArch = SHELL.SYSTEM.DISTRO == "Arch Linux"
if IsArch then
	print(BOLD(CYAN(arch_ascii_art)))
end
print(IsArch and `{CYAN(USER)}@{CYAN(HOST)}` or `{USER}@{HOST}`)
print("-----------------------")

for name, val in SHELL.SYSTEM do
	print(`{IsArch and BOLD(CYAN(name)) or BOLD(name)}: {val}`)
end