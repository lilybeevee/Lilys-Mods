function newundo()
	if (updateundo == false) or (doundo == false) then
		table.remove(undobuffer, 1)
	else
		generaldata2.values[UNDOTOOLTIPTIMER] = 0
	end
	
	table.insert(undobuffer, 1, {})
	
	local thisundo = undobuffer[1]
	
	if (thisundo ~= nil) then
		thisundo.wordunits = {}
		
		if (#wordunits > 0) then
			for i,v in ipairs(wordunits) do
				local wunit = mmf.newObject(v[1])
				table.insert(thisundo.wordunits, wunit.values[ID])
			end
		end
	end
	
	updateundo = false
end

function addundo(line)
	if doundo then
		local currentundo = undobuffer[1]
		local text = tostring(#undobuffer) .. ", "
		
		table.insert(currentundo, 1, {})
		currentundo[1] = {}
		
		for i,v in ipairs(line) do
			table.insert(currentundo[1], v)
			text = text .. tostring(v) .. " "
		end
		
		--MF_alert(text)
	end
end


function undo()
	if (#undobuffer > 1) then
		local currentundo = undobuffer[2]
		
		if (currentundo ~= nil) then
			for i,line in ipairs(currentundo) do
				local style = line[1]
				
				if (style == "update") then
					local uid = line[9]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[9])
						
						local unit = mmf.newObject(unitid)
						
						local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
						local x,y,dir = line[3],line[4],line[5]
						unit.values[XPOS] = x
						unit.values[YPOS] = y
						unit.values[DIR] = dir
						unit.values[POSITIONING] = 0
						
						updateunitmap(unitid,oldx,oldy,x,y,unit.strings[UNITNAME])
						dynamic(unitid)
						dynamicat(oldx,oldy)
						
						local ox = math.abs(oldx-x)
						local oy = math.abs(oldy-y)
						
						if (ox + oy == 1) and (unit.values[TILING] == 2) then
							unit.values[VISUALDIR] = ((unit.values[VISUALDIR] - 1)+4) % 4
							unit.direction = unit.values[DIR] * 8 + unit.values[VISUALDIR]
						end
						
						if (unit.strings[UNITTYPE] == "text") then
							updatecode = 1
						end
						
						local undowordunits = currentundo.wordunits
						
						if (#undowordunits > 0) then
							for a,b in pairs(undowordunits) do
								if (b == line[9]) then
									updatecode = 1
								end
							end
						end
					else
						particles("hot",line[3],line[4],1,{1, 1})
					end
				elseif (style == "remove") then
					local uid = line[6]
					local baseuid = line[7] or -1
					
					if (paradox[uid] == nil) and (paradox[baseuid] == nil) then
						local x,y,dir,levelfile,levelname,vislevel,complete,visstyle,maplevel,colour,clearcolour = line[3],line[4],line[5],line[8],line[9],line[10],line[11],line[12],line[13],line[14],line[15]
						local name = line[2]
						
						local unitname = ""
						local unitid = 0
						
						if (name ~= "cursor") then
							unitname = unitreference[name]
							unitid = MF_emptycreate(unitname,x,y)
						else
							unitname = "Editor_selector"
							unitid = MF_specialcreate(unitname)
							setundo(1)
						end
						
						local unit = mmf.newObject(unitid)
						unit.values[ONLINE] = 1
						unit.values[XPOS] = x
						unit.values[YPOS] = y
						unit.values[DIR] = dir
						unit.values[ID] = line[6]
						unit.flags[9] = true
						
						if (name == "cursor") then
							unit.values[POSITIONING] = 7
						end
						
						unit.strings[U_LEVELFILE] = levelfile
						unit.strings[U_LEVELNAME] = levelname
						unit.flags[MAPLEVEL] = maplevel
						unit.values[VISUALLEVEL] = vislevel
						unit.values[VISUALSTYLE] = visstyle
						unit.values[COMPLETED] = complete
						
						unit.strings[COLOUR] = colour
						unit.strings[CLEARCOLOUR] = clearcolour
						
						if (unit.className == "level") then
							MF_setcolourfromstring(unitid,colour)
						end
						
						if (name ~= "cursor") then
							addunit(unitid)
							addunitmap(unitid,x,y,unit.strings[UNITNAME])
							dynamic(unitid)
						else
							MF_setcolour(unitid,4,2)
							unit.visible = true
							unit.layer = 2
						end
						
						if (unit.strings[UNITTYPE] == "text") then
							updatecode = 1
						end
						
						local undowordunits = currentundo.wordunits
						if (#undowordunits > 0) then
							for a,b in ipairs(undowordunits) do
								if (b == line[6]) then
									updatecode = 1
								end
							end
						end
						
						local visibility = hasfeature(name,"is","hide",unitid)
						
						if (visibility ~= nil) then
							unit.visible = false
						end
					else
						particles("hot",line[3],line[4],1,{1, 1})
					end
				elseif (style == "create") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = 0
						
						if (line[2] ~= "cursor") then
							unitid = getunitid(line[3])
						else
							local cursors = MF_getmapcursor()
							
							for a,b in ipairs(cursors) do
								local cunit = mmf.newObject(b)
								
								if (cunit.values[ID] == line[3]) then
									unitid = b
								end
							end
						end
						
						local unit = mmf.newObject(unitid)
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local unittype = unit.strings[UNITTYPE]
						
						unit = {}
						delunit(unitid)
						MF_remove(unitid)
						dynamicat(x,y)
						
						if (unittype == "text") then
							updatecode = 1
						end
						
						local undowordunits = currentundo.wordunits
						if (#undowordunits > 0) then
							for a,b in ipairs(undowordunits) do
								if (b == line[3]) then
									updatecode = 1
								end
							end
						end
					end
				elseif (style == "done") then
					local unitid = line[7]
					--print(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[FLOAT] = line[8]
					unit.angle = 0
					unit.values[POSITIONING] = 0
					unit.values[A] = 0
					unit.values[VISUALLEVEL] = 0
					unit.flags[DEAD] = false
					
					--print(unit.className .. ", " .. tostring(unitid) .. ", " .. tostring(line[3]) .. ", " .. unit.strings[UNITNAME])
					
					addunit(unitid)
				elseif (style == "visibility") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						local unit = mmf.newObject(unitid)
						if (line[4] == 0) then
							unit.visible = true
						elseif (line[4] == 1) then
							unit.visible = false
						end
					end
				elseif (style == "float") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						
						-- Kökkö ratkaisu!
						if (unitid ~= nil) then
							local unit = mmf.newObject(unitid)
							unit.values[FLOAT] = tonumber(line[4])
						end
					end
				elseif (style == "levelupdate") then
					MF_setroomoffset(line[2],line[3])
					mapdir = line[6]
				elseif (style == "maprotation") then
					maprotation = line[2]
					MF_levelrotation(maprotation)
				elseif (style == "mapcursor") then
					MF_setmapcursor(line[3],line[4],line[5],line[10])
				elseif (style == "colour") then
					local unitid = getunitid(line[2])
					MF_setcolour(unitid,line[3],line[4])
					local unit = mmf.newObject(unitid)
					unit.values[A] = line[5]
				end
			end
		end
		
		local nextundo = undobuffer[1]
		nextundo.wordunits = {}
		for i,v in ipairs(currentundo.wordunits) do
			table.insert(nextundo.wordunits, v)
		end
		table.remove(undobuffer, 2)
	end
end

function undostate(state)
	if (state ~= nil) then
		doundo = state
	end
end 