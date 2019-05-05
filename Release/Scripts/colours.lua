function setcolour(unitid,value_)
	local unit = mmf.newObject(unitid)
	
	local name = unit.className
	local dir = unit.values[DIR]
	local unitinfo = tileslist[name]
	
	local cc1,cc2 = -1,-1
	
	if (name ~= "level") and (name ~= "path") then
		if (objectcolours[name] ~= nil) then
			local c = objectcolours[name]
			
			if (value_ == nil) then
				if (c.colour ~= nil) then
					local cc = c.colour
					cc1,cc2 = cc[1],cc[2]
				end
			else
				if (c[value_] ~= nil) then
					local cc = c[value_]
					cc1,cc2 = cc[1],cc[2]
				else
					if (c.colour ~= nil) then
						local cc = c.colour
						cc1,cc2 = cc[1],cc[2]
					end
				end
			end
			
			if (c[dir] ~= nil) then
				local cc = c[dir]
				cc1,cc2 = cc[1],cc[2]
			end
		end
		
		if (cc1 == -1) or (cc2 == -1) then
			if (value_ == nil) then
				if (unitinfo == nil) or (unitinfo.colour == nil) then
					MF_defaultcolour(unitid)
				elseif (unitinfo ~= nil) and (unitinfo.colour ~= nil) then
					local colour = unitinfo.colour
					MF_setcolour(unitid,colour[1],colour[2])
				end
			else
				if (unitinfo == nil) or (unitinfo[value_] == nil) then
					MF_defaultcolour(unitid)
				elseif (unitinfo ~= nil) and (unitinfo[value_] ~= nil) then
					local colour = unitinfo[value_]
					MF_setcolour(unitid,colour[1],colour[2])
				end
			end
		else
			MF_setcolour(unitid,cc1,cc2)
		end
	end
end

function getcolour(unitid,value_)
	local unit = mmf.newObject(unitid)
	
	local name = unit.className
	local unitinfo = tileslist[name]
	
	local defaultcolour = colours.default
	
	local value = "colour"
	
	if (value_ ~= nil) then
		value = value_
	end

	if unit.values[A] == 1 then
		return 2,2
	elseif unit.values[A] == 2 then
		return 1,3
	end
	
	if (objectcolours[name] ~= nil) then
		local c = objectcolours[name]
		
		if (value_ == nil) then
			if (c.colour ~= nil) then
				local cc = c.colour
				return cc[1],cc[2]
			end
		else
			if (c[value_] ~= nil) then
				local cc = c[value_]
				cc1,cc2 = cc[1],cc[2]
				return cc[1],cc[2]
			else
				if (c.colour ~= nil) then
					local cc = c.colour
					return cc[1],cc[2]
				end
			end
		end
		
		if (c[dir] ~= nil) then
			local cc = c[dir]
			return cc[1],cc[2]
		end
	end
	
	if (unitinfo == nil) then
		return defaultcolour[1],defaultcolour[2]
	else
		if (unitinfo[value] == nil) then
			if (unitinfo.colour == nil) then
				return defaultcolour[1],defaultcolour[2]
			else
				local colour = unitinfo.colour
				return colour[1],colour[2]
			end
		else
			local colour = unitinfo[value]
			return colour[1],colour[2]
		end
	end

	return defaultcolour[1],defaultcolour[2]
end

function getuicolour(which,subwhich)
	local bcolour = {}
	
	if (subwhich == nil) or (subwhich == "") then
		bcolour = colours[which]
	else
		bcolour = colours[which][subwhich]
	end
	
	if (bcolour == nil) then
		bcolour = colours.default
	end
	
	return bcolour[1],bcolour[2]
end

function updatecolours(edit_)
	local edit = false
	
	if (edit_ ~= nil) then
		edit = edit_
	end
	
	MF_setbackcolour()
	
	for i,unit in ipairs(units) do
		if (unit.strings[UNITNAME] ~= "level") then
			if (unit.strings[UNITTYPE] ~= "text") then
				setcolour(unit.fixed)
			else
				if edit then
					setcolour(unit.fixed,"active")
				else
					setcolour(unit.fixed)
				end
			end
		end
	end
	
	updatecode = 1
	code()
end

function addobjectcolour(name,dir,c1,c2)
	if (objectcolours[name] == nil) then
		objectcolours[name] = {}
	end
	
	local oc = objectcolours[name]
	
	oc[dir] = {c1, c2}
end

function getobjectcolour(unitid,c)
	local unit = mmf.newObject(unitid)
	
	local name = unit.className
	local unitinfo = tileslist[name]
	
	local c1,c2 = -1,-1
	
	if (objectcolours[name] ~= nil) then
		local oc = objectcolours[name]
		
		if (oc[c] ~= nil) then
			c1 = oc[c][1]
			c2 = oc[c][2]
		end
	end
	
	if (c1 == -1) or (c2 == -1) then
		if (unitinfo[c] ~= nil) then
			c1 = unitinfo[c][1]
			c2 = unitinfo[c][2]
		end
	end
	
	return c1,c2
end

function updateunitcolour(unitid,edit_)
	local edit = false
	
	if (edit_ ~= nil) then
		edit = edit_
	end
	
	local unit = mmf.newObject(unitid)
	
	if (unit.strings[UNITNAME] ~= "level") then
		if (unit.strings[UNITTYPE] ~= "text") then
			setcolour(unit.fixed)
		else
			if edit then
				setcolour(unit.fixed,"active")
			else
				setcolour(unit.fixed)
			end
		end
	end
end

function updateallcolours()
	for i,unit in ipairs(units) do
		updateunitcolour(unit.fixed,true)
		
		local data = tileslist[unit.className]
		unit.values[ZLAYER] = data.layer
	end
end

function setthisuicolour(unitid,colourid,colourid2)
	local data = colours[colourid]
	
	if (colourid2 ~= nil) then
		data = colours[colourid][colourid2]
	end
	
	if (data == nil) then
		print("No colour at " .. tostring(colourid) .. ", " .. tostring(colourid2))
	end
	
	MF_setcolour(unitid,data[1],data[2])
end

function setbackcolour()
	MF_setbackcolour()
end