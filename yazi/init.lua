-- Custom linemode for showing size and mtime (based on official Yazi documentation)
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- Alternative simpler linemode
function Linemode:simple_size()
	local size = self._file:size()
	local size_str = size and ya.readable_size(size) or "-"
	return ui.Line(size_str)
end

-- Debug linemode to check all available properties
function Linemode:debug_all()
	local file = self._file
	local parts = {}
	
	-- Check different size properties
	if file.length then
		table.insert(parts, "len:" .. tostring(file.length))
	end
	
	-- Check cha properties
	if file.cha then
		if file.cha.len then
			table.insert(parts, "cha.len:" .. tostring(file.cha.len))
		end
		if file.cha.modified then
			table.insert(parts, "mod:" .. tostring(file.cha.modified))
		end
	end
	
	return ui.Line(table.concat(parts, " "))
end

-- Simple working linemode
function Linemode:working_simple()
	local file = self._file
	local size_str = "-"
	
	-- Try different ways to get size
	if file.length and file.length > 0 then
		size_str = ya.readable_size(file.length)
	elseif file.cha and file.cha.len and file.cha.len > 0 then
		size_str = ya.readable_size(file.cha.len)
	end
	
	return ui.Line(size_str)
end

-- Setup function for plugin configurations
function setup()
	-- Any plugin setup can go here
end
