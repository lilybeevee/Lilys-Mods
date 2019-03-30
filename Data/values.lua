dirs = {{1,0},{0,1},{-1,0},{0,-1},{0,0}}
ndirs = {{1,0},{0,-1},{-1,0},{0,1},{0,0}}
dirs_diagonals = {{1,0},{0,-1},{-1,0},{0,1},{1,1},{1,-1},{-1,-1},{-1,1},{0,0}}

colours = {
	default = {0, 3},
	background = {0, 4},
	edge = {1, 0},
	backparticles = {6, 4},
	editorui = {3, 2},
	selector = {1, 4},
	level = {0, 3},
	path = {4, 1},
	menu_background = {1, 0},
	toggle_on = {4,1},
	blocked = {2,2},
	intro = {
		presents = {1, 4},
		b = {4, 1},
		a = {4, 1},
		y = {4, 1},
		o = {4, 1},
		u = {4, 1},
		i = {0, 3},
		s = {0, 3},
		dash = {0, 3},
		dim_purple = {4, 0},
		dim_white = {0, 2},
	},
	flowers =
	{
		{1, 4},
		{2, 4},
		{2, 3},
		{1, 3},
		{4, 2},
		{5, 3},
	},
}

colourtiles = {
	{"red", {2, 2}},
	{"blue", {1, 3}},
	{"yellow", {2, 4}},
	{"orange", {2, 3}},
	{"green", {5, 2}},
	{"pink", {4, 2}},
	{"purple", {3, 3}},
	{"white", {0, 3}},
}

operators = 
{
	all = {},
	cond_arg = {},
	cond_simple = {},
	cond_start = {},
	verb = {},
	verb_all = {},
}
conditions = {}

keys = 
{
	right = 0,
	up = 1,
	left = 2,
	down = 3,
	idle = 4,
	restart = 5,
	undo = 6,
	quit = 7,
}

binds =
{
	raw =
	{
	b0 = {1, 0, 0},
	b1 = {2, 0, 1},
	b2 = {3, 0, 2},
	b3 = {4, 0, 3},
	b4 = {5, 0, 4},
	b5 = {6, 0, 5},
	b6 = {7, 0, 6},
	b7 = {8, 0, 7},
	b8 = {9, 0, 8},
	b9 = {10, 0, 9},
	b10 = {11, 0, 10},
	b11 = {12, 0, 11},
	b12 = {13, 0, 12},
	b13 = {14, 0, 13},
	b14 = {15, 0, 14},
	b15 = {16, 0, 15},
	b16 = {17, 0, 16},
	b17 = {18, 0, 17},
	b18 = {19, 0, 18},
	b19 = {20, 0, 19},
	b20 = {21, 0, 20},
	b21 = {22, 0, 21},
	b22 = {23, 0, 22},
	b23 = {24, 0, 23},
	b24 = {25, 0, 24},
	a0 = {26, 0, 25},
	a1 = {27, 0, 25},
	a2 = {28, 0, 26},
	a3 = {29, 0, 26},
	a4 = {30, 0, 27},
	a5 = {31, 0, 27},
	a6 = {32, 0, 28},
	a7 = {33, 0, 28},
	a8 = {34, 0, 29},
	["h0.0"] = {35, 2, 13},
	["h0.1"] = {36, 2, 13},
	["h0.2"] = {37, 2, 13},
	["h0.3"] = {38, 2, 13},
	["h0.4"] = {39, 2, 13},
	["h0.5"] = {40, 2, 13},
	["h0.6"] = {41, 2, 13},
	["h0.7"] = {42, 2, 13},
	["h0.8"] = {43, 2, 13},
	["h0.9"] = {44, 2, 13},
	["b-1"] = {45, 2, 14},
	},
	named =
	{
	a = {1, 2, 0},
	b = {2, 2, 1},
	x = {3, 2, 2},
	y = {4, 2, 3},
	start = {5, 2, 4},
	back = {6, 2, 5},
	guide = {7, 2, 6},
	leftshoulder = {8, 2, 7},
	rightshoulder = {9, 2, 8},
	lefttrigger = {10, 2, 9},
	righttrigger = {11, 2, 10},
	leftstick = {12, 2, 11},
	rightstick = {13, 2, 12},
	leftx = {14, 2, 11},
	lefty = {15, 2, 11},
	rightx = {16, 2, 12},
	righty = {17, 2, 12},
	dpup = {18, 2, 13},
	dpright = {19, 2, 13},
	dpdown = {20, 2, 13},
	dpleft = {21, 2, 13},
	},
	
	keyboard =
	{
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"1","2","3","4","5","6","7","8","9","0",
		"Right","Up","Left","Down",
		".",",","-","+","�","'","�","�","<",
		"Control","Shift","Return","Esc","Space","Backspace",
	},
}

