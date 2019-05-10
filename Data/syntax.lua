function init(tilemapid,roomsizex_,roomsizey_,tilesize_,Xoffset_,Yoffset_,generaldataid,generaldataid2,spritedataid,screenw_,screenh_)
	map = TileMap.new(tilemapid)
	generaldata = mmf.newObject(generaldataid)
	generaldata2 = mmf.newObject(generaldataid2)
	spritedata = mmf.newObject(spritedataid)
	
	roomsizex = roomsizex_
	roomsizey = roomsizey_
	tilesize = tilesize_
	Xoffset = Xoffset_
	Yoffset = Yoffset_
	
	screenw = screenw_
	screenh = screenh_
	
	features = {}
	visualfeatures = {}
	featureindex = {}
	objectdata = {}
	units = {}
	tiledunits = {}
	codeunits = {}
	unitlists = {}
	objectlist = {}
	undobuffer = {}
	animunits = {}
	unitmap = {}
	unittypeshere = {}
	deleted = {}
	ruleids = {}
	updatelist = {}
	objectcolours = {}
	wordunits = {}
	paths = {}
	paradox = {}
	movelist = {}
	effecthistory = {}
	notfeatures = {}
	pushedunits = {}
	memory = {}
	memoryneeded = false
	
	generaldata.values[CURRID] = 0
	updatecode = 1
	doundo = true
	updateundo = true
	ruledebug = false
	maprotation = 0
	mapdir = 3
	levelconversions = {}

	unittags = {}
	autotimer = 0
	autoturn = false
	timelessturn = false
	doreset = false
	gravitydir = 3
	chosenany = {}
	onreset = {}
	resetcount = 0
	resetmoves = 0
	cuteparticles = {}
	timelessdels = {}
	isactive = {}
	timemap = {}
	
	HACK_MOVES = 0
	
	generatetiles()
end

function addunit(id,undoing_)
	local unitid = #units + 1
	
	units[unitid] = {}
	units[unitid] = mmf.newObject(id)
	
	local unit = units[unitid]
	
	getmetadata(unit)
	
	local truename = unit.className
	
	if (changes[truename] ~= nil) then
		dochanges(id)
	end
	
	if (unit.values[ID] == -1) then
		unit.values[ID] = newid()
	end

	if (unit.values[XPOS] > 0) and (unit.values[YPOS] > 0) then
		addunitmap(id,unit.values[XPOS],unit.values[YPOS],unit.strings[UNITNAME])
	end
	
	if (unit.values[TILING] == 1) then
		table.insert(tiledunits, unit.fixed)
	end
	
	if (unit.values[TILING] > 1) then
		table.insert(animunits, unit.fixed)
	end
	
	local name = getname(unit)
	local name_ = unit.strings[NAME]
	
	if (unitlists[name] == nil) then
		unitlists[name] = {}
	end
	
	table.insert(unitlists[name], unit.fixed)
	
	if (unit.strings[UNITTYPE] ~= "text") or ((unit.strings[UNITTYPE] == "text") and (unit.values[TYPE] == 0)) then
		objectlist[name_] = 1
	end
	
	if (unit.strings[UNITTYPE] == "text") then
		table.insert(codeunits, unit.fixed)
		updatecode = 1
		
		if (unit.values[TYPE] == 0) then
			local matname = string.sub(unit.strings[UNITNAME], 6)
			if (unitlists[matname] == nil) then
				unitlists[matname] = {}
			end
		end
	end
	
	if (unit.strings[UNITNAME] ~= "level") then
		setcolour(unit.fixed)
	end
	
	local undoing = undoing_ or false
	
	if (unit.className ~= "path") then
		statusblock({id},undoing)
		MF_animframe(id,math.random(0,2))
	end
	
	if (unit.strings[UNITNAME] == "text_back") then
		memoryneeded = true
	end
end

