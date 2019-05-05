local mod = {}

-- options.lua to edit
mod.enabled = {}
mod.tile = {}
mod.macros = {}

mod.tilecount = 0

-- Calls when a world is first loaded
function mod.load(dir)
	-- Load mod's script replacements
	loadscript(dir .. "blocks")
	loadscript(dir .. "colours")
	loadscript(dir .. "conditions")
	loadscript(dir .. "convert")
	loadscript(dir .. "effects")
	loadscript(dir .. "features")
	loadscript(dir .. "movement")
	loadscript(dir .. "rules")
	loadscript(dir .. "syntax")
	loadscript(dir .. "tools")
	loadscript(dir .. "undo")

	-- Load other script for mod config
	loadscript(dir .. "options")

	-- Load mod tiles enabled in options.lua
	for _,v in ipairs(mod.alltiles) do
		if mod.enabled[v] then
			mod.addblock(mod.tile[v])
		end
	end
end

-- Calls when another world is loaded while this mod is active
function mod.unload(dir)
	-- Remove custom tiles
	loadscript("Data/values")

	-- Restore modified scripts
	loadscript("Data/blocks")
	loadscript("Data/colours")
	loadscript("Data/conditions")
	loadscript("Data/convert")
	loadscript("Data/effects")
	loadscript("Data/features")
	loadscript("Data/movement")
	loadscript("Data/rules")
	loadscript("Data/syntax")
	loadscript("Data/tools")
	loadscript("Data/undo")
end

mod.alltiles = {
	"means",
	"sticky",
	"bait",
	"lure",
	"turn",
	"reset",
	"persist",
	"timeless",
	"auto",
	"cute",
	"soft",
	"copy",
	"with",
	"still",
	"any",
	"nearest",
	"touch",
	"reset any",
	"reset even",
	"reset odd",
	"reset count",
	"gravity",
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