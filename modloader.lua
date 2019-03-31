function loadscript(file)
	package.loaded[file] = false
	local success,result = pcall(function() return require(file) end)
	if success then
		return result
	else
		return nil
	end
end

function loadmods()
	if activemod ~= nil then
		if activemod.unload ~= nil then
			activemod.unload(activemoddir)
		end
	end

	activemod = nil
	activemoddir = ""

	local scriptfolder = "Data/Worlds/" .. generaldata.strings[WORLD] .. "/Scripts/"
	local mod = loadscript(scriptfolder .. "init")
	if mod ~= nil then
		activemod = mod
		activemoddir = scriptfolder
		if activemod.load ~= nil then
			activemod.load(activemoddir)
		end
	end

	generatetiles()
end

local oldworldinit = worldinit
function worldinit()
	loadmods()
	oldworldinit()
end