local mod = activemod

---------------------------------------------------
--[[        BLOCK ENABLE/DISABLE OPTIONS       ]]--
---------------------------------------------------
-- !!! PLEASE ONLY ENABLE 6 BLOCKS AT A TIME !!! --
---------------------------------------------------

-- Specials
mod.enabled["means"] = true
mod.enabled["copy"] = true
mod.enabled["with"] = true
mod.enabled["still"] = true
mod.enabled["any"] = false

-- Properties
mod.enabled["sticky"] = false
mod.enabled["bait"] = true
mod.enabled["lure"] = true
mod.enabled["turn"] = false
mod.enabled["reset"] = false
mod.enabled["persist"] = false
mod.enabled["auto"] = false

--------------------------
--[[ MECHANIC OPTIONS ]]--
--------------------------

activemod.condition_stacking = true
activemod.auto_speed = 20

-------------------------------------------------
--[[   MACROS (CUSTOM FEATURES FROM RULES)   ]]--
-------------------------------------------------
-- Patterns only work in NOUN VERB PROP format --
-------------------------------------------------
--          !!!     UNFINISHED     !!!         --
-------------------------------------------------

--[[activemod.macros["{x} is conduct"] = {
	"{x} near all with hot is hot",
	"{x} near text with hot is hot",
}]]


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
	tile = {0, 12},
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
	tile = {4, 12},
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
	tile = {3, 12},
	layer = 20,
}

mod.tile["still"] = {
	name = "text_still",
	sprite = "text_still",
	sprite_in_root = true,
	unittype = "text",
	tiling = -1,
	type = 3,
	operatortype = "cond_start",
	colour = {0, 1},
	active = {0, 3},
	tile = {6, 12},
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
	tile = {1, 12},
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
	tile = {2, 12},
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
	tile = {5, 12},
	layer = 20,
}

mod.tile["reset"] = {
	name = "text_reset",
	sprite = "text_reset",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {3, 0},
	active = {3, 1},
	tile = {7, 12},
	layer = 20,
}

mod.tile["persist"] = {
	name = "text_persist",
	sprite = "text_persist",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {0, 2},
	active = {0, 3},
	tile = {8, 12},
	layer = 20,
}

mod.tile["auto"] = {
	name = "text_auto",
	sprite = "text_auto",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {0, 2},
	active = {0, 3},
	tile = {9, 12},
	layer = 20,
}

mod.tile["sticky"] = {
	name = "text_sticky",
	sprite = "text_sticky",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {5, 1},
	active = {5, 3},
	tile = {10, 12},
	layer = 20,
}

mod.tile["any"] = {
	name = "text_any",
	sprite = "text_any",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 0,
	colour = {0, 1},
	active = {0, 3},
	tile = {11, 12},
	layer = 20,
}

-- Current highest tile: {11, 12}