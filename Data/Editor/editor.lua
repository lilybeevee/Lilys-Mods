function loadtileset()
	for i,tile in pairs(tileslist) do
		local tiledata = tile.tile
		local vtiledata = tile.grid
		local colour = tile.colour
		
		if (tile.active ~= nil) then
			colour = tile.active
		end
		
		local x = tiledata[1]
		local y = tiledata[2]
		
		local vx,vy = x,y
		
		if (vtiledata ~= nil) then
			vx = vtiledata[1]
			vy = vtiledata[2]
		end
		
		local unitid = MF_create(i)
		local backid = MF_create("Editor_background")
		local unit = mmf.newObject(unitid)
		local back = mmf.newObject(backid)
		
		back.flags[NOSCROLL] = true
		
		unit.values[XPOS] = vx
		unit.values[YPOS] = vy
		
		unit.values[GRID_X] = x
		unit.values[GRID_Y] = y
		
		getmetadata(unit)
		
		unit.x = vx * tilesize + tilesize * 0.5
		unit.y = 0 - tilesize
		
		local tileid = tostring(x) .. "," .. tostring(y)
		
		unit.strings[GRID_TILE] = tileid
		
		unit.values[ONLINE] = 2
		unit.visible = false
		unit.layer = 2
		
		MF_setcolour(unitid, colour[1], colour[2])
	end
end

function editor_setunitmap()
	unitmap = {}
	unittypeshere = {}
	units = {}
end

function placetile(name_,x,y,z,dir_,loading_)
	local id = x + y * roomsizex
	
	local name = "error"
	
	local special = 0
	
	if (tileslist[name_] ~= nil) and (name_ ~= "level") then
		name = name_
	elseif (name_ == "level") then
		name = name_
		special = 1
	elseif (name_ == "path") then
		name = name_
		special = 2
	elseif (name_ == "specialobject") then
		name = name_
		special = 3
	else
		print("Error! Couldn't find object called " .. name_)
	end

	local dir = 3
	if (dir_ ~= nil) then
		dir = dir_
	end
	
	local loading = false
	
	if (loading_ ~= nil) then
		loading = loading_
	end

	local tile = tileslist[name]
	local unitid = MF_create(name)
	local unit = mmf.newObject(unitid)
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[LAYER] = z
	
	if (special == 0) then
		unit.values[DIR] = dir
	end
	
	unit.x = Xoffset + x * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	unit.y = Yoffset + y * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	unit.direction = unit.values[DIR] * 8
	
	unit.scaleX = 0.5 * spritedata.values[SPRITEMULT] * spritedata.values[TILEMULT]
	unit.scaleY = 0.5 * spritedata.values[SPRITEMULT] * spritedata.values[TILEMULT]
	
	unit.values[ONLINE] = 3
	
	if (unitmap[id] == nil) then
		unitmap[id] = {}
	end
	
	if (unittypeshere[id] == nil) then
		unittypeshere[id] = {}
	end
	
	table.insert(unitmap[id], unitid)
	
	local unitcount = #units + 1
	
	units[unitcount] = {}
	units[unitcount] = mmf.newObject(unitid)
	
	getmetadata(unit)
	
	if (changes[name] ~= nil) then
		dochanges(unitid)
	end
	
	local uth = unittypeshere[id]
	local n = unit.strings[UNITNAME]
	if (uth[n] == nil) then
		uth[n] = 0
	end
	
	uth[n] = uth[n] + 1
	
	dynamic(unitid)
	
	if (special == 0) and (tileslist[name] ~= nil) then
		updateunitcolour(unitid,true)

		if (loading == false) then
			local layer = map[z]
			local tilepos = tile.tile
			layer:set(x,y,tilepos[1],tilepos[2])
			MF_sublayer(0,x,y,editor.values[EDITORDIR])
		end
	end
	
	if (special == 1) then
		editor.values[EDITTARGET] = unitid
		unit.strings[U_LEVELFILE] = generaldata.strings[LEVELFILE]
		unit.strings[U_LEVELNAME] = generaldata.strings[LEVELNAME]
		
		local c = colours.level
		local c1,c2 = c[1],c[2]
		MF_setcolour(unitid, c1, c2)
		unit.strings[COLOUR] = tostring(c1) .. "," .. tostring(c2)
		submenu("addlevel")
	elseif (special == 2) then
		local c = colours.path
		local c1,c2 = c[1],c[2]
		MF_setcolour(unitid, c1, c2)
		
		unit.values[PATH_STYLE] = editor.values[PATHSTYLE]
		unit.values[PATH_GATE] = editor.values[PATHGATE]
		unit.values[PATH_REQUIREMENT] = editor.values[PATHREQUIREMENT]
		unit.strings[PATHOBJECT] = editor.strings[PATHOBJECT]
	elseif (special == 3) then
		--Tänne jotain?
	end
