function writetext(text_,owner,xoffset,yoffset,type,centered_,layer_,absolute_,colours_,credits_)
	local text = text_
	
	local letterw = 10
	local letterh = 16
	local length = string.len(text)
	
	local credits = credits_ or 0
	if (credits > 0) and (credits ~= 2) then
		letterw = 20
		letterh = 22
	elseif (credits == 2) then
		letterw = 24
		letterh = 22
	end
	
	local vislength = length
	for i=1,length do
		local letter = string.sub(text, i, i)
		
		if (letter == "$") then
			vislength = vislength - 4
		end
		
		if (letter == "#") then
			local sublength = 0
			local command = ""
			
			for j=i,length do
				local subletter = ""
				
				if (j < length) then
					subletter = string.sub(text, j+1, j+1)
				end
				
				if (subletter ~= " ") then
					sublength = sublength + 1
				end
				
				if (subletter == " ") or (j == length) then
					command = string.sub(text, i+1, j)
					local commandresult = langtext(command)
					
					vislength = vislength - ((string.len(command) + 1) - string.len(commandresult))
					
					text = string.gsub(text, "#" .. command, commandresult, 1)
					length = string.len(text)
					break
				end
			end
		end
	end
	
	local layer = 2
	if (owner == -1) or (owner == 0) then
		layer = 3
	end
	
	if (layer_ ~= nil) then
		layer = layer_
	end
	
	local centered = centered_ or false
	local absolute = absolute_ or true
	
	local x,y = 0,0
	local finalx,finaly = 0,0
	local vi = 0
	
	local offx,offy = Xoffset,Yoffset
	if absolute or ((owner ~= 0) and (owner ~= -1)) then
		offx,offy = 0,0
	end
	
	local c1,c2 = getuicolour("default")
	
	if (colours_ ~= nil) then
		c1 = colours_[1]
		c2 = colours_[2]
	end
	local offset = 0
	
	local letters = {}
	
	for i=1,length do
		local j = i + offset
		local letter = string.sub(text, j, j)
		
		if (letter ~= "$") then
			x = x + letterw
			vi = vi + 1
		else
			local cdata = string.sub(text, j+1, j+3)
			
			c1 = tonumber(string.sub(cdata, 1, 1))
			c2 = tonumber(string.sub(cdata, 3, 3))
			
			offset = offset + 3
		end
		
		if (centered == false) then
			finalx = x
			finaly = y
		else
			finalx = (0 - (vislength * 0.5) + vi) * letterw
		end
		
		if (letter ~= " ") and (letter ~= "$") then
			local tid = 0
			if (credits == 0) then
				tid = MF_letter(letter,owner,type,offx+xoffset+finalx-4,offy+yoffset+finaly,layer)
			else
				tid = MF_creditsletter(letter,offx+xoffset+finalx-4,offy+yoffset+finaly,layer,credits,vi)
			end
			
			if (c1 ~= 0) or (c2 ~= 3) and (tid ~= 0) then
				MF_setcolour(tid, c1, c2)
			end
			
			table.insert(letters, {tid, vi})
		end
		
		j = i + offset
		if (j >= length) then
			break
		end
	end
	
	-- mmf.newObject näemmä kerää garbagea jota ei saa helposti pois, mikä aiheuttaa muistivuotoa
	
	--[[
	if centered and ((owner == 0) or (owner == -1)) then
		for i,data in pairs(letters) do
			local unitid = data[1]
			local finalxadd = data[2]
			
			local unit = mmf.newObject(unitid)
			
			print(gcinfo())
			
			finalx = (0 - (vi * 0.5) + finalxadd) * letterw
			
			unit.values[XPOS] = xoffset + finalx - 4
			unit.values[YPOS] = yoffset + finaly
			unit.x = Xoffset + unit.values[XPOS]
			unit.y = Yoffset + unit.values[YPOS]
		end
	end
	]]--
end

