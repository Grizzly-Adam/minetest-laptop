laptop.themes = {
	Freedom = {
		desktop_background = "laptop_theme_freedom_desktop_background.png",
		app_background = "laptop_theme_freedom_app_background.png",
		major_button = "laptop_theme_freedom_major_button.png",
		major_textcolor = "#000000",
		minor_button = "laptop_theme_minor_button.png",
		minor_textcolor = "#000000",
		back_button = "laptop_theme_freedom_back_button.png",
		back_textcolor = "#FFFF00",
		exit_button = "laptop_theme_freedom_exit_button.png",
		exit_textcolor = "#FF0000",
		exit_character = "X",
		desktop_icon_button = "laptop_theme_freedom_desktop_icon_button.png",
		desktop_icon_label_button = "laptop_theme_desktop_icon_label_button_black.png",
		desktop_icon_label_textcolor = '#FFFFFF',
		titlebar_textcolor = "#FFFFFF",
		textcolor = "#000000",
		contrast_background = "gui_formbg.png",
		contrast_textcolor = "#FFFFFF",
		taskbar_clock_position_and_size = "11,9.8;4,0.7",
		node_color = 0,
		tableoptions_background='#000000',
		tableoptions_color='#FFFFFF',
		tableoptions_highlight='#FFFF00',
		tableoptions_highlight_text='#0000FF',
		tableoptions_border='false',
	},
}

laptop.themes.default = laptop.themes.Freedom -- default can be an complete theme only


function laptop.register_theme(name, def)
	laptop.themes[name] = def
end

-- load all themes
local theme_path = minetest.get_modpath('laptop')..'/themes/'
local theme_list = minetest.get_dir_list(theme_path, false)

for _, file in ipairs(theme_list) do
	if file:sub(-10) == '_theme.lua' then
		dofile(theme_path..file)
	end
end

local theme_class = {}
theme_class.__index = theme_class

-- get prepared button textures
function theme_class:get_button(area, prefix, code, text, tooltip)
	local formspec = 'image_button['..area..';'..self[prefix.."_button"]..';'..code..';'.. minetest.colorize(self[prefix.."_textcolor"] or self.textcolor,minetest.formspec_escape(text))..']'
	if tooltip then
		formspec = formspec.."tooltip["..code..";"..minetest.formspec_escape(tooltip).."]"
	end
	return formspec
end

-- get prepared button textures
function theme_class:get_image_button(area, prefix, code, image, text, tooltip)
	local formspec = 'image_button['..area..';'..self[prefix.."_button"]..'^'..image..';'..code..';'.. minetest.colorize(self[prefix.."_textcolor"] or self.textcolor,minetest.formspec_escape(text))..']'
	if tooltip then
		formspec = formspec.."tooltip["..code..";"..minetest.formspec_escape(tooltip).."]"
	end
	return formspec
end


-- Get themed label
function theme_class:get_label(area, label, color_prefix)
	if color_prefix then
		return 'label['..area..';'..minetest.colorize(self[color_prefix.."_textcolor"] or self.textcolor, minetest.formspec_escape(label))..']'
	else
		return 'label['..area..';'..minetest.colorize(self.textcolor, minetest.formspec_escape(label))..']'
	end
end

function theme_class:get_tableoptions()
	local formspec
	for k, v in pairs(self) do
		if k:sub(1,12) == 'tableoptions' then
			if not formspec then
				formspec = k:sub(14,-1)..'='..v
			else
				formspec = formspec..';'..k:sub(14,-1)..'='..v
			end
		end
	end
	if formspec then
		return "tableoptions["..formspec.."]"
	else
		return ""
	end
end


function laptop.get_theme(theme_name)
	local self = setmetatable(table.copy(laptop.themes.default), theme_class)
	if theme_name and laptop.themes[theme_name] then
		for k,v in pairs(laptop.themes[theme_name]) do
			self[k] = v
		end
		self.name = theme_name
	else
		self.name = "default"
	end
	return self
end
