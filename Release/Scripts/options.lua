local mod = activemod

---------------------------------------------------
--[[        BLOCK ENABLE/DISABLE OPTIONS       ]]--
---------------------------------------------------
-- !! PLEASE ONLY ENABLE 6 FEATURES AT A TIME !! --
---------------------------------------------------


-- Specials
mod.enabled["means"] = true
mod.enabled["copy"] = true
mod.enabled["with"] = true

-- Properties
mod.enabled["bait"] = true
mod.enabled["lure"] = true
mod.enabled["turn"] = true


--------------------------------
--[[ ADVANCED BLOCK OPTIONS ]]--
--------------------------------

mod.tile["means"] = {
	name = "text_means",
	sprite = "text_means",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 8,
	operatortype = "verb_all",
	colour = {0, 1},
	active = {0, 3},
	layer = 20,
}

mod.tile["copy"] = {
	name = "text_copy",
	sprite = "text_copy",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 1,
	operatortype = "verb",
	colour = {2, 1},
	active = {2, 2},
	layer = 20,
}

mod.tile["with"] = {
	name = "text_with",
	sprite = "text_with",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 7,
	operatortype = "cond_arg",
	argtype = {2},
	colour = {0, 1},
	active = {0, 3},
	layer = 20,
}

mod.tile["bait"] = {
	name = "text_bait",
	sprite = "text_bait",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {3, 2},
	active = {3, 3},
	layer = 20,
}

mod.tile["lure"] = {
	name = "text_lure",
	sprite = "text_lure",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {2, 2},
	active = {2, 3},
	layer = 20,
}

mod.tile["turn"] = {
	name = "text_turn",
	sprite = "text_turn",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	layer = 20,
}