function erase(text)
	local result = string.sub(text, 1, string.len(text) - 1)
	
	return result
end

function createbutton(func,x,y,layer,xscale,yscale,text,menu,c1_,c2_,id_,disabled_,selected_)
	local buttonid = MF_create("Editor_editorbutton")
	local button = mmf.newObject(buttonid)
	button.x = x
	button.y = y
	button.values[ONLINE] = 1
	button.values[YORIGIN] = y
	button.layer = layer
	button.scaleX = xscale - (8 / tilesize)
	button.scaleY = yscale - (8 / tilesize)
	button.strings[BUTTONFUNC] = func
	writetext(text,buttonid,0,0,menu,true)
	
	local c = colours["editorui"]
	local c1 = c1_ or c[1]
	local c2 = c2_ or c[2]
	
	local colour = tostring(c1) .. "," .. tostring(c2)
	button.strings[UI_CUSTOMCOLOUR] = colour
	
	button.values[BUTTON_SELECTED] = selected_ or 0
	
	if (button.values[BUTTON_SELECTED] == 1) then
		c = colours["toggle_on"]
		c1 = c[1]
		c2 = c[2]
	end
	
	MF_setcolour(buttonid, c1, c2)
	
	button.values[XPOS] = x
	button.values[YPOS] = y
	
	local disabled = 0
	if (disabled_ ~= nil) then
		if disabled_ then
			disabled = 1
		end
	end
	
	local id = "EditorButton"
	
	if (id_ ~= nil) then
		id = id_
	end
	
	button.strings[BUTTONID] = id
	button.values[BUTTON_DISABLED] = disabled
	
	local bits = {{"ul", -1, -1},{"u", 0, -1},{"ur", 1, -1},{"l", -1, 0},{"r", 1, 0},{"dl", -1, 1},{"d", 0, 1},{"dr", 1, 1},{"s", -1, 0}}
	
	for i,v in ipairs(bits) do
		local bdir = v[1]
		local bxoffset = v[2]
		local byoffset = v[3]
		
		local bid = MF_specialcreate("Editor_button_" .. bdir .. "_edge")
		local b = mmf.newObject(bid)
		
		b.strings[BUTTONFUNC] = func
		b.values[ONLINE] = buttonid
		b.layer = layer
		b.values[XPOS] = bxoffset
		b.values[YPOS] = byoffset
		b.values[XVEL] = xscale
		b.values[YVEL] = yscale
		b.values[YORIGIN] = y
		b.strings[BUTTONID] = id
		b.values[BUTTON_DISABLED] = disabled
		
		if (bdir == "u") or (bdir == "d") then
			b.scaleX = xscale - (8 / tilesize)
		elseif (bdir == "l") or (bdir == "r") then
			b.scaleY = yscale - (8 / tilesize)
		end
	end
	
	return buttonid
end

