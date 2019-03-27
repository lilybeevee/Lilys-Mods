menufuncs =
{
	main =
	{
		button = "MainMenuButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 + tilesize * 1
				
				local disable = MF_unfinished()
				local build = generaldata.strings[BUILD]
				
				createbutton("start",x,y,2,8,1,langtext("main_start"),name,3,2,buttonid)
				
				y = y + tilesize
				
				createbutton("settings",x,y,2,8,1,langtext("settings"),name,3,2,buttonid)
				
				if (build == "debug") then
					y = y + tilesize
					
					createbutton("custom",x,y,2,8,1,langtext("main_custom"),name,3,2,buttonid,disable)
					
					y = y + tilesize
					
					createbutton("editor",x,y,2,8,1,langtext("main_editor"),name,3,2,buttonid,disable)
				end
				
				y = y + tilesize
				
				createbutton("credits",x,y,2,8,1,langtext("credits"),name,3,2,buttonid)
				
				if (build ~= "n") then
					y = y + tilesize
					
					createbutton("quit",x,y,2,8,1,langtext("main_exit"),name,3,2,buttonid)
				end
				
				if (generaldata.strings[LANG] ~= "en") then
					local madeby = langtext("intro_madeby")
					
					writetext(madeby,0,screenw * 0.5,screenh - tilesize * 0.8,name,true,1)
				end
			end,
		structure =
		{
			n = {
				{{"start"},},
				{{"settings"},},
				{{"credits"},},
			},
			{
				{{"start"},},
				{{"settings"},},
				{{"credits"},},
				{{"quit"},},
			},
			debug = {
				{{"start"},},
				{{"settings"},},
				{{"custom"},},
				{{"editor"},},
				{{"credits"},},
				{{"quit"},},
			},
		}
	},
	pause =
	{
		button = "PauseMenu",
		enter = 
			function(parent,name,buttonid)
				local x = tilesize * 5
				local y = tilesize * 2
				
				local mx = screenw * 0.5
				
				local leveltitle = generaldata.strings[LEVELNAME]
				if (string.len(generaldata.strings[LEVELNUMBER_NAME]) > #leveltree) then
					leveltitle = generaldata.strings[LEVELNUMBER_NAME] .. ": " .. leveltitle
				end
				
				if (editor.values[LEVELTYPE] == 1) then
					leveltitle = generaldata.strings[LEVELNAME]
				end
				
				displaylevelname(leveltitle,generaldata.strings[CURRLEVEL],2,name,mx,nil,true)
				
				y = y + tilesize
				
				createbutton("resume",mx,y,2,8,1,langtext("resume"),name,1,3,buttonid)
				
				y = y + tilesize
				
				local returndisable = false
				if (#leveltree <= 1) then
					returndisable = true
				end
				
				createbutton("return",mx,y,2,8,1,langtext("pause_returnmap"),name,1,3,buttonid,returndisable)
				
				y = y + tilesize
				
				createbutton("restart",mx,y,2,8,1,langtext("restart"),name,1,3,buttonid)
				
				y = y + tilesize
				
				createbutton("settings",mx,y,2,8,1,langtext("settings"),name,1,3,buttonid)
				
				y = y + tilesize * 1.5
				
				createbutton("returnmain",mx,y,2,8,1,langtext("pause_returnmain"),name,1,3,buttonid)
				
				y = y + tilesize * 1.5
				
				writerules(parent,name,mx,y)
			end,
		structure =
		{
			{
				{{"resume"},},
				{{"return"},},
				{{"restart"},},
				{{"settings"},},
				{{"returnmain"},},
			},
		}
	},
	settings =
	{
		button = "SettingsButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * tilesize
				
				local disable = MF_unfinished()
				local build = generaldata.strings[BUILD]
				
				writetext(langtext("settings") .. ":",0,x,y,name,true,2,true)
				
				x = screenw * 0.5 - tilesize * 1
				y = y + tilesize * 2
				
				writetext(langtext("settings_music") .. ":",0,x - tilesize * 6,y,name,false,2,true)
				local mvolume = MF_read("settings","settings","music")
				slider("music",x,y,8,{1,3},{1,4},buttonid,0,100,tonumber(mvolume))
				
				y = y + tilesize
				
				writetext(langtext("settings_sound") .. ":",0,x - tilesize * 6,y,name,false,2,true)
				local svolume = MF_read("settings","settings","sound")
				slider("sound",x,y,8,{1,3},{1,4},buttonid,0,100,tonumber(svolume))
				
				y = y + tilesize
				
				writetext(langtext("settings_repeat") .. ":",0,x - tilesize * 8.5,y,name,false,2,true)
				local delay = MF_read("settings","settings","delay")
				slider("delay",x,y,8,{1,3},{1,4},buttonid,7,20,tonumber(delay))
				
				x = screenw * 0.5
				y = y + tilesize * 2
				
				if (build == "debug") then
					--ENABLE THIS WHEN TRANSLATIONS'RE READY!
					createbutton("language",x,y,2,16,1,langtext("settings_language"),name,3,2,buttonid)
					
					y = y + tilesize
				end
				
				if (build ~= "n") then
					createbutton("controls",x,y,2,16,1,langtext("controls"),name,3,2,buttonid)
				
					y = y + tilesize
				
					local fullscreen = MF_read("settings","settings","fullscreen")
					local s,c = gettoggle(fullscreen)
					createbutton("fullscreen",x,y,2,16,1,langtext("settings_fullscreen"),name,3,2,buttonid,nil,s)
					
					y = y + tilesize
				end
				
				local grid = MF_read("settings","settings","grid")
				s,c = gettoggle(grid)
				createbutton("grid",x,y,2,16,1,langtext("settings_grid"),name,3,2,buttonid,nil,s)
				
				y = y + tilesize
				
				local wobble = MF_read("settings","settings","wobble")
				s,c = gettoggle(wobble)
				createbutton("wobble",x,y,2,16,1,langtext("settings_wobble"),name,3,2,buttonid,nil,s)
				
				y = y + tilesize
				
				local contrast = MF_read("settings","settings","contrast")
				s,c = gettoggle(contrast)
				createbutton("contrast",x,y,2,16,1,langtext("settings_palette"),name,3,2,buttonid,nil,s)
				
				y = y + tilesize
				
				local restartask = MF_read("settings","settings","restartask")
				s,c = gettoggle(restartask)
				createbutton("restartask",x,y,2,16,1,langtext("settings_restart"),name,3,2,buttonid,nil,s)
				
				y = y + tilesize
				
				local zoom = MF_read("settings","settings","zoom")
				s,c = gettoggle(zoom)
				createbutton("zoom",x,y,2,16,1,langtext("settings_zoom"),name,3,2,buttonid,nil,s)
				
				--[[
				writetext(langtext("settings_zoom") .. ":",0,x - tilesize * 10,y,name,false,2,true)
				
				local zoom = MF_read("settings","settings","zoom")
				createbutton("zoom1",x - tilesize * 2.7,y,2,5,1,langtext("zoom1"),name,3,2,buttonid,nil)
				createbutton("zoom2",x + tilesize * 2.3,y,2,5,1,langtext("zoom2"),name,3,2,buttonid,nil)
				createbutton("zoom3",x + tilesize * 7.3,y,2,5,1,langtext("zoom3"),name,3,2,buttonid,nil)
				
				makeselection({"zoom2","zoom1","zoom3"},tonumber(zoom) + 1)
				]]
				
				y = y + tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"music",-144},},
				{{"sound",-144},},
				{{"delay",-204},},
				--{{"language"},},
				{{"controls"},},
				{{"fullscreen"},},
				{{"grid"},},
				{{"wobble"},},
				{{"contrast"},},
				{{"restartask"},},
				{{"zoom"},},
				{{"return"},},
			},
			n = {
				{{"music",-144},},
				{{"sound",-144},},
				{{"delay",-204},},
				--{{"language"},},
				{{"grid"},},
				{{"wobble"},},
				{{"contrast"},},
				{{"restartask"},},
				{{"zoom"},},
				{{"return"},},
			},
		}
	},
	controls =
	{
		button = "ControlsButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * tilesize
				
				writetext(langtext("controls_setup") .. ":",0,x,y,name,true,2,true)
				
				local pad,padname = MF_profilefound()
				local padtext = langtext("controls_noconnectedgamepad")
				
				if (pad ~= nil) then
					if pad then
						padtext = langtext("controls_gamepadname") .. ": " .. string.lower(string.sub(padname, 1, math.min(string.len(padname), 25)))
					else
						padtext = langtext("controls_unknowngamepad")
					end
				end
				
				y = y + tilesize * 1
				
				writetext(padtext,0,x,y,name,true,2,true)

				y = y + tilesize * 2
				
				createbutton("detect",x,y,2,16,1,langtext("controls_detectgamepad"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				createbutton("gamepad",x,y,2,16,1,langtext("controls_gamepadsetup"),name,3,2,buttonid)
				
				y = y + tilesize
				
				createbutton("default_gamepad",x,y,2,16,1,langtext("controls_defaultgamepad"),name,3,2,buttonid)
				
				y = y + tilesize * 1.5
				
				createbutton("keyboard",x,y,2,16,1,langtext("controls_keysetup"),name,3,2,buttonid)
				
				y = y + tilesize
				
				createbutton("default_keyboard",x,y,2,16,1,langtext("controls_defaultkey"),name,3,2,buttonid)

				y = y + tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"detect"},},
				{{"gamepad"},},
				{{"default_gamepad"},},
				{{"keyboard"},},
				{{"default_keyboard"},},
				{{"return"},},
			},
		}
	},
	gamepad =
	{
		button = "KeyConfigButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)

				x = x + tilesize * 1.5
				y = y + tilesize * 2
				
				createbutton("move",x - tilesize * 6,y,2,4,1,langtext("move"),name,3,2,buttonid)
				createcontrolicon("move",true,x + tilesize * 2.5,y,buttonid)
				
				createbutton("move2",x - tilesize * 1,y,2,4,1,langtext("move") .. " 2",name,3,2,buttonid)
				createcontrolicon("move2",true,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize * 1.4
				
				createbutton("idle",x - tilesize * 6,y,2,4,1,langtext("idle"),name,3,2,buttonid)
				createcontrolicon("idle",true,x + tilesize * 2.5,y,buttonid)
				
				createbutton("idle2",x - tilesize * 1,y,2,4,1,langtext("idle") .. " 2",name,3,2,buttonid)
				createcontrolicon("idle2",true,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize * 1.4
				
				createbutton("undo",x - tilesize * 6,y,2,4,1,langtext("undo"),name,3,2,buttonid)
				createcontrolicon("undo",true,x + tilesize * 2.5,y,buttonid)
				
				createbutton("undo2",x - tilesize * 1,y,2,4,1,langtext("undo") .. " 2",name,3,2,buttonid)
				createcontrolicon("undo2",true,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize * 1.4
				
				createbutton("restart",x - tilesize * 6,y,2,4,1,langtext("controls_restart"),name,3,2,buttonid)
				createcontrolicon("restart",true,x + tilesize * 2.5,y,buttonid)
				
				createbutton("restart2",x - tilesize * 1,y,2,4,1,langtext("controls_restart") .. " 2",name,3,2,buttonid)
				createcontrolicon("restart2",true,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize * 1.4
				
				createbutton("confirm",x - tilesize * 6,y,2,4,1,langtext("confirm"),name,3,2,buttonid)
				createcontrolicon("confirm",true,x + tilesize * 2.5,y,buttonid)
				
				createbutton("confirm2",x - tilesize * 1,y,2,4,1,langtext("confirm") .. " 2",name,3,2,buttonid)
				createcontrolicon("confirm2",true,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize * 1.4
				
				createbutton("pause",x - tilesize * 3,y,2,8,1,langtext("pause"),name,3,2,buttonid)
				createcontrolicon("pause",true,x + tilesize * 3.5,y,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"move"},{"move2"}},
				{{"idle"},{"idle2"}},
				{{"undo"},{"undo2"}},
				{{"restart"},{"restart2"}},
				{{"confirm"},{"confirm2"}},
				{{"pause"},},
			},
		}
	},
	keyboard =
	{
		button = "KeyConfigButton",
		enter = 
			function(parent,name,buttonid)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = 3 * tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)

				y = y + tilesize * 2
				
				createbutton("right",x - tilesize * 6,y,2,4,1,langtext("right"),name,3,2,buttonid)
				createcontrolicon("right",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("right2",x - tilesize * 1,y,2,4,1,langtext("right") .. " 2",name,3,2,buttonid)
				createcontrolicon("right2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("up",x - tilesize * 6,y,2,4,1,langtext("up"),name,3,2,buttonid)
				createcontrolicon("up",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("up2",x - tilesize * 1,y,2,4,1,langtext("up") .. " 2",name,3,2,buttonid)
				createcontrolicon("up2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("left",x - tilesize * 6,y,2,4,1,langtext("left"),name,3,2,buttonid)
				createcontrolicon("left",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("left2",x - tilesize * 1,y,2,4,1,langtext("left") .. " 2",name,3,2,buttonid)
				createcontrolicon("left2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("down",x - tilesize * 6,y,2,4,1,langtext("down"),name,3,2,buttonid)
				createcontrolicon("down",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("down2",x - tilesize * 1,y,2,4,1,langtext("down") .. " 2",name,3,2,buttonid)
				createcontrolicon("down2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize * 1.2
				
				createbutton("idle",x - tilesize * 6,y,2,4,1,langtext("idle"),name,3,2,buttonid)
				createcontrolicon("idle",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("idle2",x - tilesize * 1,y,2,4,1,langtext("idle") .. " 2",name,3,2,buttonid)
				createcontrolicon("idle2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("undo",x - tilesize * 6,y,2,4,1,langtext("undo"),name,3,2,buttonid)
				createcontrolicon("undo",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("undo2",x - tilesize * 1,y,2,4,1,langtext("undo") .. " 2",name,3,2,buttonid)
				createcontrolicon("undo2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("restart",x - tilesize * 6,y,2,4,1,langtext("controls_restart"),name,3,2,buttonid)
				createcontrolicon("restart",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("restart2",x - tilesize * 1,y,2,4,1,langtext("controls_restart") .. " 2",name,3,2,buttonid)
				createcontrolicon("restart2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("confirm",x - tilesize * 6,y,2,4,1,langtext("confirm"),name,3,2,buttonid)
				createcontrolicon("confirm",false,x + tilesize * 2.5,y,buttonid)
				
				createbutton("confirm2",x - tilesize * 1,y,2,4,1,langtext("confirm") .. " 2",name,3,2,buttonid)
				createcontrolicon("confirm2",false,x + tilesize * 4.5,y,buttonid)
				
				y = y + tilesize
				
				createbutton("pause",x - tilesize * 3,y,2,8,1,langtext("pause"),name,3,2,buttonid)
				createcontrolicon("pause",false,x + tilesize * 3.5,y,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"right"},{"right2"}},
				{{"up"},{"up2"}},
				{{"left"},{"left2"}},
				{{"down"},{"down2"}},
				{{"move"},{"move2"}},
				{{"idle"},{"idle2"}},
				{{"undo"},{"undo2"}},
				{{"restart"},{"restart2"}},
				{{"confirm"},{"confirm2"}},
				{{"pause"},},
			},
		}
	},
	change_keyboard =
	{
		button = "Change",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				writetext(langtext("controls_pressany"),0,x,y,name,true,2,true)
			end,
	},
	change_gamepad =
	{
		button = "Change",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				writetext(langtext("controls_pressany"),0,x,y,name,true,2,true)
			end,
	},
	world =
	{
		button = "WorldChoice",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				writetext("select the world you want to edit:",0,x,y,name,true,1)
			end,
	},
	level =
	{
		enter = 
			function(parent,name)
				local x = screenw * 0.5
				local y = tilesize * 0.5
				writetext("select the level you want to edit:",0,x,y,name,true,2)
				
				y = y + tilesize * 2
				
				createbutton("newlevel",x,y,2,10,1,"create a new level",name,3,2,"LevelButton")
				
				createbutton("themes",x,y + tilesize,2,10,1,"edit themes",name,3,2,"LevelButton")
				
				createbutton("return",x,y + tilesize * 2,2,10,1,"return to world list",name,3,2,"LevelButton")
				
				--x = x + roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				
				--createbutton("deflevel",x,y,2,10,1,"set default level",name,3,2,"LevelButton")
				
				--createbutton("startlevel",x,y + tilesize,2,10,1,"set first level",name,3,2,"LevelButton")
				
				MF_visible("LevelButton",1)
				
				editor.values[STATE] = 0
			end,
		leave = 
			function(parent,name)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				MF_letterclear("nametext")
			end,
		submenu_leave =
			function(parent,name)
				MF_visible("LevelButton",0)
				MF_letterclear("nametext")
			end,
		submenu_return =
			function(parent,name)
				MF_visible("LevelButton",1)
			end,
	},
	name =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 1.5
				writetext("enter the name:",0,x,y,name,true)
			end,
		leave = 
			function(parent,name)
				MF_delete("LetterButton")
				MF_letterclear("nametext")
			end,
	},
	editor =
	{
		enter = 
			function(parent,name)
				local levelname = generaldata.strings[LEVELNAME]
				local level = generaldata.strings[CURRLEVEL]
				displaylevelname(levelname,level,nil,"editorname",nil,nil,true)
				
				local x = screenw - tilesize * 2
				local y = tilesize * 0.5
				
				createbutton("menu",x,y,2,4,1,"menu",name,3,2)
				
				x = x - tilesize * 4
				
				createbutton("objects",x,y,2,4,1,"objects",name,3,2)
				
				x = x - tilesize * 2.5
				
				createbutton("l3",x,y,2,1,1,"3",name,3,2)
				
				x = x - tilesize
				
				createbutton("l2",x,y,2,1,1,"2",name,3,2)
				
				x = x - tilesize
				
				createbutton("l1",x,y,2,1,1,"1",name,3,2)
				
				x = x - tilesize * 2
				
				createbutton("save",x,y,2,3,1,"save",name,3,2)
				
				x = tilesize * 2.5
				y = screenh - tilesize * 0.5
				
				createbutton("addlevel",x,y,2,5,1,"add level",name,3,2)
				
				x = x + tilesize * 5.5
				
				createbutton("selector",x,y,2,6,1,"set selector",name,3,2)
				
				x = x + tilesize * 5
				
				createbutton("addpath",x,y,2,4,1,"add path",name,3,2)
				
				x = x + tilesize * 4
				
				createbutton("setpath",x,y,2,4,1,"set path",name,3,2)
				
				editor.values[STATE] = 0
			end,
		leave = 
			function(parent,name)
				MF_delete("EditorButton")
			end,
		submenu_leave = 
			function(parent,name)
				MF_visible("EditorButton",0)
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("EditorButton",1)
			end,
	},
	editormenu =
	{
		enter = 
			function(parent,name)
				local x = screenw * 0.5
				local y = tilesize * 1.5
				
				y = y + tilesize * 1.5
				
				createbutton("closemenu",x,y,2,16,1,"close menu",name,3,2,"EditorMenuButton")
				
				y = y + tilesize
				
				createbutton("return",x,y,2,16,1,"return to level list",name,3,2,"EditorMenuButton")
				
				y = y + tilesize
				
				createbutton("rename",x,y,2,16,1,"rename level",name,3,2,"EditorMenuButton")
				
				y = y + tilesize
				
				createbutton("theme",x,y,2,16,1,"change level theme",name,3,2,"EditorMenuButton")
				
				y = y + tilesize
				
				createbutton("palette",x,y,2,16,1,"change level palette",name,3,2,"EditorMenuButton")
				
				y = y + tilesize
				
				createbutton("objectsetup",x,y,2,16,1,"object settings",name,3,2,"EditorMenuButton")
				
				y = y + tilesize
				
				createbutton("mapsetup",x,y,2,16,1,"map-related settings",name,3,2,"EditorMenuButton")
				
				y = y + tilesize * 2
				
				createbutton("delete",x,y,2,16,1,"delete level",name,3,2,"EditorMenuButton")
				
				y = y + tilesize * 2
				
				writetext("change level size:",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				createbutton("s148",x + tilesize * -12,y,2,3,1,"14x8",name,3,2,"EditorMenuButton")
				createbutton("s1710",x + tilesize * -9,y,2,3,1,"17x10",name,3,2,"EditorMenuButton")
				createbutton("s1616",x + tilesize * -6,y,2,3,1,"16x16",name,3,2,"EditorMenuButton")
				createbutton("s2616",x + tilesize * -3,y,2,3,1,"26x16",name,3,2,"EditorMenuButton")
				createbutton("s3018",x + tilesize * 0,y,2,3,1,"30x18",name,3,2,"EditorMenuButton")
				createbutton("s2020",x + tilesize * 3,y,2,3,1,"20x20",name,3,2,"EditorMenuButton")
				createbutton("s2620",x + tilesize * 6,y,2,3,1,"26x20",name,3,2,"EditorMenuButton")
				createbutton("s3520",x + tilesize * 9,y,2,3,1,"35x20",name,3,2,"EditorMenuButton")
				createbutton("s5230",x + tilesize * 12,y,2,3,1,"52x30",name,3,2,"EditorMenuButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("EditorMenuButton")
			end,
		submenu_leave =
			function(parent,name)
				MF_visible("EditorMenuButton",0)
			end,
		submenu_return =
			function(parent,name)
				MF_visible("EditorMenuButton",1)
				local x = tilesize * 0.5
				local y = tilesize * 0.5

				if (parent == "name") then
					MF_letterclear("editorname")
					writetext(generaldata.strings[LEVELNAME],0,x,y,"editorname",false,2)
					MF_letterhide("editorname",1)
					--writetext(editor.strings[5],renamebuttonid,0,0,name,true)
				end
			end,
	},
	palette =
	{
		enter =
			function(parent,name)
				local world = generaldata.strings[WORLD]
				local rootpals = MF_filelist("Data/Palettes/","*.png")
				local pals = MF_filelist("Data/Worlds/" .. world .. "/Palettes/","*.png")
				
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 2
				
				writetext("select the palette you want to use:",0,x,y,name,true)
				
				x = x * 0.5
				
				y = y + tilesize
				
				createbutton("return",x,y,2,8,1,"return",name,3,2,"PaletteButton")
				
				if (#rootpals > 0) then
					for i,pal in ipairs(rootpals) do
						y = y + tilesize
						createbutton(pal,x,y,2,8,1,string.sub(pal, 1, string.len(pal) - 4),name,3,2,"RootPaletteButton")
					end
				end
				
				if (#pals > 0) then
					for i,pal in ipairs(pals) do
						y = y + tilesize
						createbutton(pal,x,y,2,8,1,string.sub(pal, 1, string.len(pal) - 4),name,3,2,"PaletteButton")
					end
				end
			end,
		leave = 
			function(parent,name)
				MF_delete("PaletteButton")
				MF_delete("RootPaletteButton")
			end,
	},
	mapsetup =
	{
		enter =
			function(parent,name)			
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local leftx = tilesize * 2
				local y = tilesize * 2
				
				writetext("what is this level?",0,x,y,name,true)
				
				y = y + tilesize
				
				createbutton("islevel",roomsizex * tilesize * 0.25 * spritedata.values[TILEMULT],y,2,8,1,"level",name,3,2,"MapSetupButton")
				createbutton("ismap",roomsizex * tilesize * 0.75 * spritedata.values[TILEMULT],y,2,8,1,"map",name,3,2,"MapSetupButton")
				
				local leveltype = editor.values[LEVELTYPE] + 1
				makeselection({"islevel","ismap"},leveltype)
				
				y = y + tilesize
				
				writetext("levels needed for clear:",0,x,y,name,true)
				
				y = y + tilesize
				
				writetext("(zero -> unclearable)",0,x,y,name,true)
				
				y = y + tilesize
				
				createbutton("y--",x - tilesize * 2,y,2,1,1,"<<",name,3,2,"MapSetupButton")
				createbutton("y-",x - tilesize * 1,y,2,1,1,"<",name,3,2,"MapSetupButton")
				createbutton("y+",x + tilesize * 1,y,2,1,1,">",name,3,2,"MapSetupButton")
				createbutton("y++",x + tilesize * 2,y,2,1,1,">>",name,3,2,"MapSetupButton")
				
				local symbolid = MF_specialcreate("Editor_levelnum")
				local symbol = mmf.newObject(symbolid)
				symbol.values[TYPE] = editor.values[UNLOCKCOUNT]
				symbol.x = Xoffset + x
				symbol.y = Yoffset + y
				symbol.layer = 3
				
				y = y + tilesize * 2
				
				createbutton("seticons",x,y,2,16,1,"map icon setup",name,3,2,"MapSetupButton")
				
				y = y + tilesize * 2
				
				writetext("level to return to after beating:",0,x,y,name,true)
				
				y = y + tilesize
				
				createbutton("reset",x,y,2,16,1,"parent level",name,3,2,"MapSetupButton")
				
				local customparent,cparentname = 1,"select a level"
				if (editor2.strings[CUSTOMPARENT] ~= "") then
					customparent,cparentname = 2,editor2.strings[CUSTOMPARENTNAME]
				end
				makeselection({"reset"},customparent)
				
				y = y + tilesize
				
				createbutton("changelevel",x,y,2,16,1,cparentname,name,3,2,"MapSetupButton")
				
				y = y + tilesize * 2
				
				createbutton("return",x,y,2,8,1,"return",name,3,2,"MapSetupButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("MapSetupButton")
			end,
		submenu_leave =
			function(parent,name)
				MF_visible("MapSetupButton",0)
			end,
		submenu_return =
			function(parent,name)
				MF_visible("MapSetupButton",1)
			end,
	},
	addlevel =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local leftx = tilesize * 2
				local y = tilesize * 1.5
				writetext("which level this leads to:",0,x,y,name,true)
				
				y = y + tilesize
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)

				createbutton("changelevel",x,y,2,16,1,unit.strings[U_LEVELNAME],name,3,2,"AddLevel")
				
				y = y + tilesize * 3
				
				writetext("icon colour:",0,leftx,y,name,false)
				
				y = y + tilesize * 3
				
				writetext("initial state:",0,leftx - tilesize * 1.5,y,name,false)
				createbutton("s1",leftx + tilesize * 6,y,2,3.5,1,"hidden",name,3,2,"AddLevel")
				createbutton("s2",leftx + tilesize * 9.5,y,2,3.5,1,"normal",name,3,2,"AddLevel")
				createbutton("s3",leftx + tilesize * 13,y,2,3.5,1,"opened",name,3,2,"AddLevel")
				
				makeselection({"s1","s2","s3"},unit.values[COMPLETED] + 1)
				
				y = y + tilesize * 1
				
				writetext("symbol style:",0,leftx - tilesize * 1.5,y,name,false)
				createbutton("l1",leftx + tilesize * 5.5,y,2,2.5,1,"none",name,3,2,"AddLevel")
				createbutton("l2",leftx + tilesize * 8.6,y,2,3.5,1,"numbers",name,3,2,"AddLevel")
				createbutton("l3",leftx + tilesize * 11.6,y,2,2.5,1,"text",name,3,2,"AddLevel")
				createbutton("l4",leftx + tilesize * 14.1,y,2,2.5,1,"dots",name,3,2,"AddLevel")
				createbutton("l5",leftx + tilesize * 16.4,y,2,2,1,"...",name,3,2,"AddLevel")
				
				local lselect = unit.values[VISUALSTYLE]
				if (lselect == -2) then
					lselect = -1
				elseif (lselect == -1) then
					lselect = 3
				end
				
				makeselection({"l1","l2","l3","l4","l5"},lselect + 2)
				
				y = y + tilesize * 1
				
				writetext("symbol:",0,leftx - tilesize * 1.5,y,name,false)
				createbutton("y--",leftx + tilesize * 5,y,2,1,1,"<<",name,3,2,"AddLevel")
				createbutton("y-",leftx + tilesize * 6,y,2,1,1,"<",name,3,2,"AddLevel")
				createbutton("y+",leftx + tilesize * 9,y,2,1,1,">",name,3,2,"AddLevel")
				createbutton("y++",leftx + tilesize * 10,y,2,1,1,">>",name,3,2,"AddLevel")
				
				local symbolid = MF_specialcreate("Editor_levelnum")
				local symbol = mmf.newObject(symbolid)
				symbol.x = Xoffset + leftx + tilesize * 7.5
				symbol.y = Yoffset + y
				symbol.layer = 3
				
				y = y + tilesize * 1
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"AddLevel")
			end,
		submenu_leave = 
			function(parent,name)
				MF_visible("AddLevel",0)
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("AddLevel",1)
			end,
		leave = 
			function(parent,name)
				MF_delete("AddLevel")
			end,
	},
	levelselect =
	{
		leave = 
			function(parent,name)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				updatebuttontext("changelevel",unit.strings[U_LEVELNAME],parent)
			end,
	},
	maplevelselect =
	{
		leave = 
			function(parent,name)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				
				updatebuttontext("changelevel",editor2.strings[CUSTOMPARENTNAME],parent)
			end,
	},
	spriteselect =
	{
		leave = 
			function(parent,name)
				MF_delete("SpriteButton")
				MF_letterclear("leveltext")
			end,
	},
	iconselect =
	{
		submenu_leave = 
			function(parent,name)
				MF_visible("IconButton",0)
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("IconButton",1)
			end,
		enter =
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"IconButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("IconButton")
			end,
	},
	icons =
	{
		enter =
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"IconButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("IconButton")
			end,
	},
	deleteconfirm =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = roomsizey * tilesize * 0.5 * spritedata.values[TILEMULT] - tilesize * 3
				
				writetext("really remove this level?",0,x,y,name,true)
				
				y = y + tilesize * 2
				
				createbutton("yes",x,y,2,16,1,"yes",name,3,2,"DeleteConfirm")
				
				y = y + tilesize * 2
				
				createbutton("no",x,y,2,16,1,"no",name,3,2,"DeleteConfirm")
			end,
		leave = 
			function(parent,name)
				MF_delete("DeleteConfirm")
			end,
	},
	setpath =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 2.5
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"PathButton")
				
				y = y + tilesize * 1
				
				x = roomsizex * tilesize * 0.25 * spritedata.values[TILEMULT]
				
				createbutton("hidden",x,y,2,8,1,"hidden",name,3,2,"PathButton")
				
				x = roomsizex * tilesize * 0.75 * spritedata.values[TILEMULT]
				
				createbutton("visible",x,y,2,8,1,"visible",name,3,2,"PathButton")
				
				makeselection({"hidden","visible"},editor.values[PATHSTYLE] + 1)
				
				x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				y = y + tilesize * 1
				
				writetext("is this path locked?",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				x = roomsizex * tilesize * 0.2 * spritedata.values[TILEMULT]
				
				createbutton("s1",x,y,2,6,1,"nope",name,3,2,"PathButton")
				
				x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				
				createbutton("s2",x,y,2,6,1,"level clears",name,3,2,"PathButton")
				
				x = roomsizex * tilesize * 0.8 * spritedata.values[TILEMULT]
				
				createbutton("s3",x,y,2,6,1,"map clears",name,3,2,"PathButton")
				
				makeselection({"s1","s2","s3"},editor.values[PATHGATE] + 1)
				
				x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				y = y + tilesize * 1
				
				local symbolid = MF_specialcreate("Editor_levelnum")
				local symbol = mmf.newObject(symbolid)
				symbol.x = Xoffset + x
				symbol.y = Yoffset + y
				symbol.layer = 3
				
				createbutton("y--",x - tilesize * 2,y,2,1,1,"<<",name,3,2,"PathButton")
				createbutton("y-",x - tilesize * 1,y,2,1,1,"<",name,3,2,"PathButton")
				createbutton("y+",x + tilesize * 1,y,2,1,1,">",name,3,2,"PathButton")
				createbutton("y++",x + tilesize * 2,y,2,1,1,">>",name,3,2,"PathButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("PathButton")
			end,
	},
	objectsetup =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"ObjectButton")
				
				if (editor.values[OBJECTSETUPTYPE] == 0) then
					y = y + tilesize * 2
				elseif (editor.values[OBJECTSETUPTYPE] == 1) then
					y = y + tilesize
					createbutton("palette",x,y,2,16,1,"change palette",name,3,2,"ObjectButton")
					y = y + tilesize
				end
				
				writetext("select the object you wish to edit:",0,x,y,name,true)
			end,
		leave = 
			function(parent,name)
				MF_delete("ObjectButton")
				MF_delete("ChangedTile")
			end,
		submenu_leave = 
			function(parent,name)
				MF_visible("ObjectButton",0)
				
				if (name ~= "palette") then
					MF_delete("ChangedTile")
				else
					MF_visible("ChangedTile",0)
				end
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("ObjectButton",1)
				MF_visible("ChangedTile",1)
			end,
	},
	objectedit =
	{
		enter = 
			function(parent,name)
				local x = screenw * 0.5
				local y = tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"ObjectEditButton")
				
				y = y + tilesize * 2
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				
				local currname = unit.strings[UNITNAME]
				local realname = unit.className
				local unittype = unit.strings[UNITTYPE]
				
				writetext(currname .. " (" .. realname .. ") - " .. unittype,0,x,y,"objectinfo",true)
				
				x = screenw * 0.65
				y = y + tilesize * 1
				
				createbutton("sprite",x,y,2,12,1,"change sprite",name,3,2,"ObjectEditButton")
				
				y = y + tilesize * 1
				
				createbutton("name",x,y,2,12,1,"change name",name,3,2,"ObjectEditButton")
				
				y = y + tilesize * 1
				
				createbutton("type",x,y,2,12,1,"change type",name,3,2,"ObjectEditButton")
				
				y = y + tilesize * 1
				
				writetext("change colour:",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				createbutton("colour",x - tilesize * 3.5,y,2,7,1,"base colour",name,3,2,"ObjectEditButton")
				createbutton("acolour",x + tilesize * 3.5,y,2,7,1,"active colour",name,3,2,"ObjectEditButton")
				
				y = y + tilesize * 1
				
				writetext("animation style:",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				local w = 4.5
				
				local bw = w * tilesize
				local bh = tilesize
				
				local ox = x - bw
				
				createbutton("a1",ox,y,2,w,1,"none",name,3,2,"ObjectEditButton")
				createbutton("a2",ox + bw,y,2,w,1,"dirs",name,3,2,"ObjectEditButton")
				createbutton("a3",ox + bw * 2,y,2,w,1,"anim",name,3,2,"ObjectEditButton")
				createbutton("a4",ox,y + bh,2,w,1,"anim-dirs",name,3,2,"ObjectEditButton")
				createbutton("a5",ox + bw,y + bh,2,w,1,"character",name,3,2,"ObjectEditButton")
				createbutton("a6",ox + bw * 2,y + bh,2,w,1,"tiled",name,3,2,"ObjectEditButton")
				
				local aselect = unit.values[TILING]
				if (unit.values[TILING] == 4) then
					aselect = 1
				elseif (unit.values[TILING] == 3) then
					aselect = 2
				elseif (unit.values[TILING] == 2) then
					aselect = 3
				elseif (unit.values[TILING] == 1) then
					aselect = 4
				end
				
				makeselection({"a1","a2","a3","a4","a5","a6"},aselect + 2)
				
				y = y + tilesize * 2
				
				writetext("text type:",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				createbutton("w1",ox,y,2,w,1,"baba",name,3,2,"ObjectEditButton")
				createbutton("w2",ox + bw,y,2,w,1,"is",name,3,2,"ObjectEditButton")
				createbutton("w3",ox + bw * 2,y,2,w,1,"you",name,3,2,"ObjectEditButton")
				
				makeselection({"w1","w2","w3"},unit.values[TYPE] + 1)
				
				y = y + tilesize * 1
				
				writetext("manual text type selection:",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				createbutton("-",x - tilesize * 1,y,2,1,1,"<",name,3,2,"ObjectEditButton")
				createbutton("+",x + tilesize * 1,y,2,1,1,">",name,3,2,"ObjectEditButton")
				
				local symbolid = MF_specialcreate("Editor_levelnum")
				local symbol = mmf.newObject(symbolid)
				symbol.x = x
				symbol.y = y
				symbol.layer = 3
				symbol.values[1] = 0
				
				symbol.values[TYPE] = unit.values[TYPE]
				
				y = y + tilesize * 1
				
				writetext("z level:",0,x,y,name,true)
				
				y = y + tilesize * 1
				
				createbutton("l-",x - tilesize * 1,y,2,1,1,"<",name,3,2,"ObjectEditButton")
				createbutton("l+",x + tilesize * 1,y,2,1,1,">",name,3,2,"ObjectEditButton")
				
				local symbolid2 = MF_specialcreate("Editor_levelnum")
				local symbol2 = mmf.newObject(symbolid2)
				symbol2.x = x
				symbol2.y = y
				symbol2.layer = 3
				symbol2.values[1] = -1
				
				symbol2.values[TYPE] = unit.values[ZLAYER]
				
				y = y + tilesize * 1
				
				createbutton("reset",x,y,2,12,1,"reset all values",name,3,2,"ObjectEditButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("ObjectEditButton")
				MF_letterclear("objectinfo",0)
			end,
		submenu_leave = 
			function(parent,name)
				MF_visible("ObjectEditButton",0)
				MF_letterclear("objectinfo",0)
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("ObjectEditButton",1)
				
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 3.5
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				
				local currname = unit.strings[UNITNAME]
				local realname = unit.className
				local unittype = unit.strings[UNITTYPE]
				
				writetext(currname .. " (" .. realname .. ") - " .. unittype,0,x,y,"objectinfo",true)
			end,
	},
	themes =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 1.5
				writetext("select the theme you want to edit:",0,x,y,name,true,1)
				
				y = y + tilesize
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,"ThemeChoice")
			end,
		leave = 
			function(parent,name)
				MF_delete("ThemeChoice")
			end,
		submenu_leave =
			function(parent,name)
				MF_visible("ThemeChoice",0)
			end,
		submenu_return =
			function(parent,name)
				MF_visible("ThemeChoice",1)
			end,
	},
	themeselect =
	{
		enter = 
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 1.5
				writetext("select the theme you want to use:",0,x,y,name,true,2)

				y = y + tilesize
				
				createbutton("return",x,y,2,16,1,"return to level setup",name,3,2,"ThemeButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("ThemeButton")
				MF_delete("ThemeChoice")
				MF_letterclear("themes")
			end,
	},
	object_colour =
	{
		enter =
			function(parent,name)
				local x = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = tilesize * 2
				
				writetext("what colour should this object use?",0,x,y,name,true)
				
				y = y + tilesize
				
				createbutton("return",x,y,2,8,1,"return",name,3,2,"ColourButton")
				
				y = y + tilesize
			end,
		leave = 
			function(parent,name)
				MF_delete("ColourButton")
			end,
	},
	restartconfirm =
	{
		enter = 
			function(parent,name)
				local x = screenw * 0.5
				local y = screenh * 0.5 - tilesize * 3
				
				writetext(langtext("restart_confirm"),0,x,y,name,true,2,true)
				y = y + tilesize * 1
				writetext(langtext("restart_tip"),0,x,y,name,true,2,true,{1,4})
				
				y = y + tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,"RestartConfirm")
				
				y = y + tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,"RestartConfirm")
			end,
		leave = 
			function(parent,name)
				MF_delete("RestartConfirm")
			end,
	},
	customlevels =
	{
		button = "CustomLevels",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,"return",name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				writetext("select the world you want to play:",0,x,y,name,true,1)
				
				y = y + tilesize * 1
				
				local worlds = MF_dirlist("Data/Worlds/*")
				
				for i,v in ipairs(worlds) do
					local worldfolder = string.sub(v, 2, string.len(v) - 1)
					
					y = y + tilesize * 1
					
					MF_setfile("world","Data/Worlds/" .. worldfolder .. "/world_data.txt")
					
					local worldname = string.lower(MF_read("world","general","name"))
					createbutton(worldfolder,x,y,2,16,1,worldname,name,3,2,buttonid)
				end
			end,
	},
	slots =
	{
		button = "SlotMenu",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 5 * tilesize
				
				local world = "baba"
				
				writetext(langtext("slots_select") .. ":",0,x,y,name,true,2,true)

				y = y + tilesize * 2.5
				
				MF_setfile("save","0ba.ba")
				local prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
				local clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
				local bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
				local timer = tonumber(MF_read("save",world,"time")) or 0
				local win = tonumber(MF_read("save",world,"end")) or 0
				local done = tonumber(MF_read("save",world,"done")) or 0
				
				local minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
				local hours = tostring(math.floor(timer / 3600))
				
				local slotname = langtext("slot") .. " 1"
				
				if (prizes > 0) then
					slotname = ""
					
					if (win == 1) then
						slotname = slotname .. "{ "
					end
					
					if (done == 1) then
						slotname = slotname .. "} "
					end
					
					if (win == 1) or (done == 1) then
						slotname = slotname .. "  "
					end
					
					slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "@  " .. tostring(clears) .. "¤"
				end
				
				if (bonus > 0) then
					slotname = slotname .. "  (+" .. tostring(bonus) .. ")"
				end
				
				createbutton("s1",x,y,2,16,2,slotname,name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				MF_setfile("save","1ba.ba")
				prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
				clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
				bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
				timer = tonumber(MF_read("save",world,"time")) or 0
				win = tonumber(MF_read("save",world,"end")) or 0
				done = tonumber(MF_read("save",world,"done")) or 0
				
				minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
				hours = tostring(math.floor(timer / 3600))
				
				slotname = langtext("slot") .. " 2"
				
				if (prizes > 0) then
					slotname = ""
					
					if (win == 1) then
						slotname = slotname .. "{ "
					end
					
					if (done == 1) then
						slotname = slotname .. "} "
					end
					
					if (win == 1) or (done == 1) then
						slotname = slotname .. "  "
					end
					
					slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "@  " .. tostring(clears) .. "¤"
				end
				
				if (bonus > 0) then
					slotname = slotname .. "  (+" .. tostring(bonus) .. ")"
				end
				
				createbutton("s2",x,y,2,16,2,slotname,name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				MF_setfile("save","2ba.ba")
				prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
				clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
				bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
				timer = tonumber(MF_read("save",world,"time")) or 0
				win = tonumber(MF_read("save",world,"end")) or 0
				done = tonumber(MF_read("save",world,"done")) or 0
				
				minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
				hours = tostring(math.floor(timer / 3600))
				
				slotname = langtext("slot") .. " 3"
				
				if (prizes > 0) then
					slotname = ""
					
					if (win == 1) then
						slotname = slotname .. "{ "
					end
					
					if (done == 1) then
						slotname = slotname .. "} "
					end
					
					if (win == 1) or (done == 1) then
						slotname = slotname .. "  "
					end
					
					slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "@  " .. tostring(clears) .. "¤"
				end
				
				if (bonus > 0) then
					slotname = slotname .. "  (+" .. tostring(bonus) .. ")"
				end
				
				createbutton("s3",x,y,2,16,2,slotname,name,3,2,buttonid)
				
				MF_setfile("save","ba.ba")
				
				y = y + tilesize * 2.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				createbutton("erase",x,y,2,16,1,langtext("slots_erase"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"s1"},},
				{{"s2"},},
				{{"s3"},},
				{{"return"},},
				{{"erase"},},
			},
		}
	},
	slots_erase =
	{
		button = "SlotEraseMenu",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 5 * tilesize
				
				local world = "baba"
				
				writetext(langtext("erase_select") .. ":",0,x,y,name,true,2,true)

				y = y + tilesize * 2.5
				
				MF_setfile("save","0ba.ba")
				local prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
				local clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
				local bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
				local timer = tonumber(MF_read("save",world,"time")) or 0
				local win = tonumber(MF_read("save",world,"end")) or 0
				local done = tonumber(MF_read("save",world,"done")) or 0
				
				local minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
				local hours = tostring(math.floor(timer / 3600))
				
				local slotname = langtext("slot") .. " 1"
				
				if (prizes > 0) then
					slotname = ""
					
					if (win == 1) then
						slotname = slotname .. "{ "
					end
					
					if (done == 1) then
						slotname = slotname .. "} "
					end
					
					if (win == 1) or (done == 1) then
						slotname = slotname .. "  "
					end
					
					slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "@  " .. tostring(clears) .. "¤"
				end
				
				if (bonus > 0) then
					slotname = slotname .. "  (+" .. tostring(bonus) .. ")"
				end
				
				createbutton("0ba",x,y,2,16,2,slotname,name,2,2,buttonid)
				
				y = y + tilesize * 2
				
				MF_setfile("save","1ba.ba")
				prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
				clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
				bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
				timer = tonumber(MF_read("save",world,"time")) or 0
				win = tonumber(MF_read("save",world,"end")) or 0
				done = tonumber(MF_read("save",world,"done")) or 0
				
				minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
				hours = tostring(math.floor(timer / 3600))
				
				slotname = langtext("slot") .. " 2"
				
				if (prizes > 0) then
					slotname = ""
					
					if (win == 1) then
						slotname = slotname .. "{ "
					end
					
					if (done == 1) then
						slotname = slotname .. "} "
					end
					
					if (win == 1) or (done == 1) then
						slotname = slotname .. "  "
					end
					
					slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "@  " .. tostring(clears) .. "¤"
				end
				
				if (bonus > 0) then
					slotname = slotname .. "  (+" .. tostring(bonus) .. ")"
				end
				
				createbutton("1ba",x,y,2,16,2,slotname,name,2,2,buttonid)
				
				y = y + tilesize * 2
				
				MF_setfile("save","2ba.ba")
				prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
				clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
				bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
				timer = tonumber(MF_read("save",world,"time")) or 0
				win = tonumber(MF_read("save",world,"end")) or 0
				done = tonumber(MF_read("save",world,"done")) or 0
				
				minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
				hours = tostring(math.floor(timer / 3600))
				
				slotname = langtext("slot") .. " 3"
				
				if (prizes > 0) then
					slotname = ""
					
					if (win == 1) then
						slotname = slotname .. "{ "
					end
					
					if (done == 1) then
						slotname = slotname .. "} "
					end
					
					if (win == 1) or (done == 1) then
						slotname = slotname .. "  "
					end
					
					slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "@  " .. tostring(clears) .. "¤"
				end
				
				if (bonus > 0) then
					slotname = slotname .. "  (+" .. tostring(bonus) .. ")"
				end
				
				createbutton("2ba",x,y,2,16,2,slotname,name,2,2,buttonid)
				
				MF_setfile("save","ba.ba")
				
				y = y + tilesize * 2.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"0ba"},},
				{{"1ba"},},
				{{"2ba"},},
				{{"return"},},
			},
		}
	},
	eraseconfirm =
	{
		button = "EraseConfirm",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - tilesize * 3
				
				writetext(langtext("erase_confirm"),0,x,y,name,true,2,true)
				y = y + tilesize * 1
				writetext(langtext("erase_tip"),0,x,y,name,true,2,true,{1,4})
				
				y = y + tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"no"},},
				{{"yes"},},
			},
		}
	},
	watchintro =
	{
		button = "IntroConfirm",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - tilesize * 4
				
				writetext(langtext("intro_confirm"),0,x,y,name,true,2,true)
				
				y = y + tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				createbutton("cancel",x,y,2,16,1,langtext("cancel"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
				{{"cancel"},},
			},
		}
	},
	languages =
	{
		button = "LanguageMenu",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - tilesize * 4
				
				writetext(langtext("lang_setup") .. ":",0,x,y,name,true,2,true)
				
				local langs = MF_filelist("Data/Languages/","*.txt")
				
				y = y + tilesize * 2
				
				local selection = 0
				local options = {}
				
				for c,d in ipairs(langs) do
					MF_setfile("lang",d)
					
					local buttonname = string.sub(d, 1, string.len(d) - 4)
					local langname = MF_read("lang","general","name")
				
					createbutton(buttonname,x,y,2,16,1,langname,name,3,2,buttonid)
					
					if (generaldata.strings[LANG] == string.sub(buttonname, 6)) then
						selection = c
					end
					
					table.insert(options, buttonname)
					
					y = y + tilesize
				end
				
				makeselection(options,selection)
				
				MF_setfile("lang","lang_" .. generaldata.strings[LANG] .. ".txt")
				
				y = y + tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
				
				editor2.values[MENU_XDIM] = 1
				editor2.values[MENU_YDIM] = #langs + 1
			end,
	},
	lang_restart =
	{
		button = "LangConfirm",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - tilesize * 3
				
				writetext(langtext("lang_restart"),0,x,y,name,true,2,true)
				
				y = y + tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
}