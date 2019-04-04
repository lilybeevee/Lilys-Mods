local mod = {}

-- options.lua to edit
mod.enabled = {}
mod.tile = {}

mod.tilecount = 0

function mod.load(dir)
	loadscript(dir .. "movement")
	loadscript(dir .. "rules")
	loadscript(dir .. "conditions")
	loadscript(dir .. "syntax")
	loadscript(dir .. "tools")
	loadscript(dir .. "undo")

	loadscript(dir .. "options")

	for _,v in ipairs(mod.alltiles) do
		if mod.enabled[v] then
			mod.addblock(mod.tile[v])
		end
	end
end

function mod.unload(dir)
	loadscript("Data/values")
	loadscript("Data/movement")
	loadscript("Data/rules")
	loadscript("Data/conditions")
	loadscript("Data/syntax")
	loadscript("Data/tools")
	loadscript("Data/undo")
end

mod.alltiles = {
	"means",
	"bait",
	"lure",
	"turn",
	"copy",
	"with",
	"still",
}

function mod.addblock(tile)
	if mod.tilecount >= 6 then
		return
	end

	local tileindex = 120 + mod.tilecount
	local tilename = "object" .. tileindex

	tileslist[tilename] = tile
	tileslist[tilename].grid = {11, mod.tilecount}

	mod.tilecount = mod.tilecount + 1
end

return mod