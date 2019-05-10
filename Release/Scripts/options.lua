local mod = activemod

---------------------------------------------------
--[[        BLOCK ENABLE/DISABLE OPTIONS       ]]--
---------------------------------------------------
-- !!! PLEASE ONLY ENABLE 6 BLOCKS AT A TIME !!! --
---------------------------------------------------

-- Nouns
mod.enabled["any"]          = false -- Checks for ANY object in conditions, acts as a random object elsewhere
mod.enabled["gravity"]      = false -- Noun which affects the direction of gravity and more!

-- Conditions
mod.enabled["with"]         = true -- True if object has all properties
mod.enabled["still"]        = true -- True if object hasn't moved the past turn 
mod.enabled["nearest"]      = false -- True if object is closest to the given objects (using max distance)
mod.enabled["touch"]        = false -- True if object is adjacent to given objects in a + pattern
mod.enabled["reset any"]    = false -- True if a reset has happened
mod.enabled["reset even"]   = false -- True if the number of resets is even
mod.enabled["reset odd"]    = false -- True if the number of resets is odd
mod.enabled["reset count"]  = false -- True for the first N turns of a reset, where N is the number of resets

-- Verbs
mod.enabled["means"]        = true -- Changes the definition of a noun or property
mod.enabled["copy"]         = true -- Makes object copy another's movements

-- Properties
mod.enabled["sticky"]       = false -- STICKY objects attach to other STICKY objects and move with them
mod.enabled["bait"]         = true -- Attracts LURE objects from afar in a + pattern
mod.enabled["lure"]         = true -- Moves to BAIT objects from afar in a + pattern
mod.enabled["turn"]         = false -- Makes object rotate CCW or CW (option below) each turn
mod.enabled["reset"]        = false -- Resets the level when a YOU touches it, like DEFEAT
mod.enabled["persist"]      = false -- Makes object ignore UNDO
mod.enabled["timeless"]     = false -- Applied to YOU, makes you (or other TIMELESS things) move around in stopped time until you wait
mod.enabled["auto"]         = false -- Makes object do certain things like movement on a timer instead of turns (requires particle effects??)
mod.enabled["cute"]         = false -- Heart effect
mod.enabled["soft"]         = false -- Prevents WEAK objects from dying on it (BABA IS CUTE AND SOFT)

--------------------------
--[[ MECHANIC OPTIONS ]]--
--------------------------

activemod.condition_stacking = true
activemod.auto_speed = 20
-- ccw = counter-clockwise, cw = clockwise
activemod.turn_dir = "ccw"

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
	sprite_in_root = false,
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

mod.tile["nearest"] = {
	name = "text_nearest",
	sprite = "text_nearest",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 7,
	operatortype = "cond_arg",
	colour = {0, 1},
	active = {0, 3},
	tile = {12, 12},
	layer = 20,
}


mod.tile["touch"] = {
	name = "text_touch",
	sprite = "text_touch",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 7,
	operatortype = "cond_arg",
	colour = {0, 1},
	active = {0, 3},
	tile = {13, 12},
	layer = 20,
}

mod.tile["gravity"] = {
	name = "text_gravity",
	sprite = "text_gravity",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 0,
	colour = {3, 1},
	active = {3, 3},
	tile = {14, 12},
	layer = 20,
}

mod.tile["reset any"] = {
	name = "text_reset any",
	sprite = "text_reset any",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 3,
	operatortype = "cond_start",
	colour = {3, 0},
	active = {3, 1},
	tile = {15, 12},
	layer = 20,
}

mod.tile["reset even"] = {
	name = "text_reset even",
	sprite = "text_reset even",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 3,
	operatortype = "cond_start",
	colour = {3, 0},
	active = {3, 1},
	tile = {16, 12},
	layer = 20,
}

mod.tile["reset odd"] = {
	name = "text_reset odd",
	sprite = "text_reset odd",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 3,
	operatortype = "cond_start",
	colour = {3, 0},
	active = {3, 1},
	tile = {17, 12},
	layer = 20,
}

mod.tile["reset count"] = {
	name = "text_reset count",
	sprite = "text_reset count",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 3,
	operatortype = "cond_start",
	colour = {3, 0},
	active = {3, 1},
	tile = {18, 12},
	layer = 20,
}

mod.tile["cute"] = {
	name = "text_cute",
	sprite = "text_cute",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {4, 1},
	active = {4, 2},
	tile = {19, 12},
	layer = 20,
}

mod.tile["soft"] = {
	name = "text_soft",
	sprite = "text_soft",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {0, 2},
	active = {0, 3},
	tile = {20, 12},
	layer = 20,
}

mod.tile["timeless"] = {
	name = "text_timeless",
	sprite = "text_timeless",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {2, 1},
	active = {2, 2},
	tile = {21, 12},
	layer = 20,
}


mod.tile["beam"] = {
	name = "text_beam",
	sprite = "text_beam",
	sprite_in_root = true,
	unittype = "text",
	tiling = -1,
	type = 1,
	operatortype = "verb_all",
	colour = {0, 1},
	active = {0, 3},
	tile = {22, 12},
	layer = 20,
}

mod.tile["reflect"] = {
	name = "text_reflect",
	sprite = "text_reflect",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {23, 12},
	layer = 20,
}

mod.tile["split"] = {
	name = "text_split",
	sprite = "text_split",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {24, 12},
	layer = 20,
}

mod.tile["cross"] = {
	name = "text_cross",
	sprite = "text_cross",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {25, 12},
	layer = 20,
}
-- Current highest tile: {25, 12}