function clearunits()
	units = {}
	tiledunits = {}
	codeunits = {}
	animunits = {}
	unitlists = {}
	undobuffer = {}
	unitmap = {}
	unittypeshere = {}
	prevunitmap = {}
	ruleids = {}
	objectlist = {}
	updatelist = {}
	objectcolours = {}
	wordunits = {}
	paths = {}
	paradox = {}
	movelist = {}
	deleted = {}
	effecthistory = {}
	notfeatures = {}
	pushedunits = {}
	memory = {}
	memoryneeded = false
	
	generaldata.values[CURRID] = 0
	updateundo = true
	hiddenmap = nil
	levelconversions = {}

	unittags = {}
	chosenany = {}
	onreset = {}
	cuteparticles = {}
	timelessdels = {}
	isactive = {}
	timemap = {}
	
	HACK_MOVES = 0
	
	newundo()
	
	print("clearunits")
	
	restoredefaults()
end

function smallclear()
	objectdata = {}
	deleted = {}
	updatelist = {}
	movelist = {}
	pushedunits = {}
	levelconversions = {}
	
	HACK_MOVES = 0
end

function clear()
	features = {}
	featureindex = {}
	visualfeatures = {}
	objectdata = {}
	deleted = {}
	ruleids = {}
	updatelist = {}
	wordunits = {}
	paradox = {}
	movelist = {}
	effecthistory = {}
	notfeatures = {}
	pushedunits = {}
	memory = {}
	
	updatecode = 1
	updateundo = false
	hiddenmap = nil
	levelconversions = {}
	maprotation = 0
	mapdir = 3

	autotimer = 0
	autoturn = false
	timelessturn = false
	doreset = false
	gravitydir = 3
	chosenany = {}
	onreset = {}
	resetcount = 0
	resetmoves = 0
	cuteparticles = {}
	timelessdels = {}
	isactive = {}
	timemap = {}
	
	HACK_MOVES = 0
	
	print("clear")
	
	collectgarbage()
end

function command(key,player_)
	local keyid = -1
	if (keys[key] ~= nil) then
		keyid = keys[key]
	else
		print("no such key")
		return
	end
	
	local player = 1
	if (player_ ~= nil) then
		player = player_
	end
	
	if (keyid <= 4) then
		local drs = ndirs[keyid+1]
		local ox = drs[1]
		local oy = drs[2]
		local dir = keyid
		
		autoturn = false
		doingundo = false
		movecommand(ox,oy,dir,player)
		MF_update()
		if doreset then
			resetlevel()
			MF_update()
		else
			resetmoves = math.max(0, resetmoves - 1)
		end
	end
	
	if (keyid == 5) then
		MF_restart()
	end
	
	dolog(key)
end

function dolog(key)
	MF_log(key)
end