function updatebuttontext(func,text,menu)
	local buttons = MF_getbutton(func)
	
	if (#buttons > 0) then
		for i,v in ipairs(buttons) do
			MF_buttonletterclear(v)
			
			writetext(text,v,0,0,menu,true)
		end
	end
end

function updatebuttoncolour(unitid,value)
	local s,c = gettoggle(value)
	local unit = mmf.newObject(unitid)
	unit.values[BUTTON_SELECTED] = s
	
	MF_setcolour(unitid, c[1],c[2])
end

function slider(func,x,y,width,colour,colour2,id,minimum,maximum,current)
	local barid = MF_create("Editor_slider")
	local knobid = MF_create("Editor_sliderknob")
	local bar = mmf.newObject(barid)
	local knob = mmf.newObject(knobid)
	
	MF_setcolour(barid,colour[1],colour[2])
	MF_setcolour(knobid,colour2[1],colour2[2])
	
	bar.scaleX = width
	bar.x = x
	bar.y = y
	bar.layer = 2
	bar.values[ONLINE] = 1
	bar.values[YORIGIN] = y
	bar.strings[BUTTONFUNC] = func
	bar.strings[BUTTONID] = id
	
	bar.values[SLIDER_MIN] = minimum
	bar.values[SLIDER_CURR] = current
	bar.values[SLIDER_MAX] = maximum
	
	knob.layer = 2
	knob.values[ONLINE] = 1
	knob.values[YORIGIN] = y
	knob.values[SLIDERKNOB_OWNER] = barid
	knob.strings[BUTTONFUNC] = func
	knob.strings[BUTTONID] = id
	
	bar.strings[UI_CUSTOMCOLOUR] = tostring(colour[1]) .. "," .. tostring(colour[2])
	knob.strings[UI_CUSTOMCOLOUR] = tostring(colour2[1]) .. "," .. tostring(colour2[2])
end

function displaylevelname(name_,level,layer_,group_,x_,y_,absolute_)
	local xoffset = x_ or tilesize * 0.5
	local yoffset = y_ or tilesize * 0.5
	local centered = false
	local absolute = absolute_ or false
	
	local name = name_
	
	if (x_ ~= nil) then
		centered = true
	end
	
	local layer = 2
	if (layer_ ~= nil) then
		layer = layer_
	end
	
	local group = "editorname"
	if (group_ ~= nil) then
		group = group_
	end
	
	if (generaldata.strings[WORLD] == "baba") and (generaldata.strings[LANG] ~= "en") then
		local langlevelname = MF_read("lang","texts",level)
		
		if (string.len(langlevelname) > 0) then
			name = langlevelname
		end
	end

	MF_letterclear(group)
	writetext(name,-1,xoffset,yoffset,group,centered,layer,absolute)
end

function submenu(menuitem)
	local currmenu = menu[1]
	table.insert(menu, 1, menuitem)
	MF_letterhide(currmenu,0)
	editor.strings[MENU] = menu[1]
	
	if (menufuncs[currmenu] ~= nil) then
		local func = menufuncs[currmenu]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_visible(buttonid,0)
		end
		
		if (func.submenu_leave ~= nil) then
			func.submenu_leave(currmenu,menuitem,buttonid)
		end
	end
	
	generaldata2.values[INMENU] = 0
	
	if (menufuncs[menuitem] ~= nil) then
		local func = menufuncs[menuitem]
		local buttonid = func.button or nil
		
		if (func.enter ~= nil) then
			func.enter(currmenu,menuitem,buttonid)
		end
		
		if (func.structure ~= nil) then
			generaldata2.values[INMENU] = 1
		end
	end
	
	editor.values[SCROLLAMOUNT] = 0
end

function changemenu(menuitem)
	local currmenu = menu[1]
	MF_letterclear(currmenu,0)
	menu[1] = menuitem
	editor.strings[MENU] = menu[1]
	
	if (menufuncs[currmenu] ~= nil) then
		local func = menufuncs[currmenu]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_delete(buttonid)
		end
		
		if (func.leave ~= nil) then
			func.leave(menu[2],currmenu,buttonid)
		end
	end
	
	generaldata2.values[INMENU] = 0
	
	if (menufuncs[menuitem] ~= nil) then
		local func = menufuncs[menuitem]
		local buttonid = func.button or nil
		
		if (func.enter ~= nil) then
			func.enter(currmenu,menuitem,buttonid)
		end
		
		if (func.structure ~= nil) then
			generaldata2.values[INMENU] = 1
		end
	end
	
	editor.values[SCROLLAMOUNT] = 0
end

function closemenu()
	local currmenu = menu[1]
	local deleted = menu[1]
	MF_letterclear(currmenu)
	table.remove(menu, 1)
	currmenu = menu[1]
	MF_letterhide(currmenu,1)
	editor.strings[MENU] = menu[1]
	
	if (menufuncs[deleted] ~= nil) then
		local func = menufuncs[deleted]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_delete(buttonid)
		end
		
		if (func.leave ~= nil) then
			func.leave(currmenu,deleted,buttonid)
		end
	end
	
	generaldata2.values[INMENU] = 0
	
	if (menufuncs[currmenu] ~= nil) then
		local func = menufuncs[currmenu]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_visible(buttonid,1)
		end
		
		--MF_alert(currmenu .. ", " .. tostring(buttonid))
		
		if (func.submenu_return ~= nil) then
			func.submenu_return(deleted,currmenu,buttonid)
		end
		
		if (func.structure ~= nil) then
			generaldata2.values[INMENU] = 1
		end
	end
	
	editor.values[SCROLLAMOUNT] = 0
end

function scrollarea(list)
	local miny = 0
	local maxy = 0
	
	local scroll = 0
	
	if (#list > 0) then
		for i,unitid in ipairs(list) do
			local unit = mmf.newObject(unitid)
			
			if (unit.yTop < miny) or (miny == 0) then
				miny = unit.yTop
			end
			
			if (unit.yBottom > maxy) or (maxy == 0) then
				maxy = unit.yBottom
			end
		end
	else
		print("No list")
	end
	
	scroll = maxy - miny
	
	editor.values[SCROLLAREA] = scroll
end

function gettoggle(value_)
	local value = tonumber(value_)
	if (value == 1) then
		return 1,colours["toggle_on"]
	else
		return 0,colours["editorui"]
	end
end

function makeselection(options,choice)
	for i,option in ipairs(options) do
		local buttons = MF_getbutton(option)
		
		local selected = 0
		if (i == choice) then
			selected = 1
		end
		
		local s,c = gettoggle(selected)
		
		if (#buttons > 0) then
			for a,b in ipairs(buttons) do
				local unit = mmf.newObject(b)
				unit.values[BUTTON_SELECTED] = selected
				
				if unit.visible then
					MF_setcolour(b, c[1], c[2])
				end
			end
		end
	end
end

function creditstext(text_,id)
	local x = screenw * 0.5
	local y = screenh + tilesize * 2 + id * 48
	
	local text = string.lower(text_)
	
	writetext(text,0,x,y,"credits",true,3,nil,nil,1)
end

function clearletters(group)
	MF_letterclear(group)
end

function createcontrolicon(name,gamepad,x,y,iid,update_,layer_,tiledata)
	local iconid = 0
	local create = true
	
	if (update_ ~= nil) then
		iconid = update_
		create = false
	end
	
	if create then
		iconid = MF_specialcreate("ControlIcon")
	end
	
	local icon = mmf.newObject(iconid)
	
	if create then
		icon.x = x
		icon.y = y
	end
	
	local group = "keyboard"
	local bindgroup = "raw"
	
	if gamepad then
		group = "gamepad"
		
		if MF_profilefound() then
			bindgroup = "named"
		end
	end
	
	--MF_alert(tostring(group) .. ", " .. tostring(name))
	
	local buttonstring = MF_read("settings",group,name)
	local buttonid = -1
	local buttonname = ""
	local anim = 5
	local dir = 31
	local frame = 0
	
	if (buttonstring ~= "") then
		if gamepad then
			if (string.sub(buttonstring, 1, 1) ~= "a") and (buttonstring ~= "dpad") then
				buttonid = tonumber(buttonstring)
			end
		end
	else
		buttonstring = nil
		buttonid = nil
	end
	
	if gamepad then
		anim = 0
	end
	
	if (group == "gamepad") and (buttonstring ~= nil) then
		local thesebinds = binds[bindgroup]
		
		if (buttonstring ~= "dpad") then
			if (bindgroup == "named") then
				if (buttonid > -1) then
					local bindname = MF_gamepadprofilename(buttonid)
					local thisbind = thesebinds[bindname] or {0, 2, 31}
					
					buttonname = bindname
					anim = thisbind[2]
					dir = thisbind[3]
				else
					buttonid = MF_gamepadbuttonid(buttonstring .. "+")
					
					local bindname = MF_gamepadprofilename(buttonid)
					local thisbind = thesebinds[bindname] or {0, 2, 31}
					
					buttonname = bindname
					anim = thisbind[2]
					dir = thisbind[3]
				end
			else
				for i,v in pairs(thesebinds) do
					if (buttonid > -1) then
						if (v[1] == buttonid + 1) then
							buttonname = i
							anim = v[2]
							dir = v[3]
						end
					elseif (i == buttonstring) then
						buttonname = buttonstring
						anim = v[2]
						dir = v[3]
					end
				end
			end
		else
			buttonname = buttonstring
			anim = 2
			dir = 13
		end
	elseif (group == "keyboard") and (buttonstring ~= nil) then
		bindgroup = "keyboard"
		buttonid = tonumber(buttonstring)
		
		if (buttonid ~= 8) then
			buttonstring = MF_keyid(buttonid)
		else
			buttonstring = "backspace"
		end
		
		local thesebinds = binds[bindgroup]
		
		for i,v in pairs(thesebinds) do
			if (string.lower(v) == string.lower(buttonstring)) then
				buttonname = tostring(i)
				frame = i
			end
		end
	end
	
	if (tiledata ~= nil) then
		icon.values[MISC_A] = tiledata[1]
		icon.values[MISC_B] = tiledata[2]
		icon.values[7] = 1
	end
	
	icon.animSet = anim
	icon.direction = dir
	icon.strings[BUTTONFUNC] = buttonname
	icon.strings[BUTTONID] = iid
	icon.strings[BUTTONNAME] = name
	icon.values[NOTABSOLUTE] = 1
	icon.layer = layer_ or 2
	
	if (group == "keyboard") then
		icon.animFrame = frame
	end
	
	if gamepad then
		--icon.values[1] = buttonid
	end
	
	return iconid
end

function updatecontrolicons(gamepad)
	local allbuttons = MF_getbuttongroup("KeyConfigButton")
	local icons = {}
	
	for i,v in ipairs(allbuttons) do
		local unit = mmf.newObject(v)
		
		if (unit.className == "ControlIcon") then
			table.insert(icons, unit)
		end
	end
	
	for i,unit in ipairs(icons) do
		createcontrolicon(unit.strings[BUTTONNAME],gamepad,nil,nil,unit.strings[BUTTONID],unit.fixed)
	end
end

function getcontrolname(type,id)
	local controlnames =
	{
		{"right","up","left","down","right2","up2","left2","down2","idle","undo","restart","confirm","pause","idle2","undo2","restart2","confirm2"},
		{"move","move2","idle","undo","restart","confirm","pause","idle2","undo2","restart2","confirm2"},
	}
	
	local result = controlnames[type + 1][id + 1]
	
	return result
end

function getcontrolid(type,id)
	local controlnames =
	{
		{"right","up","left","down","right2","up2","left2","down2","idle","undo","restart","confirm","pause","idle2","undo2","restart2","confirm2"},
		{"move","move2","idle","undo","restart","confirm","pause","idle2","undo2","restart2","confirm2"},
	}
	
	local group = 1
	local result = -1
	
	if (type == "gamepad") then
		group = 2
	end
	
	for i,v in ipairs(controlnames[group]) do
		if (v == id) then
			result = i
		end
	end
	
	return group - 1,result - 1
end

function geticon(mode,rawname_,name_)
	local name = name_
	local rawname = rawname_
	
	if (string.sub(rawname_, 1, 1) == "a") and (string.len(rawname_) == 3) then
		rawname = string.sub(rawname_, 1, 2)
		name = MF_getprofileID(rawname .. "+")
	end
	
	local result = -1
	
	if (mode == 0) then
		result = binds["raw"][rawname][1]
	elseif (mode == 1) then
		result = binds["named"][name][1] or binds["raw"][rawname][1]
	end
	
	if (result ~= nil) then
		return result,name
	else
		return -1,name
	end
end

function undotooltip(state)
	if (state == 1) then
		local x = screenw * 0.5
		local y = tilesize * 0.8
		
		local gamepad = MF_profilefound()
		local gamepad_ = false
		if (gamepad ~= nil) then
			gamepad_ = true
		end
		
		x = screenw * 0.5 - tilesize * 3
		
		createcontrolicon("undo",gamepad_,x,y,"UndoTooltip")
		particles("glow",(x - Xoffset) / tilesize,(y - Yoffset) / tilesize,10,{0,3},2,0)
		
		local unitid1 = MF_specialcreate("customsprite")
		local unit1 = mmf.newObject(unitid1)
		particles("glow",((x + tilesize * 1.6) - Xoffset) / tilesize,(y - Yoffset) / tilesize,10,{0,3},2,0)
		
		unit1.values[ONLINE] = 1
		unit1.values[XPOS] = x + tilesize * 1.6
		unit1.values[YPOS] = y
		unit1.strings[OBJECTID] = "UndoTooltip"
		unit1.layer = 2
		unit1.direction = 0
		MF_loadsprite(unitid1,"button_undo_0",0,false)
		
		x = screenw * 0.5 + tilesize * 1.5
		
		createcontrolicon("restart",gamepad_,x,y,"UndoTooltip")
		particles("glow",(x - Xoffset) / tilesize,(y - Yoffset) / tilesize,10,{0,3},2,0)
		
		local unitid2 = MF_specialcreate("customsprite")
		local unit2 = mmf.newObject(unitid2)
		particles("glow",((x + tilesize * 1.6) - Xoffset) / tilesize,(y - Yoffset) / tilesize,10,{0,3},2,0)
		
		unit2.values[ONLINE] = 1
		unit2.values[XPOS] = x + tilesize * 1.6
		unit2.values[YPOS] = y
		unit2.strings[OBJECTID] = "UndoTooltip"
		unit2.layer = 2
		unit2.direction = 1
		MF_loadsprite(unitid2,"button_restart_0",1,false)
	else
		local tooltips = MF_findspecial("UndoTooltip")
		
		for i,v in ipairs(tooltips) do
			local unit = mmf.newObject(v)
			particles("glow",((unit.x + tilesize * 0.2) - Xoffset) / tilesize,((unit.y + tilesize * 0.2) - Yoffset) / tilesize,10,{0,3},2,0)
			MF_cleanspecialremove(v)
		end
	end
end

function menu_position(menu,x,y,build)
	local thismenu = menufuncs[menu]
	local structurelist = thismenu.structure
	
	local structure = structurelist[build] or structurelist[1]
	
	local row = structure[y + 1]
	local target = {""}
	
	local xdim,ydim = 0,0
	local ox,oy = 0,0
	
	if (row ~= nil) then
		xdim = #row
		ydim = #structure
		
		if (row[x + 1] ~= nil) then
			target = row[x + 1]
			ox = target[2] or 0
			oy = target[3] or 0
		else
			print("column " .. tostring(x) .. " doesn't exist on row " .. tostring(y) .. " in menu " .. menu)
		end
	else
		print("Row " .. tostring(y) .. " doesn't exist in menu " .. menu)
	end
	
	return target[1],xdim,ydim,ox,oy
end

function langtext(id)
	local result = MF_read("lang","texts",id)
	
	if (result == "") then
		MF_alert(id .. " gave an empty langtext string!")
		result = "not found"
	elseif (result == "$s") then
		result = id
	end
	
	result = string.lower(result)
	
	return result
end

function introlangtext()
	local text1 = langtext("intro_mp2")
	local text2 = langtext("intro_mmf2")
	
	local x = screenw * 0.5
	local y = screenh * 0.5
	
	local type = "IntroText"
	
	writetext(text1,0,x,y + tilesize * 3.2,type,true,1)
	writetext(text2,0,x,y * 2 - tilesize * 0.8,type,true,1)
end