function Linemode:line_mode()
	local year = os.date("%Y")
	local time = (self._file.cha.modified or 0) / 1

	if time > 0 and os.date("%Y", time) == year then
		time = os.date("%b %d %H:%M", time)
	else
		time = time and os.date("%b %d  %Y", time) or ""
	end

	local size = self._file:size()
	local permissions = self._file:permissions()
	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
end
