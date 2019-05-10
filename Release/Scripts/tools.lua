function rotate(dir)
	local rot = {2,3,0,1}
	
	return rot[dir+1]	
end

function isthis(lookup,rule)
	for i,rules in ipairs(lookup) do
		local baserule = rules[1]
		
		if (baserule[3] == rule) and (baserule[2] == "is") then
			return true
		end
	end
	
	return false
end

function xthis(lookup,name,rule)
	local result = {}
	
	for i,rules in ipairs(lookup) do
		local baserule = rules[1]
		
		if (baserule[1] == name) and (baserule[2] == rule) then
			table.insert(result, baserule[3])
		end
	end
	
	return result
end

function findall(name_)
	local result = {}
	local name = name_[1]
	
	local checklist = unitlists[name]
	
	if (name == "text") then
		checklist = codeunits
	end
	
	if (checklist ~= nil) then
		for i,unitid in ipairs(checklist) do
			local unit = mmf.newObject(unitid)
			local unitname = getname(unit)
			
			if (unitname == name) then
				if testcond(name_[2],unitid) then
					table.insert(result, unitid)
				end
			end
		end
	end
	
	return result
end

function delunit(unitid)
	local unit = mmf.newObject(unitid)
	local name = getname(unit)
	local x,y = unit.values[XPOS],unit.values[YPOS]
	local unitlist = unitlists[name]
	local unittype = unit.strings[UNITTYPE]
	
	if (unittype == "text") then
		updatecode = 1
	end
	
	x = math.floor(x)
	y = math.floor(y)
	
	if (unitlist ~= nil) then
		for i,v in pairs(unitlist) do
			if (v == unitid) then
				v = {}
				table.remove(unitlist, i)
			end
		end
	end
	
	-- TÄMÄ EI EHKÄ TOIMI
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,v in pairs(unitmap[tileid]) do
			if (v == unitid) then
				v = {}
				table.remove(unitmap[tileid], i)
			end
		end
	
		if (#unitmap[tileid] == 0) then
			unitmap[tileid] = nil
		end
	end
	
	if (unittypeshere[tileid] ~= nil) then
		local uth = unittypeshere[tileid]
		
		local n = unit.strings[UNITNAME]
		
		if (uth[n] ~= nil) then
			uth[n] = uth[n] - 1
			
			if (uth[n] == 0) then
				uth[n] = nil
			end
		end
	end
	
	if (unit.strings[UNITTYPE] == "text") and (codeunits ~= nil) then
		for i,v in pairs(codeunits) do
			if (v == unitid) then
				v = {}
				table.remove(codeunits, i)
			end
		end
	end
	
	if (unit.values[TILING] > 1) and (animunits ~= nil) then
		for i,v in pairs(animunits) do
			if (v == unitid) then
				v = {}
				table.remove(animunits, i)
			end
		end
	end
	
	if (unit.values[TILING] == 1) and (tiledunits ~= nil) then
		for i,v in pairs(tiledunits) do
			if (v == unitid) then
				v = {}
				table.remove(tiledunits, i)
			end
		end
	end
	
	if (#wordunits > 0) and (unit.values[TYPE] == 0) and (unit.strings[UNITTYPE] ~= "text") then
		for i,v in pairs(wordunits) do
			if (v[1] == unitid) then
				updatecode = 1
				v = {}
				table.remove(wordunits, i)
			end
		end
	end
	
	for i,v in ipairs(units) do
		if (v.fixed == unitid) then
			v = {}
			table.remove(units, i)
		end
	end
	
	for i,data in pairs(updatelist) do
		if (data[1] == unitid) and (data[2] ~= "convert") then
			data[2] = "DELETED"
		end
	end

	cleartags(unit)
end

function findtype(typedata,x,y,unitid_)
	local result = {}
	local unitid = 0
	local tileid = x + y * roomsizex
	local name = typedata[1]
	local conds = typedata[2]
	
	if (unitid_ ~= nil) then
		unitid = unitid_
	end

	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			if (v ~= unitid) then
				local unit = mmf.newObject(v)
				
				if (unit.strings[UNITNAME] == name) or ((unit.strings[UNITTYPE] == "text") and (name == "text")) then
					if testcond(conds,v) then
						table.insert(result, v)
					end
				end
			end
		end
	end
	
	return result
end

function findobstacle(x,y)
	local layer = map[0]
	local tile = layer:get_x(x,y)
	local result = {}
	local tileid = x + y * roomsizex
	
	if (tile ~= 255) then
		table.insert(result, -1)
	end
	
	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			local unit = mmf.newObject(v)
			
			if (unit.flags[DEAD] == false) then
				table.insert(result, v)
			else
				MF_alert("Unitmap: found removed unit " .. unit.strings[UNITNAME])
			end
		end
	end
	
	return result
end

function update(unitid,x,y,dir_)
	local unit = mmf.newObject(unitid)

	local unitname = unit.strings[UNITNAME]
	local dir,olddir = unit.values[DIR],unit.values[DIR]
	local tiling = unit.values[TILING]
	local unittype = unit.strings[UNITTYPE]
	local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
	
	if (dir_ ~= nil) then
		dir = dir_
	end
	
	if (x ~= oldx) or (y ~= oldy) or (dir ~= olddir) then
		updateundo = true
		addundo({"update",unitname,oldx,oldy,olddir,x,y,dir,unit.values[ID]})
		
		unit.values[XPOS] = x
		unit.values[YPOS] = y
		unit.values[DIR] = dir
		unit.values[MOVED] = 1
		unit.values[POSITIONING] = 0

		updateunitmap(unitid,oldx,oldy,x,y,unit.strings[UNITNAME])
		
		if (tiling == 1) then
			dynamic(unitid)
			dynamicat(oldx,oldy)
		end
		
		if (unittype == "text") then
			updatecode = 1
		end
		
		if (featureindex["word"] ~= nil) then
			checkwordchanges(unitid)
		end
	end
end

function updatedir(unitid,dir)
	local unit = mmf.newObject(unitid)
	local x,y = unit.values[XPOS],unit.values[YPOS]
	local unitname = unit.strings[UNITNAME]
	local unittype = unit.strings[UNITTYPE]
	local olddir = unit.values[DIR]
	
	if (dir ~= olddir) then
		updateundo = true
		addundo({"update",unitname,x,y,olddir,x,y,dir,unit.values[ID]})
		unit.values[DIR] = dir
		
		if (unittype == "text") then
			updatecode = 1
		end
	end
end

function findtext(x,y)
	local result = {}
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			local unit = mmf.newObject(v)
			
			if (unit.strings[UNITTYPE] == "text") then
				table.insert(result, v)
			end
		end
	end
	
	return result
end

function findallhere(x,y,exclude_,paths_)
	local result = {}
	
	local exclude = 0
	if (exclude_ ~= nil) then
		exclude = exclude_
	end
	
	local paths = false
	if (paths_ ~= nil) then
		paths = paths_
	end
	
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,unitid in ipairs(unitmap[tileid]) do
			if (unitid ~= exclude) then
				table.insert(result, unitid)
			end
		end
	end
	
	if paths then
		local pathshere = MF_findpaths(x,y)
		
		if (#pathshere > 0) then
			for i,v in ipairs(pathshere) do
				table.insert(result, v)
			end
		end
	end
	
	return result
end

function findempty()
	local result = {}
	local array = {}
	local layer = map[0]
	
	for i,unit in ipairs(units) do
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local arrayid = x + y * roomsizex
		
		if (array[arrayid] == nil) then
			array[arrayid] = {}
			table.insert(array[arrayid], unit.fixed)
		end
	end
	
	for i=0,roomsizex-1 do
		for j=0,roomsizey-1 do
			local empty = 1
			local tile = layer:get_x(i,j)
			local arrayid = i + j * roomsizex
			
			if (tile ~= 255) or (array[arrayid] ~= nil) then
				empty = 0
			end
			
			if (empty == 1) then
				table.insert(result, i + j * roomsizex)
			end
		end
	end	
	
	return result
end

function delete(unitid,x_,y_,total_)
	local total = total_ or false
	
	local check = unitid
	
	if (unitid == 2) then
		check = 200 + x_ + y_ * roomsizex
	end
	
	if (deleted[check] == nil) then
		local unit = {}
		local x,y,dir = 0,0,4
		local unitname = ""
		local insidename = ""
		
		if (unitid ~= 2) then
			unit = mmf.newObject(unitid)
			x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
			unitname = unit.strings[UNITNAME]
			insidename = getname(unit)
		else
			x,y = x_,y_
			unitname = "empty"
			insidename = "empty"
		end
		
		x = math.floor(x)
		y = math.floor(y)
		
		if (total == false) then
			inside(insidename,x,y,dir,unitid)
			
			if (unitid ~= 2) and memoryneeded then
				--savememory(unit,insidename)
			end
		end
		
		if (unitid ~= 2) then
			addundo({"remove",unitname,x,y,dir,unit.values[ID],unit.values[ID],unit.strings[U_LEVELFILE],unit.strings[U_LEVELNAME],unit.values[VISUALLEVEL],unit.values[COMPLETED],unit.values[VISUALSTYLE],unit.flags[MAPLEVEL],unit.strings[COLOUR],unit.strings[CLEARCOLOUR],shallowcopy(gettags(unitid))})
			unit = {}
			delunit(unitid)
			MF_remove(unitid)
		
			dynamicat(x,y)
		end
		
		deleted[check] = 1
	else
		print("already deleted")
	end
end

function findwalls(x,y)
	local result = {}
	local stop = findfeature(nil,"is","stop")
	local push = findfeature(nil,"is","push")
	local pull = findfeature(nil,"is","pull")
	local layer = map[0]
	
	if (stop ~= nil) then
		for i,v in ipairs(stop) do
			local stops = findtype(v,x,y,0)
			
			if (#stops > 0) then
				for a,b in ipairs(stops) do
					table.insert(result, b)
				end
			end
		end
	end
	
	if (push ~= nil) then
		for i,v in ipairs(push) do
			local pushes = findtype(v,x,y,0)
			
			if (#pushes > 0) then
				for a,b in ipairs(pushes) do
					table.insert(result, b)
				end
			end
		end
	end
	
	if (pull ~= nil) then
		for i,v in ipairs(pull) do
			local pulls = findtype(v,x,y,0)
			
			if (#pulls > 0) then
				for a,b in ipairs(pulls) do
					table.insert(result, b)
				end
			end
		end
	end
	
	if (layer:get_x(x,y) ~= 255) then
		table.insert(result, 1)
	end
	
	return result
end

function writerules(parent,name,x_,y_)
	local basex = x_
	local basey = y_
	local linelimit = 12
	
	local x,y = basex,basey
	
	if (#visualfeatures > 0) then
		writetext(langtext("rules") .. ":",0,x,y,name,true,2,true)
	end
	
	local texthide = findfeature("text","is","hide")
	
	local columns = math.floor((#visualfeatures - 1) / linelimit) + 1
	local columnwidth = math.min(screenw - tilesize * 2, columns * tilesize * 10) / columns
	
	if (texthide == nil) then
		for i,rules in ipairs(visualfeatures) do
			local currcolumn = math.floor((i - 1) / linelimit) - (columns * 0.5)
			
			x = basex + columnwidth * currcolumn + columnwidth * 0.5
			y = basey + (((i - 1) % linelimit) + 1) * tilesize * 0.8

			local text = textfromrule(rules)
			
			writetext(text,0,x,y,name,true,2,true)
		end
	end
end

function textfromrule(rules)
	local text = ""
	local rule = rules[1]
	
	text = text .. rule[1] .. " "
	
	local conds = rules[2]
	if (#conds > 0) then
		local function writeconds(conds)
			if string.sub(text, -2) == "& " then
				text = string.sub(text, 1, -3)
			end
			for a,cond in ipairs(conds) do
				local middlecond = true
				
				if (cond[2] == nil) or ((cond[2] ~= nil) and (#cond[2] == 0)) then
					middlecond = false
				end
				
				if middlecond then
					text = text .. cond[1] .. " "
					
					if (cond[2] ~= nil) then
						if (#cond[2] > 0) then
							for c,d in ipairs(cond[2]) do
								if type(d) == "table" then
									writeconds(d)
								else
									text = text .. d .. " "
									
									if (#cond[2] > 1) and (c ~= #cond[2]) then
										text = text .. "& "
									end
								end
							end
						end
					end
					
					if (a < #conds) then
						text = text .. "& "
					end
				else
					text = cond[1] .. " " .. text
				end
			end
		end
		writeconds(conds)
	end
	
	text = text .. rule[2] .. " " .. rule[3]

	return text
end

function rulefromtext(text_,replace_)
	local rules,conds = {{},{},{}},{}
	local text = text_
	local replace = replace_ or {}

	local isnot = false
	local lasttype = -1
	local group = rules[1]
	local doingconds = false

	for o,r in pairs(replace) do
		local newtext,_ = string.gsub(text, "{" .. o .. "}", r)
		text = newtext
	end

	for i in string.gmatch(text, "%S+") do
		local word = i

		if string.sub(word, 1, 1) == "{" then
			local var = string.sub(word, 2, -2)
			if replace[var] then
				word = replace[var]
			else
				break
			end
		end

		local type = -1

		local realname = unitreference["text_" .. word]
		if not realname then
			type = 0
		end

		if type == -1 and changes[realname] then
			type = changes[realname].type or -1
		end
		if type == -1 and tileslist[realname] then
			type = tileslist[realname].type or 0
		end

		local prefix = ""
		if isnot then
			prefix = "not "
		end

		if type == 0 or type == 2 then
			table.insert(group, prefix .. word)
			isnot = false
		elseif type == 1 then
			table.insert(rules[2], prefix .. word)
			group = rules[3]
			doingconds = false
			isnot = false
		elseif type == 3 then
			if not doingconds then
				table.insert(conds, {prefix .. word, {}})
			else
				table.insert(group, {prefix .. word, {}})
			end
			isnot = false
		elseif type == 7 then
			if lasttype == 6 then
				doingconds = false
			end
			if not doingconds then
				group = conds
			end
			local newgroup = {}
			if not doingconds then
				table.insert(group, {prefix .. word, newgroup})
			else
				table.insert(group, {{prefix .. word, newgroup}})
			end
			group = newgroup
			doingconds = true
			isnot = false
		elseif type == 4 then
			isnot = not isnot
		end

		lasttype = type
	end

	if #rules[3] > 0 then
		return rules,conds
	else
		return nil,nil
	end
end

function mapcells()
	local count = 0 
	
	for i,v in pairs(unitmap) do
		if (#v > 0) then
			count = count + 1
		end
	end
	
	return count
end

function copy(unitid,x,y)
	for i,unit in ipairs(units) do
		if (unit.fixed == unitid) then
			local oldx,oldy,dir,name,float = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.strings[UNITNAME],unit.values[FLOAT]
			
			local this = create(name,x,y,dir,oldx,oldy,float)
			return this
		end
	end
end

function create(name,x,y,dir,oldx_,oldy_,float_)
	local oldx,oldy,float = x,y,0
	local tileid = x + y * roomsizex
	
	if (oldx_ ~= nil) then
		oldx = oldx_
	end
	
	if (oldy_ ~= nil) then
		oldy = oldy_
	end
	
	if (float_ ~= nil) then
		float = float_
	end
	
	local unitname = unitreference[name]
	
	local newunitid = MF_emptycreate(unitname,oldx,oldy)
	local newunit = mmf.newObject(newunitid)
	
	local id = newid()
	
	newunit.values[ONLINE] = 1
	newunit.values[XPOS] = x
	newunit.values[YPOS] = y
	newunit.values[DIR] = dir
	newunit.values[ID] = id
	newunit.values[FLOAT] = float
	newunit.flags[CONVERTED] = true
	
	newunit.flags[9] = true
	addundo({"create",name,id})
	addunit(newunitid)
	addunitmap(newunitid,x,y,newunit.strings[UNITNAME])
	dynamic(newunitid)
	
	return newunit.fixed
end

function getunitid(id)
	local style = style_ or ""
	
	for i,unit in ipairs(units) do
		if (unit.values[ID] == id) then
			return unit.fixed
		end
	end
	
	MF_alert("No valid unitid found for this ID: " .. tostring(id))
	return 0
end

function newid()
	local result = generaldata.values[CURRID]
	generaldata.values[CURRID] = generaldata.values[CURRID] + 1
	return result
end

function addunitmap(id,x,y,name)
	local doadd = true
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] == nil) then
		unitmap[tileid] = {}
	else
		for a,b in ipairs(unitmap[tileid]) do
			if (b == id) then
				doadd = false
			end
		end
	end
	
	if (unittypeshere[tileid] == nil) then
		unittypeshere[tileid] = {}
	end
	
	local uth = unittypeshere[tileid]
	
	if (uth[name] == nil) then
		uth[name] = 0
	end
	
	if doadd then
		table.insert(unitmap[tileid], id)
		uth[name] = uth[name] + 1
	end

	if not gettag(id,"timepos") then
		settag(id,"timepos",{x,y})
	end
end

function updateunitmap(id,oldx,oldy,x,y,name)
	local tileid = x + y * roomsizex
	local oldtileid = oldx + oldy * roomsizex
	
	if (unitmap[oldtileid] ~= nil) then
		for i,v in ipairs(unitmap[oldtileid]) do
			if (v == id) then
				table.remove(unitmap[oldtileid], i)
			end
		end
	end
	
	if (unittypeshere[oldtileid] ~= nil) then
		local uth = unittypeshere[oldtileid]
		
		if (uth[name] ~= nil) then
			uth[name] = uth[name] - 1
			
			if (uth[name] == 0) then
				uth[name] = nil
			end
		end
	end
	
	addunitmap(id,x,y,name)
end

function inside(name,x,y,dir,unitid)
	local ins = {}
	local tileid = x + y * roomsizex
	local maptile = unitmap[tileid] or {}
	
	if (featureindex[name] ~= nil) then
		for i,rule in ipairs(featureindex[name]) do
			local baserule = rule[1]
			local conds = rule[2]
			
			local target = baserule[1]
			local verb = baserule[2]
			local object = baserule[3]
			
			if (target == name) and (verb == "has") then
				local valid = true
				
				for a,b in ipairs(maptile) do
					local bunit = mmf.newObject(b)
					local bname = bunit.strings[UNITNAME]
					
					--MF_alert(name .. " is looking: " .. object .. ", " .. bname)
					if ((object == "text") and (bname == "text_" .. name)) and (bname ~= name) then
						valid = false
					end
				end
				
				if valid then
					table.insert(ins, {object,conds})
				end
			end
		end
	end
	
	if (#ins > 0) then
		for i,v in ipairs(ins) do
			local object = v[1]
			local conds = v[2]
			if testcond(conds,unitid) then
				if (object ~= "text") then
					for a,mat in pairs(objectlist) do
						if (a == object) and (object ~= "empty") and (object ~= "group") then
							if (object ~= "all") then
								create(object,x,y,dir)
							else
								createall(v,x,y,unitid)
							end
						end
					end
				else
					create("text_" .. name,x,y,dir)
				end
			end
		end
	end
end

function savememory(unit,name)
	local x,y = unit.values[XPOS],unit.values[YPOS]
	
	local currstep = #undobuffer
	
	if (memory[name] == nil) then
		memory[name] = {}
	end
	
	local id = #memory[name] + 1
	
	memory[name][id] = {}
	local currmem = memory[name][id]
	
	currmem.timer = 0
	currmem.undobuffer = #undobuffer
	currmem.name = unit.strings[UNITNAME]
	
	local currundo = undobuffer[1]
	currmem.undoid = #currundo
	
	if (unit.values[MISC_A] > 0) and (generaldata.values[MODE] == 0) then
		currmem.undobuffer = unit.values[MISC_A]
	end
	
	if (unit.values[MISC_B] > 0) and (generaldata.values[MODE] == 0) then
		currmem.timer = unit.values[MISC_B] + 1
	end
	
	MF_alert("Added a new memory at " .. tostring(#undobuffer) .. ", on slot " .. tostring(currmem.undoid))
end

function animate()
	for i,unitid in ipairs(animunits) do
		local unit = mmf.newObject(unitid)
		local name = unit.strings[UNITNAME]
		local sleep = hasfeature(name,"is","sleep",unitid)

		if (unit.values[TILING] == 4) then
			if (sleep == nil) then
				if (unit.values[VISUALDIR] ~= -1) then
					unit.values[VISUALDIR] = (unit.values[VISUALDIR] + 1) % 4
				else
					MF_particles("destroy",unit.values[XPOS],unit.values[YPOS],1,3,1,3,1)
					unit.values[VISUALDIR] = 0
				end
				
				unit.direction = ((unit.values[VISUALDIR]) + 32) % 32
			else
				unit.values[VISUALDIR] = -1
				unit.direction = ((unit.values[DIR] * 8 + unit.values[VISUALDIR]) + 32) % 32
			end
		end
		
		if (unit.values[TILING] == 3) then
			if (sleep == nil) then
				if (unit.values[VISUALDIR] ~= -1) then
					unit.values[VISUALDIR] = (unit.values[VISUALDIR] + 1) % 4
				else
					MF_particles("destroy",unit.values[XPOS],unit.values[YPOS],1,3,1,3,1)
					unit.values[VISUALDIR] = 0
				end
				
				unit.direction = ((unit.values[DIR] * 8 + unit.values[VISUALDIR]) + 32) % 32
			else
				unit.values[VISUALDIR] = -1
				unit.direction = ((unit.values[DIR] * 8 + unit.values[VISUALDIR]) + 32) % 32
			end
		end
		
		if (unit.values[TILING] == 2) then
			if (sleep == nil) then
				if (unit.values[VISUALDIR] == -1) then
					MF_particles("destroy",unit.values[XPOS],unit.values[YPOS],1,3,1,3,1)
					unit.values[VISUALDIR] = 0
				end
				
				unit.direction = ((unit.values[DIR] * 8 + unit.values[VISUALDIR]) + 32) % 32
			else
				unit.values[VISUALDIR] = -1
				unit.direction = ((unit.values[DIR] * 8 + unit.values[VISUALDIR]) + 32) % 32
			end
		end
	end
end

function issolid(unitid)
	local unit = mmf.newObject(unitid)
	local name = unit.strings[UNITNAME]
	
	if (unit.strings[UNITTYPE] == "text") then
		name = "text"
	end
	
	local ispush = hasfeature(name,"is","push",unitid)
	local ispull = hasfeature(name,"is","pull",unitid)
	local ismove = hasfeature(name,"is","move",unitid)
	local isyou = hasfeature(name,"is","you",unitid) or hasfeature(name,"is","you2",unitid)
	
	if (ispush ~= nil) or (ispull ~= nil) or (ismove ~= nil) or (isyou ~= nil) then
		return true
	end
	
	return false
end

function isgone(unitid)
	if (issafe(unitid) == false) then
		local unit = mmf.newObject(unitid)
		local x,y,name = unit.values[XPOS],unit.values[YPOS],unit.strings[UNITNAME]
		
		if (unit.strings[UNITTYPE] == "text") then
			name = "text"
		end
		
		local isyou = hasfeature(name,"is","you",unitid,x,y) or hasfeature(name,"is","you2",unitid,x,y)
		local ismelt = hasfeature(name,"is","melt",unitid,x,y)
		local isweak = hasfeature(name,"is","weak",unitid,x,y)
		local isshut = hasfeature(name,"is","shut",unitid,x,y)
		local isopen = hasfeature(name,"is","open",unitid,x,y)
		local ismove = hasfeature(name,"is","move",unitid,x,y)
		local ispush = hasfeature(name,"is","push",unitid,x,y)
		local ispull = hasfeature(name,"is","pull",unitid,x,y)
		local eat = findfeatureat(nil,"eat",name,x,y)
		
		if (eat ~= nil) then
			for i,v in ipairs(eat) do
				if (v ~= unitid) then
					return true
				end
			end
		end

		local issink = findfeatureat(nil,"is","sink",x,y)
		
		if (issink ~= nil) then
			for i,v in ipairs(issink) do
				if (v ~= unitid) and (floating(v,unitid)) then
					return true
				end
			end
		end
		
		if (isyou ~= nil) then
			local isdefeat = findfeatureat(nil,"is","defeat",x,y)
			
			if (isdefeat ~= nil) then
				for i,v in ipairs(isdefeat) do
					if (floating(v,unitid)) then
						return true
					end
				end
			end
		end
		
		if (ismelt ~= nil) then
			local ishot = findfeatureat(nil,"is","hot",x,y)
			
			if (ishot ~= nil) then
				for i,v in ipairs(ishot) do
					if (floating(v,unitid)) then
						return true
					end
				end
			end
		end
		
		if (isshut ~= nil) then
			local isopen_ = findfeatureat(nil,"is","open",x,y)
			
			if (isopen_ ~= nil) then
				for i,v in ipairs(isopen_) do
					if (floating(v,unitid)) then
						return true
					end
				end
			end
		end
		
		if (isopen ~= nil) then
			local isshut_ = findfeatureat(nil,"is","shut",x,y)
			
			if (isshut_ ~= nil) then
				for i,v in ipairs(isshut_) do
					if (floating(v,unitid)) then
						return true
					end
				end
			end
		end
		
		if (isweak ~= nil) then
			local things = findallhere(x,y)
			
			if (things ~= nil) then
				for i,v in ipairs(things) do
					if (v ~= unitid) and (floating(v,unitid)) and not issoft(v) then
						return true
					end
				end
			end
		end
	end
	
	print("its gone!")
	return false
end

function floating(id1,id2)
	local unit1 = mmf.newObject(id1)
	local unit2 = mmf.newObject(id2)
	
	if (unit1.values[FLOAT] == unit2.values[FLOAT]) then
		return true
	end
	
	return false
end

function floating_level(id)
	local unit = mmf.newObject(id)
	
	local levelfloat = findfeature("level","is","float")
	local valid = 0
	
	if (levelfloat ~= nil) then
		for i,v in ipairs(levelfloat) do
			if testcond(v[2],1) then
				valid = 1
			end
		end
	end
	
	if (unit.values[FLOAT] == valid) then
		return true
	end
	
	return false
end

function findgroup()
	local result = {}
	local groupstuff = {}
	
	if (featureindex["group"] ~= nil) then
		for i,rules in ipairs(featureindex["group"]) do
			local rule = rules[1]
			local conds = rules[2]

			if (rule[3] == "group") then
				if (rule[2] == "is") and (rule[1] ~= "group") then
					table.insert(groupstuff, {rule[1],conds})
				end
			end
		end
	end
	
	if (#groupstuff > 0) then
		for i,v in ipairs(groupstuff) do
			for a,mat in pairs(objectlist) do
				if (a ~= nil) then
					if (a == v[1]) and (a ~= "group") then
						table.insert(result, v)
					end
				end
			end
		end
	end
	
	return result
end

function issafe(unitid,x,y)
	name = ""
	
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		name = getname(unit)
	else
		name = "empty"
	end
	
	local safe = hasfeature(name,"is","safe",unitid,x,y)
	
	if (safe ~= nil) then
		return true
	end
	
	return false
end

function issleep(unitid)
	local unit = mmf.newObject(unitid)
	local name = unit.strings[UNITNAME]
	
	if (unit.strings[UNITTYPE] == "text") then
		name = "text"
	end
	
	local sleep = hasfeature(name,"is","sleep",unitid)
	
	if (sleep ~= nil) then
		return true
	end
	
	return false
end

function issoft(unitid,x,y)
	name = ""
	
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		name = getname(unit)
	else
		name = "empty"
	end
	
	local soft = hasfeature(name,"is","soft",unitid,x,y)
	
	if (soft ~= nil) then
		return true
	end
	
	return false
end

function getmat(m)
	local found = false
	
	for i,v in pairs(objectlist) do
		if (i == m) then
			found = true
		end
	end
	
	if found then
		return m
	else
		return nil
	end
end

function destroylevel()
	local dellist = {}
	for i,unit in ipairs(units) do
		table.insert(dellist, unit.fixed)
	end
	
	if (#dellist > 0) then
		for i,unitid in ipairs(dellist) do
			local unit = mmf.newObject(unitid)
			local c1,c2 = getcolour(unitid)
			local pmult,sound = checkeffecthistory("destroylevel")
			MF_particles("bling",unit.values[XPOS],unit.values[YPOS],10 * pmult,c1,c2,1,1)
			setsoundname("removal",1)
			delete(unitid,nil,nil,true)
		end
	end
	
	updatecode = 1
	features = {}
	featureindex = {}
	notfeatures = {}
	collectgarbage()
end

function findunitat(name,x,y)
	local id = x + y * roomsizex
	
	local result = {}
	
	if (unitmap[id] ~= nil) then
		for i,v in ipairs (unitmap[id]) do
			local unit = mmf.newObject(v)
			
			if (unit.strings[UNITNAME] == name) or (name == nil) then
				table.insert(result, v)
			end
		end
	end
	
	return result
end

function checkwordchanges(unitid)
	if (#wordunits > 0) then
		for i,v in ipairs(wordunits) do
			if (v[1] == unitid) then
				updatecode = 1
			end
		end
	end
end

function getpath(root)
	local world = generaldata.strings[WORLD]
	
	if (root == 1) then
		return "Data/"
	else
		return "Data/Worlds/" .. world .. "/"
	end
end

function append(t1,t2)
	local result = {}
	
	for i,v in ipairs(t1) do
		table.insert(result, v)
	end
	
	for i,v in ipairs(t2) do
		table.insert(result, v)
	end
	
	return result
end

function getname(unit)
	local result = unit.strings[UNITNAME]
	
	if (unit.strings[UNITTYPE] == "text") then
		result = "text"
	end
	
	return result
end

function getemptytiles()
	local pos = {}
	
	for i=1,roomsizex-2 do
		for j=1,roomsizey-2 do
			local tileid = i + j * roomsizex
			
			if (unitmap[tileid] == nil) then
				table.insert(pos, {i, j})
			else
				if (#unitmap[tileid] == 0) then
					table.insert(pos, {i, j})
				end
			end
		end
	end
	
	return pos
end

function setsoundname(type,id,short)
	local result = ""
	
	if (id > 0) then
		local sound = soundnames[id]
		
		if (sound ~= nil) then
			result = sound.name
			
			if (sound.count ~= nil) then
				local rnd = math.random(1,sound.count)
				result = result .. tostring(rnd)
			end
		end
	end
	
	if (short ~= nil) then
		result = result .. short
	end
	
	--MF_alert(result)
	
	if (type == "removal") then
		generaldata2.strings[REMOVALSOUND] = result
	elseif (type == "turn") then
		generaldata2.strings[TURNSOUND] = result
	end
	
	return result
end

function checkturnsound()
	if (generaldata2.strings[TURNSOUND] == "") and (editor.strings[MENU] == "ingame") then
		if updateundo then
			setsoundname("turn",8)
		end
	end
end

function getlevelsurrounds(levelid)
	local level = mmf.newObject(levelid)
	
	local dirids = {"r","u","l","d","dr","ur","ul","dl","o"}
	local x,y,dir = level.values[XPOS],level.values[YPOS],level.values[DIR]
	
	local result = tostring(dir) .. ","
	
	for i,v in ipairs(dirs_diagonals) do
		result = result .. dirids[i] .. ","
		
		local ox,oy = v[1],v[2]
		
		local tileid = (x + ox) + (y + oy) * roomsizex
		
		if (unitmap[tileid] ~= nil) then
			if (#unitmap[tileid] > 0) then
				for a,b in ipairs(unitmap[tileid]) do
					if (b ~= levelid) then
						local unit = mmf.newObject(b)
						local name = getname(unit)
						
						result = result .. name .. ","
					end
				end
			else
				result = result .. "-" .. ","
			end
		else
			result = result .. "-" .. ","
		end
	end
	
	generaldata2.strings[LEVELSURROUNDS] = result
end

function parsesurrounds()
	local surrounds = MF_parsestring(generaldata2.strings[LEVELSURROUNDS])
	local result = {}
	local stage = 0
	
	local dirids = {"r","u","l","d","dr","ur","ul","dl","o"}
	
	for i,v in ipairs(surrounds) do
		if (i == 1) then
			result.dir = tonumber(v)
		else
			if (v == dirids[stage + 1]) then
				stage = stage + 1
			else
				local dir = dirids[stage]
				
				if (result[dir] == nil) then
					result[dir] = {}
				end
				
				table.insert(result[dir], v)
			end
		end
	end
	
	return result
end

function copytable(t1,t2)
	local result = {}
	
	for i,v in ipairs(t2) do
		table.insert(result, v)
	end
	
	table.insert(t1, result)
	
	return t1
end

function copysubtable(t1,t2)
	for i,v in ipairs(t2) do
		local result = {}
		for a,b in ipairs(v) do
			table.insert(result, b)
		end
		table.insert(t1, result)
	end
	
	return t1
end

function checkeffecthistory(id)
	local result = false
	local sound = ""
	local mult = 1
	
	if (effecthistory[id] ~= nil) then
		result = true
		mult = 0.5
		effecthistory[id] = effecthistory[id] + 1
		
		if (effecthistory[id] % 1 > 0) then
			sound = "_short"
		end
		
		if (effecthistory[id] > 5) then
			mult = 0.2
		end
	else
		effecthistory[id] = 2
	end
	
	return mult,sound,result
end

function updateeffecthistory()
	for i,v in pairs(effecthistory) do
		if (v > 1.5) then
			effecthistory[i] = 1.5
		else
			effecthistory[i] = nil
		end
	end
end

function reseteffecthistory()
	effecthistory = {}
end

function genflowercolour()
	local result = ""
	
	local c = colours.flowers
	local rnd = math.random(1, #c)
	local colour = c[rnd]
	
	local c1,c2 = colour[1],colour[2]
	
	result = tostring(c1) .. "," .. tostring(c2)
	
	return result,c1,c2
end

function autocheck(unitid,ignored_)
	local ignored = ignored_ or {}
	if autoturn then
		if not ignored[unitid] and not autounits[unitid] then
			return false
		end
	else
		local name = ""
		if unitid ~= 3 and unitid ~= 2 and unitid ~= 1 then
			local unit = mmf.newObject(unitid)
			name = getname(unit)
		elseif unitid == 3 then
			name = "gravity"
		elseif unitid == 2 then
			name = "empty"
		elseif unitid == 1 then
			name = "level"
		end
		if not ignored[unitid] and hasfeature(name,"is","auto",unitid) then
			return false
		end
	end
	return true
end

function timecheck(unitid,x_,y_,old)
	if not timelessturn then
		return true
	else
		local name = ""
		if unitid == 1 then
			name = "level"
		elseif unitid == 2 then
			name = "empty"
		elseif unitid == 3 then
			name = "gravity"
		else
			if old then
				return gettag(unitid,"timeless") or gettag(unitid,"lasttimeless")
			else
				return gettag(unitid,"timeless")
			end
		end
		return hasfeature(name,"is","timeless",unitid,x_,y_)
	end
end

function timelessdelete(data)
	local realid = nil
	if data[2] ~= 2 then
		local unit = mmf.newObject(data[2])
		realid = unit.values[ID]
	end
	if realid ~= nil then
		table.insert(data, realid)
	end
	table.insert(timelessdels, data)
end

function updatetimeless(dontundo)
	local result = 0
	for _,unit in ipairs(units) do
		local id = unit.fixed
		local name = getname(unit)
		local timeless = hasfeature(name,"is","timeless",id)
		local localresult = 0
		local oldlasttimeless = gettag(id,"lasttimeless")
		local oldtimeless = gettag(id,"timeless")
		local oldtimepos = gettag(id,"timepos")
		if gettag(id,"timeless") and not timeless then
			localresult = 2
		elseif not gettag(id,"timeless") and timeless then
			localresult = 2
		end
		settag(id,"lasttimeless",oldtimeless,not dontundo)
		settag(id,"timeless",timeless,not dontundo)
		if timecheck(id,0,0,true) or not oldtimepos then
			if not dontundo then
				settag(id,"timepos",{unit.values[XPOS],unit.values[YPOS]},not dontundo)
			end
			if not oldtimepos or unit.values[XPOS] ~= oldtimepos[1] or unit.values[YPOS] ~= oldtimepos[2] then
				if timelessturn then
					localresult = 2
				else
					localresult = math.max(localresult, 1)
				end
			end
		end
		if localresult > 0 then
			result = math.max(result, localresult)
		end
	end
	if result > 0 then
		updatetimemap()
	end
	if result == 2 then
		return true
	else
		return false
	end
end

function updatetimemap()
	timemap = {}
	for i=1,roomsizex-2 do
		for j=1,roomsizey-2 do
			local tileid = i + j * roomsizex

			if unitmap[tileid] ~= nil then
				for _,v in ipairs(unitmap[tileid]) do
					local unit = mmf.newObject(v)

					if not timecheck(v) and gettag(v,"timepos") then
						local newpos = gettag(v,"timepos")
						local newtileid = newpos[1] + newpos[2] * roomsizex
						if not timemap[newtileid] then
							timemap[newtileid] = {}
						end
						table.insert(timemap[newtileid], v)
					else
						if not timemap[tileid] then
							timemap[tileid] = {}
						end
						table.insert(timemap[tileid], v)
					end
				end
			end
		end
	end
end

function gettag(unitid,name)
	if not unittags[unitid] then
		unittags[unitid] = {}
	end
	return unittags[unitid][name]
end

function gettags(unitid)
	if not unittags[unitid] then
		unittags[unitid] = {}
	end
	return unittags[unitid]
end

function settag(unitid,name,value,undo)
	if not unittags[unitid] then
		unittags[unitid] = {}
	end
	local equal = eq(unittags[unitid][name],value)
	if undo and not equal then
		local id = -unitid
		if unitid ~= 1 and unitid ~= 2 and unitid ~= 3 then
			local unit = mmf.newObject(unitid)
			id = unit.values[ID]
		end
		addundo({"tags","set",id,name,unittags[unitid][name]})
	end
	unittags[unitid][name] = value
	return not equal
end

function settags(unitid,values,undo)
	if undo then
		local id = -unitid
		if unitid ~= 1 and unitid ~= 2 and unitid ~= 3 then
			local unit = mmf.newObject(unitid)
			id = unit.values[ID]
		end
		addundo({"tags","all",id,name,unittags[unitid]})
	end
	unittags[unitid] = values
end

function cleartags(unitid,undo)
	if undo then
		local id = -unitid
		if unitid ~= 1 and unitid ~= 2 and unitid ~= 3 then
			local unit = mmf.newObject(unitid)
			id = unit.values[ID]
		end
		addundo({"tags","all",id,name,unittags[unitid]})
	end
	unittags[unitid] = nil
end

function eq(a,b)
	if type(a) == "table" or type(b) == "table" then
		if type(a) ~= "table" or type(b) ~= "table" then
			return false
		end
		local result = true
		if #a == #b then
			for i,v in pairs(a) do
				if v ~= b[i] then
					result = false
					break
				end
			end
		else
			result = false
		end
		return result
	else
		return a == b
	end
end

function deepeq(a,b)
	if type(a) == "table" or type(b) == "table" then
		if type(a) ~= "table" or type(b) ~= "table" then
			return false
		end
		local result = true
		if #a == #b then
			for i,v in pairs(a) do
				result = deepeq(v,b[i])
				if not result then
					break
				end
			end
		else
			result = false
		end
		return result
	else
		return a == b
	end
end

function shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in pairs(orig) do
					copy[orig_key] = orig_value
			end
	else -- number, string, boolean, etc
			copy = orig
	end
	return copy
end