end

function copytile(data,unitid)
	local unit = mmf.newObject(unitid)
	local dunit = mmf.newObject(data)
	
	local name = unit.strings[UNITNAME]
	local realname = unit.className
	
	if (tileslist[realname] ~= nil) then
		local tiledata = tileslist[realname]
		local tile = tiledata.tile
		local grid = tiledata.grid
		
		if (grid ~= nil) then
			dunit.values[XPOS] = grid[1]
			dunit.values[YPOS] = grid[2]
		else
			dunit.values[XPOS] = tile[1]
			dunit.values[YPOS] = tile[2]
		end
		dunit.strings[NAME] = realname
		
		dunit.values[ACTUALX] = tile[1]
		dunit.values[ACTUALY] = tile[2]
	end
end

function removetile(unitid,x,y)
	local id = x + y * roomsizex
	
	local unit = mmf.newObject(unitid)
	
	if (unitmap[id] ~= nil) then
		for a,b in ipairs(unitmap[id]) do
			if (b == unitid) then
				table.remove(unitmap[id], a)
			end
		end
	end
	
	if (unittypeshere[id] ~= nil) then
		local uth = unittypeshere[id]
		local n = unit.strings[UNITNAME]
		
		if (uth[n] ~= nil) then
			uth[n] = uth[n] - 1
			
			if (uth[n] == 0) then
				uth[n] = nil
			end
		end
	end
	
	for i,unit in pairs(units) do
		if (unit.fixed == unitid) then
			table.remove(units, i)
		end
	end
	
	MF_cleanremove(unitid)
	
	dynamicat(x,y)
	
	if (x >= 0) and (y >= 0) and (x < roomsizex) and (y < roomsizey) then
		local l = editor.values[LAYER]
		local layer = map[l]
		layer:unset(x,y)
	end
end

function changetile(name,x,y,z,dir,unitid)
	local tiletoremove = mmf.newObject(unitid)
	
	if (tiletoremove.strings[UNITNAME] == "level") and (name == "level") then
		editor.values[EDITTARGET] = unitid
		submenu("addlevel")
		MF_leveldata(unitid)
	else
		removetile(unitid,x,y)
		placetile(name,x,y,z,dir)
	end
end