soundnames =
{
	{
		name = "pop",
		count = 5,
	},
	{
		name = "",
	},
	{
		name = "plop",
		count = 4,
	},
	{
		name = "turn",
	},
	{
		name = "move_hi",
		count = 6,
	},
	{
		name = "tele",
		count = 4,
	},
	{
		name = "lock",
		count = 4,
	},
	{
		name = "move",
		count = 6,
	},
	{
		name = "burn",
		count = 6,
	},
	{
		name = "done",
		count = 4,
	},
}

tileslist =
{
	edge =
	{
		-- SPECIAL CASE
		colour = {0, 2},
		tile = {0, 0},
	},
	object000 =
	{
		name = "baba",
		sprite = "baba",
		sprite_in_root = true,
		unittype = "object",
		tiling = 2,
		type = 0,
		colour = {0, 3},
		tile = {1, 0},
		grid = {0, 1},
		layer = 18,
	},
	object001 =
	{
		name = "keke",
		sprite = "keke",
		sprite_in_root = true,
		unittype = "object",
		tiling = 2,
		type = 0,
		colour = {2, 2},
		tile = {2, 0},
		grid = {0, 2},
		layer = 18,
	},
	object002 =
	{
		name = "rock",
		sprite = "rock",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {6, 2},
		tile = {3, 0},
		grid = {0, 4},
		layer = 16,
	},
	object003 =
	{
		name = "text_grass",
		sprite = "text_grass",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {5, 1},
		active = {5, 3},
		tile = {4, 0},
		grid = {4, 4},
		layer = 20,
	},
	object004 =
	{
		name = "tile",
		sprite = "tile",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {1, 0},
		tile = {5, 0},
		grid = {3, 7},
		layer = 4,
	},
	object005 =
	{
		name = "text_and",
		sprite = "text_and",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 6,
		colour = {0, 1},
		active = {0, 3},
		tile = {6, 0},
		grid = {2, 0},
		layer = 20,
	},
	object006 =
	{
		name = "text_hide",
		sprite = "text_hide",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {3, 2},
		active = {3, 3},
		tile = {7, 0},
		grid = {8, 6},
		layer = 20,
	},
	object007 =
	{
		name = "text_follow",
		sprite = "text_follow",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb",
		colour = {5, 0},
		active = {5, 2},
		tile = {8, 0},
		grid = {10, 5},
		layer = 20,
	},
	object008 =
	{
		name = "text_float",
		sprite = "text_float",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 2},
		active = {1, 4},
		tile = {9, 0},
		grid = {10, 2},
		layer = 20,
	},
	object009 =
	{
		name = "text_lonely",
		sprite = "text_lonely",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 3,
		operatortype = "cond_start",
		colour = {2, 1},
		active = {2, 2},
		tile = {10, 0},
		grid = {9, 4},
		layer = 20,
	},
	object010 =
	{
		name = "lava",
		sprite = "water",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {2, 3},
		tile = {11, 0},
		grid = {9, 9},
		layer = 2,
	},
	object011 =
	{
		name = "water",
		sprite = "water",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {1, 3},
		tile = {0, 1},
		grid = {0, 6},
		layer = 2,
	},
	object012 =
	{
		name = "wall",
		sprite = "wall",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {1, 1},
		tile = {1, 1},
		grid = {0, 5},
		layer = 14,
	},
	object013 =
	{
		name = "text_empty",
		sprite = "text_empty",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {0, 1},
		active = {0, 3},
		tile = {2, 1},
		grid = {6, 0},
		layer = 20,
	},
	object014 =
	{
		name = "text_tile",
		sprite = "text_tile",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {1, 1},
		active = {0, 1},
		tile = {3, 1},
		grid = {4, 7},
		layer = 20,
	},
	object015 =
	{
		name = "text_weak",
		sprite = "text_weak",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 1},
		active = {1, 2},
		tile = {4, 1},
		grid = {7, 3},
		layer = 20,
	},
	object016 =
	{
		name = "text_near",
		sprite = "text_near",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 7,
		operatortype = "cond_arg",
		colour = {0, 1},
		active = {0, 3},
		tile = {5, 1},
		grid = {8, 4},
		layer = 20,
	},
	object017 =
	{
		name = "cloud",
		sprite = "cloud",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {1, 4},
		tile = {6, 1},
		grid = {5, 5},
		layer = 14,
	},
	object018 =
	{
		name = "pillar",
		sprite = "pillar",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {0, 1},
		tile = {7, 1},
		grid = {5, 6},
		layer = 16,
	},
	object019 =
	{
		name = "text_fungus",
		sprite = "text_fungus",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 0},
		active = {6, 1},
		tile = {8, 1},
		grid = {8, 7},
		layer = 20,
	},
	object020 =
	{
		name = "text_baba",
		sprite = "text_baba",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {4, 0},
		active = {4, 1},
		tile = {9, 1},
		grid = {1, 1},
		layer = 20,
	},
	object021 =
	{
		name = "text_keke",
		sprite = "text_keke",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {2, 1},
		active = {2, 2},
		tile = {10, 1},
		grid = {1, 2},
		layer = 20,
	},
	object022 =
	{
		name = "text_flag",
		sprite = "text_flag",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 1},
		active = {2, 4},
		tile = {11, 1},
		grid = {1, 3},
		layer = 20,
	},
	object023 =
	{
		name = "flag",
		sprite = "flag",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 4},
		tile = {0, 2},
		grid = {0, 3},
		layer = 17,
	},
	object024 =
	{
		name = "ice",
		sprite = "ice",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {1, 2},
		tile = {1, 2},
		grid = {3, 3},
		layer = 9,
	},
	object025 =
	{
		name = "text_shift",
		sprite = "text_shift",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 2},
		active = {1, 3},
		tile = {2, 2},
		grid = {2, 9},
		layer = 20,
	},
	object026 =
	{
		name = "rose",
		sprite = "rose",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 2},
		tile = {3, 2},
		grid = {9, 10},
		layer = 16,
	},
	object027 =
	{
		name = "text_all",
		sprite = "text_all",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {0, 1},
		active = {0, 3},
		tile = {4, 2},
		grid = {5, 0},
		layer = 20,
	},
	object028 =
	{
		name = "text_right",
		sprite = "text_right",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 3},
		active = {1, 4},
		tile = {5, 2},
		grid = {7, 1},
		layer = 20,
	},
	object029 =
	{
		name = "text_cloud",
		sprite = "text_cloud",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {1, 3},
		active = {1, 4},
		tile = {6, 2},
		grid = {6, 5},
		layer = 20,
	},
	object030 =
	{
		name = "text_pillar",
		sprite = "text_pillar",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {0, 0},
		active = {0, 1},
		tile = {7, 2},
		grid = {6, 6},
		layer = 20,
	},
	object031 =
	{
		name = "fungus",
		sprite = "fungus",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {6, 1},
		tile = {8, 2},
		grid = {7, 7},
		layer = 16,
	},
	object032 =
	{
		name = "text_rock",
		sprite = "text_rock",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 0},
		active = {6, 1},
		tile = {9, 2},
		grid = {1, 4},
		layer = 20,
	},
	object033 =
	{
		name = "text_lava",
		sprite = "text_lava",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {2, 2},
		active = {2, 3},
		tile = {10, 2},
		grid = {10, 9},
		layer = 20,
	},
	object034 =
	{
		name = "text_wall",
		sprite = "text_wall",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {1, 1},
		active = {0, 1},
		tile = {11, 2},
		grid = {1, 5},
		layer = 20,
	},
	object035 =
	{
		name = "text_ice",
		sprite = "text_ice",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {1, 2},
		active = {1, 3},
		tile = {0, 3},
		grid = {4, 3},
		layer = 20,
	},
	object036 =
	{
		name = "text_is",
		sprite = "text_is",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb_all",
		colour = {0, 1},
		active = {0, 3},
		tile = {1, 3},
		grid = {1, 0},
		layer = 20,
	},
	object037 =
	{
		name = "text_rose",
		sprite = "text_rose",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {2, 1},
		active = {2, 2},
		tile = {7, 3},
		grid = {10, 10},
		layer = 20,
	},
	object038 =
	{
		name = "text_more",
		sprite = "text_more",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {4, 0},
		active = {4, 1},
		tile = {3, 3},
		grid = {10, 3},
		layer = 20,
	},
	object039 =
	{
		name = "text_safe",
		sprite = "text_safe",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {0, 1},
		active = {0, 3},
		tile = {4, 3},
		grid = {7, 6},
		layer = 20,
	},
	object040 =
	{
		name = "text_up",
		sprite = "text_up",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 3},
		active = {1, 4},
		tile = {5, 3},
		grid = {6, 1},
		layer = 20,
	},
	object041 =
	{
		name = "star",
		sprite = "star",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 4},
		tile = {6, 3},
		grid = {5, 9},
		layer = 16,
	},
	object042 =
	{
		name = "text_word",
		sprite = "text_word",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {0, 2},
		active = {0, 3},
		tile = {0, 11},
		grid = {8, 0},
		layer = 20,
	},
	object043 =
	{
		name = "text_fruit",
		sprite = "text_fruit",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {2, 1},
		active = {2, 2},
		tile = {8, 3},
		grid = {4, 10},
		layer = 20,
	},
	object044 =
	{
		name = "text_water",
		sprite = "text_water",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {1, 2},
		active = {1, 3},
		tile = {9, 3},
		grid = {1, 6},
		layer = 20,
	},
	object045 =
	{
		name = "text_win",
		sprite = "text_win",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {6, 1},
		active = {2, 4},
		tile = {10, 3},
		grid = {2, 3},
		layer = 20,
	},
	object046 =
	{
		name = "text_push",
		sprite = "text_push",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {6, 0},
		active = {6, 1},
		tile = {11, 3},
		grid = {2, 4},
		layer = 20,
	},
	object047 =
	{
		name = "text_stop",
		sprite = "text_stop",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {5, 0},
		active = {5, 1},
		tile = {0, 4},
		grid = {2, 5},
		layer = 20,
	},
	object048 =
	{
		name = "text_move",
		sprite = "text_move",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {5, 1},
		active = {5, 3},
		tile = {1, 4},
		grid = {2, 2},
		layer = 20,
	},
	object049 =
	{
		name = "text_best",
		sprite = "text_best",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {2, 3},
		active = {2, 4},
		tile = {2, 4},
		grid = {9, 2},
		layer = 20,
	},
	object050 =
	{
		name = "text_tele",
		sprite = "text_tele",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 2},
		active = {1, 4},
		tile = {3, 4},
		grid = {8, 1},
		layer = 20,
	},
	object051 =
	{
		name = "hand",
		sprite = "hand",
		sprite_in_root = true,
		unittype = "object",
		tiling = 0,
		type = 0,
		colour = {0, 3},
		tile = {4, 4},
		grid = {7, 8},
		layer = 17,
	},
	object052 =
	{
		name = "text_left",
		sprite = "text_left",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 3},
		active = {1, 4},
		tile = {5, 4},
		grid = {6, 2},
		layer = 20,
	},
	object053 =
	{
		name = "text_star",
		sprite = "text_star",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 1},
		active = {2, 4},
		tile = {6, 4},
		grid = {6, 9},
		layer = 20,
	},
	object054 =
	{
		name = "text_red",
		sprite = "text_red",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {2, 1},
		active = {2, 2},
		tile = {7, 4},
		grid = {10, 6},
		layer = 20,
	},
	object055 =
	{
		name = "fruit",
		sprite = "fruit",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 2},
		tile = {8, 4},
		grid = {3, 10},
		layer = 16,
	},
	object056 =
	{
		name = "text_melt",
		sprite = "text_melt",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 2},
		active = {1, 3},
		tile = {9, 4},
		grid = {5, 3},
		layer = 20,
	},
	object057 =
	{
		name = "text_hot",
		sprite = "text_hot",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {2, 2},
		active = {2, 3},
		tile = {10, 4},
		grid = {6, 3},
		layer = 20,
	},
	object058 =
	{
		name = "text_you",
		sprite = "text_you",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {4, 0},
		active = {4, 1},
		tile = {11, 4},
		grid = {2, 1},
		layer = 20,
	},
	object059 =
	{
		name = "text_not",
		sprite = "text_not",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 4,
		colour = {2, 1},
		active = {2, 2},
		tile = {0, 5},
		grid = {4, 0},
		layer = 20,
	},
	object060 =
	{
		name = "text_sink",
		sprite = "text_sink",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 2},
		active = {1, 3},
		tile = {1, 5},
		grid = {2, 6},
		layer = 20,
	},
	object061 =
	{
		name = "love",
		sprite = "love",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {4, 2},
		tile = {2, 5},
		grid = {3, 5},
		layer = 16,
	},
	object062 =
	{
		name = "door",
		sprite = "door",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 2},
		tile = {3, 5},
		grid = {3, 2},
		layer = 15,
	},
	object063 =
	{
		name = "text_hand",
		sprite = "text_hand",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {0, 1},
		active = {0, 3},
		tile = {4, 5},
		grid = {8, 8},
		layer = 20,
	},
	object064 =
	{
		name = "text_down",
		sprite = "text_down",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 3},
		active = {1, 4},
		tile = {5, 5},
		grid = {7, 2},
		layer = 20,
	},
	object065 =
	{
		name = "dust",
		sprite = "dust",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {6, 2},
		tile = {6, 5},
		grid = {9, 8},
		layer = 12,
	},
	object066 =
	{
		name = "text_flower",
		sprite = "text_flower",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {3, 2},
		active = {3, 3},
		tile = {7, 5},
		grid = {6, 4},
		layer = 20,
	},
	object067 =
	{
		name = "text_tree",
		sprite = "text_tree",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {5, 1},
		active = {5, 2},
		tile = {8, 5},
		grid = {4, 9},
		layer = 20,
	},
	object068 =
	{
		name = "ghost",
		sprite = "ghost",
		sprite_in_root = true,
		unittype = "object",
		tiling = 0,
		type = 0,
		colour = {4, 2},
		tile = {10, 10},
		grid = {5, 8},
		layer = 17,
	},
	object069 =
	{
		name = "text_defeat",
		sprite = "text_defeat",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {2, 0},
		active = {2, 1},
		tile = {10, 5},
		grid = {2, 7},
		layer = 20,
	},
	object070 =
	{
		name = "skull",
		sprite = "skull",
		sprite_in_root = true,
		unittype = "object",
		tiling = 0,
		type = 0,
		colour = {2, 1},
		tile = {11, 5},
		grid = {0, 7},
		layer = 16,
	},
	object071 =
	{
		name = "grass",
		sprite = "grass",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {5, 0},
		tile = {0, 6},
		grid = {3, 4},
		layer = 10,
	},
	object072 =
	{
		name = "text_skull",
		sprite = "text_skull",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {2, 0},
		active = {2, 1},
		tile = {1, 6},
		grid = {1, 7},
		layer = 20,
	},
	object073 =
	{
		name = "text_love",
		sprite = "text_love",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {4, 1},
		active = {4, 2},
		tile = {2, 6},
		grid = {4, 5},
		layer = 20,
	},
	object074 =
	{
		name = "text_door",
		sprite = "text_door",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {2, 1},
		active = {2, 2},
		tile = {3, 6},
		grid = {4, 2},
		layer = 20,
	},
	object075 =
	{
		name = "text_text",
		sprite = "text_text",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {4, 0},
		active = {4, 1},
		tile = {4, 6},
		grid = {7, 0},
		layer = 20,
	},
	object076 =
	{
		name = "text_sleep",
		sprite = "text_sleep",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 3},
		active = {1, 4},
		tile = {5, 6},
		grid = {8, 3},
		layer = 20,
	},
	object077 =
	{
		name = "text_dust",
		sprite = "text_dust",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 2},
		active = {2, 4},
		tile = {6, 6},
		grid = {10, 8},
		layer = 20,
	},
	object078 =
	{
		name = "text_blue",
		sprite = "text_blue",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {3, 2},
		active = {3, 3},
		tile = {7, 6},
		grid = {9, 6},
		layer = 20,
	},
	object079 =
	{
		name = "tree",
		sprite = "tree",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {5, 2},
		tile = {8, 6},
		grid = {3, 9},
		layer = 15,
	},
	object080 =
	{
		name = "key",
		sprite = "key",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 4},
		tile = {9, 6},
		grid = {3, 1},
		layer = 16,
	},
	object081 =
	{
		name = "text_key",
		sprite = "text_key",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 1},
		active = {2, 4},
		tile = {10, 6},
		grid = {4, 1},
		layer = 20,
	},
	object082 =
	{
		name = "text_open",
		sprite = "text_open",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {6, 1},
		active = {2, 4},
		tile = {11, 6},
		grid = {5, 1},
		layer = 20,
	},
	object083 =
	{
		name = "text_shut",
		sprite = "text_shut",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {2, 1},
		active = {2, 2},
		tile = {0, 7},
		grid = {5, 2},
		layer = 20,
	},
	object084 =
	{
		name = "text_has",
		sprite = "text_has",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb",
		colour = {0, 1},
		active = {0, 3},
		tile = {1, 7},
		grid = {3, 0},
		layer = 20,
	},
	object085 =
	{
		name = "box",
		sprite = "box",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {6, 2},
		tile = {2, 7},
		grid = {0, 8},
		layer = 16,
	},
	object086 =
	{
		name = "text_box",
		sprite = "text_box",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 0},
		active = {6, 1},
		tile = {3, 7},
		grid = {1, 8},
		layer = 20,
	},
	object087 =
	{
		name = "belt",
		sprite = "belt",
		sprite_in_root = true,
		unittype = "object",
		tiling = 3,
		type = 0,
		colour = {1, 1},
		tile = {4, 7},
		grid = {0, 9},
		layer = 11,
	},
	object088 =
	{
		name = "text_make",
		sprite = "text_make",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb",
		colour = {0, 1},
		active = {0, 3},
		tile = {5, 7},
		grid = {7, 5},
		layer = 20,
	},
	object089 =
	{
		name = "text_fall",
		sprite = "text_fall",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {5, 1},
		active = {5, 3},
		tile = {6, 7},
		grid = {9, 3},
		layer = 20,
	},
	object090 =
	{
		name = "flower",
		sprite = "flower",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {3, 3},
		tile = {7, 7},
		grid = {5, 4},
		layer = 12,
	},
	object091 =
	{
		name = "text_fence",
		sprite = "text_fence",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 0},
		active = {6, 1},
		tile = {8, 7},
		grid = {10, 7},
		layer = 20,
	},
	object092 =
	{
		name = "text_belt",
		sprite = "text_belt",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {1, 2},
		active = {1, 3},
		tile = {9, 7},
		grid = {1, 9},
		layer = 20,
	},
	object093 =
	{
		name = "me",
		sprite = "me",
		sprite_in_root = true,
		unittype = "object",
		tiling = 2,
		type = 0,
		colour = {3, 1},
		tile = {10, 7},
		grid = {3, 6},
		layer = 18,
	},
	object094 =
	{
		name = "text_me",
		sprite = "text_me",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {3, 0},
		active = {3, 1},
		tile = {11, 7},
		grid = {4, 6},
		layer = 20,
	},
	object095 =
	{
		name = "text_swap",
		sprite = "text_swap",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {3, 0},
		active = {3, 1},
		tile = {2, 8},
		grid = {8, 2},
		layer = 20,
	},
	object096 =
	{
		name = "text_pull",
		sprite = "text_pull",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {6, 1},
		active = {6, 2},
		tile = {3, 8},
		grid = {2, 8},
		layer = 20,
	},
	object097 =
	{
		name = "text_on",
		sprite = "text_on",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 7,
		operatortype = "cond_arg",
		colour = {0, 1},
		active = {0, 3},
		tile = {4, 8},
		grid = {7, 4},
		layer = 20,
	},
	object098 =
	{
		name = "moon",
		sprite = "moon",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {2, 4},
		tile = {6, 8},
		grid = {5, 10},
		layer = 16,
	},
	object099 =
	{
		name = "text_ghost",
		sprite = "text_ghost",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {4, 1},
		active = {4, 2},
		tile = {11, 10},
		grid = {6, 8},
		layer = 20,
	},
	object100 =
	{
		name = "fence",
		sprite = "fence",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {6, 1},
		tile = {8, 8},
		grid = {9, 7},
		layer = 14,
	},
	object101 =
	{
		name = "hedge",
		sprite = "hedge",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {5, 1},
		tile = {0, 9},
		grid = {7, 9},
		layer = 14,
	},
	object102 =
	{
		name = "text_hedge",
		sprite = "text_hedge",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {5, 0},
		active = {5, 1},
		tile = {1, 9},
		grid = {8, 9},
		layer = 20,
	},
	object103 =
	{
		name = "text_level",
		sprite = "text_level",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {4, 0},
		active = {4, 1},
		tile = {2, 9},
		grid = {9, 0},
		layer = 20,
	},
	object104 =
	{
		name = "text_orb",
		sprite = "text_orb",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {4, 0},
		active = {4, 1},
		tile = {3, 9},
		grid = {1, 10},
		layer = 20,
	},
	object105 =
	{
		name = "orb",
		sprite = "orb",
		sprite_in_root = true,
		unittype = "object",
		tiling = -1,
		type = 0,
		colour = {4, 1},
		tile = {4, 9},
		grid = {0, 10},
		layer = 17,
	},
	object106 =
	{
		name = "text_bonus",
		sprite = "text_bonus",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {4, 0},
		active = {4, 1},
		tile = {5, 9},
		grid = {2, 10},
		layer = 20,
	},
	object107 =
	{
		name = "text_moon",
		sprite = "text_moon",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 1},
		active = {2, 4},
		tile = {6, 9},
		grid = {6, 10},
		layer = 20,
	},
	object108 =
	{
		name = "text_group",
		sprite = "text_group",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {3, 2},
		active = {3, 3},
		tile = {7, 9},
		grid = {10, 0},
		layer = 20,
	},
	object109 =
	{
		name = "text_line",
		sprite = "text_line",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {0, 2},
		active = {0, 3},
		tile = {8, 9},
		grid = {4, 8},
		layer = 20,
	},
	object110 =
	{
		name = "brick",
		sprite = "brick",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {6, 3},
		tile = {9, 9},
		grid = {7, 10},
		layer = 10,
	},
	object111 =
	{
		name = "text_brick",
		sprite = "text_brick",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {6, 0},
		active = {6, 1},
		tile = {10, 9},
		grid = {8, 10},
		layer = 20,
	},
	object112 =
	{
		name = "text_wonder",
		sprite = "text_wonder",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {0, 1},
		active = {0, 3},
		tile = {11, 9},
		grid = {9, 1},
		layer = 20,
	},
	object113 =
	{
		name = "text_eat",
		sprite = "text_eat",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb",
		colour = {2, 1},
		active = {2, 2},
		tile = {0, 10},
		grid = {8, 5},
		layer = 20,
	},
	object114 =
	{
		name = "text_statue",
		sprite = "text_statue",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 0,
		colour = {0, 0},
		active = {0, 1},
		tile = {1, 10},
		grid = {6, 7},
		layer = 20,
	},
	object115 =
	{
		name = "statue",
		sprite = "statue",
		sprite_in_root = true,
		unittype = "object",
		tiling = 0,
		type = 0,
		colour = {0, 1},
		tile = {2, 10},
		grid = {5, 7},
		layer = 17,
	},
	object116 =
	{
		name = "text_facing",
		sprite = "text_facing",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 7,
		operatortype = "cond_arg",
		argextra = {"right","up","left","down"},
		colour = {0, 2},
		active = {0, 3},
		tile = {9, 10},
		grid = {10, 4},
		layer = 20,
	},
	object117 =
	{
		name = "line",
		sprite = "line",
		sprite_in_root = true,
		unittype = "object",
		tiling = 1,
		type = 0,
		colour = {0, 3},
		tile = {8, 10},
		grid = {3, 8},
		layer = 21,
	},
	object118 =
	{
		name = "text_fear",
		sprite = "text_fear",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb",
		colour = {2, 1},
		active = {2, 2},
		tile = {7, 10},
		grid = {9, 5},
		layer = 20,
	},
	object119 =
	{
		name = "text_sad",
		sprite = "text_sad",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 1},
		active = {3, 2},
		tile = {6, 10},
		grid = {10, 1},
		layer = 20,
	},
	--
	-- CUSTOM BLOCKS START
	--
	object120 =
	{
		name = "text_bait",
		sprite = "text_bait",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {3, 2},
		active = {3, 3},
		tile = {1, 12},
		grid = {11, 1},
		layer = 20,
	},
	object121 =
	{
		name = "text_lure",
		sprite = "text_lure",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {2, 2},
		active = {2, 3},
		tile = {2, 12},
		grid = {11, 2},
		layer = 20,
	},
	object122 =
	{
		name = "text_means",
		sprite = "text_means",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 8,
		operatortype = "verb_all",
		colour = {0, 1},
		active = {0, 3},
		tile = {0, 12},
		grid = {11, 0},
		layer = 20,
	},
	object123 = 
	{
		name = "text_copy",
		sprite = "text_copy",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 1,
		operatortype = "verb",
		colour = {2, 1},
		active = {2, 2},
		tile = {3, 12},
		grid = {11, 4},
		layer = 20,
	},
	object124 =
	{
		name = "text_with",
		sprite = "text_with",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 7,
		operatortype = "cond_arg",
		argtype = {2},
		colour = {0, 1},
		active = {0, 3},
		tile = {4, 12},
		grid = {11, 5},
		layer = 20,
	},
	object125 = 
	{
		name = "text_turn",
		sprite = "text_turn",
		sprite_in_root = true,
		unittype = "text",
		tiling = -1,
		type = 2,
		colour = {1, 3},
		active = {1, 4},
		tile = {5, 12},
		grid = {11, 3},
		layer = 20,
	},
}