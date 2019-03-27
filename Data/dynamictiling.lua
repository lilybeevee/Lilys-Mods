function dynamictile(unitid,x,y,name,extra_)
	local ox,oy = 0,0
	local result = 0
	local exclude = 0
	local layer = map[0]
	
	local extra = {name,"edge","level"}
	
	if (extra_ ~= nil) then
		for a,b in ipairs(extra_) do
			table.insert(extra, b)
		end
	end
	
	for i=1,4 do
		local v = ndirs[i]
		ox = v[1]
		oy = v[2]
		
		local tileid = (x+ox) + (y+oy) * roomsizex
		local uth = unittypeshere[tileid]
		local maptile = 255
		local found = false
		
		if (uth ~= nil) then
			for c,d in ipairs(extra) do
				if (uth[d] ~= nil) then
					found = true
				end
			end
		end
		
		if (x+ox == 0) or (y+oy == 0) or (x+ox == roomsizex-1) or (y+oy == roomsizey-1) then
			maptile = 1
		end
		
		if found or (maptile ~= 255) then
			result = result + 2 ^ (i - 1)
		end
	end
	
	return result
end

function dynamictiling()
	for i,unitid in ipairs(tiledunits) do
		local unit = mmf.newObject(unitid)
		
		if (unit.values[TILING] == 1) then
			unit.direction = dynamictile(unitid,unit.values[XPOS],unit.values[YPOS],unit.strings[UNITNAME])
		end
	end
end

function dynamic(id,extra_)
	local unit = mmf.newObject(id)
	
	if (unit.values[TILING] == 1) then
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local ox,oy = 0,0
		local name = unit.strings[UNITNAME]
		
		local extra = {name,"edge","level"}
	
		if (extra_ ~= nil) then
			for a,b in ipairs(extra_) do
				table.insert(extra, b)
			end
		end
		
		unit.direction = dynamictile(unit.fixed,x,y,name,extra)
		
		for i=1,4 do
			local v = ndirs[i]
			ox = v[1]
			oy = v[2]
			
			local tileid = (x+ox) + (y+oy) * roomsizex
			local tiledata = unitmap[tileid]
			
			if (tiledata ~= nil) then
				for a,b in ipairs(tiledata) do
					local tile = mmf.newObject(b)
					
					if (tile.strings[UNITNAME] == name) and (tile.values[TILING] == 1) then
						tile.direction = dynamictile(b,x+ox,y+oy,name,extra_)
					end
				end
			end
		end
	end
end

function dynamicat(x,y)
	local ox,oy = 0,0
	
	for i=1,4 do
		local v = ndirs[i]
		ox = v[1]
		oy = v[2]
		
		local tiles = findallhere(x+ox,y+oy)
		
		if (#tiles > 0) then
			for a,b in ipairs(tiles) do
				local tile = mmf.newObject(b)

				if (tile.values[TILING] == 1) then
					tile.direction = dynamictile(b,x+ox,y+oy,tile.strings[UNITNAME])
				end
			end
		end
	end
end