function buttonposition(unitid,id)
	local offset = tilesize * 3
	
	local unit = mmf.newObject(unitid)
	
	local rsize = roomsizex * tilesize
	local tsize = tilesize * 1.5
	
	rsize = math.floor(rsize / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = Xoffset + tilesize + x * tsize
	unit.y = Yoffset + offset + tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.scaleX = 1.5
	unit.scaleY = 1.5
	
	MF_setcolour(unitid, 1, 1)
end

function writename(name)
	local xoffset = screenw * 0.5
	local yoffset = tilesize * 2.5
	
	MF_letterclear("nametext")
	writetext(name,0,xoffset,yoffset,"nametext",true)
end

function levelname(name)
	local xoffset = screenw * 0.5
	local yoffset = tilesize * 1.5

	writetext(name,-1,xoffset,yoffset,"leveltext",true)
end

function createlist(id,name,folder,menuname,buttontype)
	local x = screenw * 0.5
	local y = tilesize * 5.5 + tilesize * id
	createbutton(folder,x,y,2,16,1,string.lower(name),menuname,3,2,buttontype)
end

function levellist(unitid,id)
	local offset = tilesize * 6
	local multiplier = 4
	
	local unit = mmf.newObject(unitid)
	
	local rsize_ = math.floor(screenw / tilesize) * tilesize
	local tsize = tilesize * multiplier
	
	local rsize = math.floor(rsize_ / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = rsize_ * 0.5 - rsize * 0.5 * tsize + x * tsize + tsize * 0.5
	unit.y = offset + tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.scaleX = multiplier / 4
	unit.scaleY = multiplier / 4
	
	MF_setcolour(unitid, 1, 1)
end

function spritelist(unitid,id)
	local offset = tilesize * 2
	local multiplier = 2
	
	local unit = mmf.newObject(unitid)
	
	local rsize = roomsizex * tilesize
	local tsize = tilesize * multiplier
	
	rsize = math.floor(rsize / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = Xoffset + tilesize * multiplier * 0.5 + x * tsize
	unit.y = Yoffset + offset + tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.scaleX = multiplier / 2
	unit.scaleY = multiplier / 2
	
	MF_setcolour(unitid, 1, 1)
end

function iconlist(unitid,id)
	local offset = tilesize * 2
	local multiplier = 2
	
	local unit = mmf.newObject(unitid)
	
	local rsize = roomsizex * tilesize
	local tsize = tilesize * multiplier
	
	rsize = math.floor(rsize / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = Xoffset + tilesize * multiplier * 0.5 + x * tsize
	unit.y = Yoffset + offset + tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	unit.strings[UNITTYPE] = "IconButton"
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.scaleX = multiplier / 2
	unit.scaleY = multiplier / 2
	
	MF_setcolour(unitid, 1, 1)
	
	local symbolid = MF_specialcreate("Editor_levelnum")
	local symbol = mmf.newObject(symbolid)
	
	symbol.x = unit.x
	symbol.y = unit.y
	symbol.layer = 3
	symbol.values[ONLINE] = 0-1-id
	symbol.values[LEVELNUMBER] = id
	symbol.values[LEVELSTYLE] = -1
	symbol.flags[SPECIAL] = true
end

function editordelete(id)
	delunit(id)
	MF_cleanremove(id)
end

function editor_moveall(dir)
	local drs = ndirs[dir+1]
	local ox,oy = drs[1],drs[2]
	
	for i,unit in ipairs(units) do
		local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
		local newx,newy = oldx + ox,oldy + oy
		
		if (newx <= 0) then
			newx = roomsizex - 2
		elseif (newx >= roomsizex - 1) then
			newx = 1
		end
		
		if (newy <= 0) then
			newy = roomsizey - 2
		elseif (newy >= roomsizey - 1) then
			newy = 1
		end
		
		unit.values[XPOS] = newx
		unit.values[YPOS] = newy
		
		unit.x = Xoffset + newx * tilesize + tilesize * 0.5
		unit.y = Yoffset + newy * tilesize + tilesize * 0.5
		
		updateunitmap(unit.fixed,oldx,oldy,newx,newy,unit.strings[UNITNAME])
	end
	
	for z=0,2 do
		local l = map[z]
		
		for i=1,roomsizex-2 do
			for j=1,roomsizey-2 do
				l:unset(i,j)
				MF_setsublayer(0,i,j,z,3)
				
				local id = i + j * roomsizex
				
				if (unitmap[id] ~= nil) then
					for a,b in ipairs(unitmap[id]) do
						local unit = mmf.newObject(b)
						local data = tileslist[unit.className]
						
						if (unit.values[LAYER] == z) and (unit.className ~= "level") and (unit.className ~= "path") and (unit.className ~= "specialobject") then
							local tiledata = data.tile
							
							l:set(i,j,tiledata[1],tiledata[2])
							
							MF_setsublayer(0,i,j,z,unit.values[DIR])
						end
					end
				end
			end
		end
	end
end

function editor_objectselectionhack(choice,id)
	if (id == "a") then
		local aselect = choice
		if (choice == 4) then
			aselect = 1
		elseif (choice == 3) then
			aselect = 2
		elseif (choice == 2) then
			aselect = 3
		elseif (choice == 1) then
			aselect = 4
		end
		
		makeselection({"a1","a2","a3","a4","a5","a6"},aselect + 2)
	elseif (id == "w") then
		makeselection({"w1","w2","w3"},choice + 1)
	end
end