local mod = {}

-- options.lua to edit
mod.enabled = {}
mod.tile = {}

mod.tilecount = 0

function mod.load(dir)
	loadscript(dir .. "movement")
	loadscript(dir .. "rules")
	loadscript(dir .. "conditions")

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
end

mod.alltiles = {
	"means",
	"bait",
	"lure",
	"turn",
	"copy",
	"with",
}

function mod.addblock(tile)
	if mod.tilecount >= 6 then
		error("Please only enable 6 or less features")
	end

	local tileindex = 121 + mod.tilecount
	local tilename = "object" .. tileindex

	tileslist[tilename] = tile
	tileslist[tilename].tile = {mod.tilecount, 12}
	tileslist[tilename].grid = {11, mod.tilecount}

	mod.tilecount = mod.tilecount + 1
end

return mod