function createall(matdata,x_,y_,id_,dolevels_)
	local all = {}
	local empty = false
	local dolevels = dolevels_ or false
	
	if (x_ == nil) and (y_ == nil) and (id_ == nil) then
		if (matdata[1] ~= "empty") and (matdata[1] ~= "level") and (matdata[1] ~= "group") then
			all = findall(matdata)
		elseif (matdata[1] == "empty") then
			all = findempty()
			empty = true
		end
	end
	local test = {}
	
	if (x_ ~= nil) and (y_ ~= nil) and (id_ ~= nil) then
		local check = findtype(matdata,x_,y_,id_)
		
		if (#check > 0) then
			for i,v in ipairs(check) do
				if (v ~= 0) then
					table.insert(test, v)
				end
			end
		end
	end
	
	if (#all > 0) then
		for i,v in ipairs(all) do
			table.insert(test, v)
		end
	end

	local created = {}
	
	if (#test > 0) then
		for i,v in ipairs(test) do
			if (empty == false) then
				local vunit = mmf.newObject(v)
				local x,y,dir = vunit.values[XPOS],vunit.values[YPOS],vunit.values[DIR],vunit.values[MOVED]
				
				for b,unit in pairs(objectlist) do
					if (b ~= "empty") and (b ~= "all") and (b ~= "level") and (b ~= "group") and (b ~= matdata[1]) then
						local protect = hasfeature(matdata[1],"is","not " .. b,v,x,y)
						
						if (protect == nil) then
							local mat = findtype({b},x,y,v)
							local tmat = findtext(x,y)
							
							if (#mat == 0) then
								table.insert(created, create(b,x,y,dir))
								
								if (matdata[1] == "text") and (#tmat > 0) then
									for c,d in ipairs(tmat) do
										local tunit = mmf.newObject(d)
										
										if (tunit.strings[UNITNAME] == "text_" .. b) then
											delete(d)
										end
									end
								end
							end
						end
					end
				end
			else
				local x = v % roomsizex
				local y = math.floor(v / roomsizex)
				local dir = 4
				
				for b,mat in pairs(objectlist) do
					if (b ~= "empty") and (b ~= "all") and (b ~= "level") and (b ~= "group") then
						local protect = hasfeature(matdata[1],"is","not " .. b,2,x,y)
						
						if (protect == nil) then
							table.insert(created, create(b,x,y,dir))
						end
					end
				end
			end
		end

		return created
	end
	
	if (matdata[1] == "level") and dolevels then
		local levelmats = {}
		
		for b,unit in pairs(objectlist) do
			if (b ~= "empty") and (b ~= "all") and (b ~= "level") and (b ~= "group") and (b ~= matdata[1]) then
				local protect = hasfeature(matdata[1],"is","not " .. b,v,x,y)
				
				if (protect == nil) then
					table.insert(levelmats, {b, {}})
				end
			end
		end
		
		if (#levelmats > 0) then
			table.insert(levelconversions, levelmats)
			dolevelconversions()
		end
	end
end

function setunitmap()
	unitmap = {}
	unittypeshere = {}
	local delthese = {}
	
	local limit = 6
		
	if (generaldata.strings[WORLD] == "baba") and ((generaldata.strings[CURRLEVEL] == "89level") or (generaldata.strings[CURRLEVEL] == "33level")) then
		limit = 3
	end
	
	for i,unit in ipairs(units) do
		local tileid = unit.values[XPOS] + unit.values[YPOS] * roomsizex
		local valid = true
		
		--print(tostring(unit.values[XPOS]) .. ", " .. tostring(unit.values[YPOS]) .. ", " .. unit.strings[UNITNAME])
		
		if (unitmap[tileid] == nil) then
			unitmap[tileid] = {}
			unittypeshere[tileid] = {}
		end
		
		local uth = unittypeshere[tileid]
		local name = unit.strings[UNITNAME]
		
		if (uth[name] == nil) then
			uth[name] = 0
		end
		
		if (uth[name] < limit) then
			uth[name] = uth[name] + 1
		elseif (string.len(unit.strings[U_LEVELFILE]) == 0) then
			table.insert(delthese, unit)
			valid = false
		end
		
		if valid then
			table.insert(unitmap[tileid], unit.fixed)
		end
	end
	
	for i,unit in ipairs(delthese) do
		local x,y,dir,unitname = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.strings[UNITNAME]
		addundo({"remove",unitname,x,y,dir,unit.values[ID],unit.values[ID],unit.strings[U_LEVELFILE],unit.strings[U_LEVELNAME],unit.values[VISUALLEVEL],unit.values[COMPLETED],unit.values[VISUALSTYLE],unit.flags[MAPLEVEL],unit.strings[COLOUR],unit.strings[CLEARCOLOUR],gettags(unit.fixed)})
		delunit(unit.fixed)
		MF_remove(unit.fixed)
	end
end

function setundo(this)
	if (this ~= nil) then
		if (this == 1) then
			updateundo = true
		elseif (this == 0) then
			updateundo = false
		end
	else
		print("undo is nil!")
		updateundo = true
	end
end

function victory()
	MF_win()
end

function poscorrect(unitid,rotation,zoom,offset)
	local unit = mmf.newObject(unitid)
	
	local midpointx = roomsizex * tilesize * 0.5 * spritedata.values[TILEMULT]
	local midtilex = math.floor(roomsizex * 0.5) - 0.5
	
	if (roomsizex % 2 == 1) then
		midtilex = math.floor(roomsizex * 0.5)
	end
	
	local midpointy = roomsizey * tilesize * 0.5 * spritedata.values[TILEMULT]
	local midtiley = math.floor(roomsizey * 0.5) - 0.5
	
	if (roomsizey % 2 == 1) then
		midtiley = math.floor(roomsizey * 0.5)
	end
	
	local x,y = unit.values[XPOS],unit.values[YPOS]
	local dx = x - midtilex
	local dy = y - midtiley
	
	local dir = 0 - math.atan2(dy,dx) + math.rad(rotation)
	local dist = math.sqrt((dy)^2 + (dx)^2)
	
	local newx = Xoffset + midpointx + math.cos(dir) * dist * zoom * tilesize * spritedata.values[TILEMULT]
	local newy = Yoffset + midpointy - math.sin(dir) * dist * zoom * tilesize * spritedata.values[TILEMULT]
	
	if (unit.values[FLOAT] == 0) then
		unit.x = newx
		unit.y = newy + offset * spritedata.values[TILEMULT]
	elseif (unit.values[FLOAT] == 1) then
		unit.x = newx
		--unit.y = newy + offset * spritedata.values[TILEMULT]
	end
end

function stringintable(this,data)
	if (#data > 0) then
		for i,v in ipairs(data) do
			if (this == v) then
				return true
			end
		end
	end
	
	return false
end

function levelborder(absolute_,ox_,oy_)
	local edgetiles = {}
	local l = map[0]
	
	local absolute = absolute_ or false
	local ox,oy = Xoffset,Yoffset
	
	if absolute then
		ox = ox_
		oy = oy_
	end
	
	for i=0,roomsizex-1 do
		for j=0,roomsizey-1 do
			if (i == 0) or (j == 0) or (i == roomsizex-1) or (j == roomsizey-1) then
				local unitid = MF_create("edge")
				local unit = mmf.newObject(unitid)
				
				table.insert(edgetiles, unitid)
				
				unit.layer = 1
				unit.values[ONLINE] = 1
				unit.values[XPOS] = i
				unit.values[YPOS] = j
				unit.values[POSITIONING] = 20
				unit.x = ox + i * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
				unit.y = oy + j * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
				unit.scaleX = spritedata.values[SPRITEMULT] * spritedata.values[TILEMULT]
				unit.scaleY = spritedata.values[SPRITEMULT] * spritedata.values[TILEMULT]
				
				l:set(i,j,0,0)
			end
		end
	end
	
	local c1,c2 = getuicolour("edge")
	
	for i,unitid in ipairs(edgetiles) do
		local unit = mmf.newObject(unitid)
		
		local dynamicdir = dynamictile(unitid,unit.values[XPOS],unit.values[YPOS],"edge")
		
		unit.direction = dynamicdir
		
		MF_setcolour(unitid,c1,c2)
	end
end

function updatescreen(x,y)
	Xoffset = x
	Yoffset = y
end

function updateroomsize(tilesize_,roomsizex_,roomsizey_)
	tilesize = tilesize_
	
	roomsizex = roomsizex_
	roomsizey = roomsizey_
	
	local delthese = {}
	
	for i,unit in pairs(units) do
		if (unit.values[XPOS] >= roomsizex - 1) or (unit.values[YPOS] >= roomsizey - 1) then
			table.insert(delthese, unit.fixed)
		end
	end
	
	for i,v in ipairs(delthese) do
		local unit = mmf.newObject(v)
		
		if (generaldata.values[MODE] == 5) then
			removetile(unit.fixed,unit.values[XPOS],unit.values[YPOS])
		else
			delunit(unit.fixed)
		end
	end
	
	setunitmap()
end