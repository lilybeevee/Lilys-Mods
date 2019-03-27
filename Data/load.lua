function setupmenu(editorid,editor2id)
	editor = mmf.newObject(editorid)
	editor2 = mmf.newObject(editor2id)
	menu = {"intro"}
	changes = {}
end

function generatetiles()
	tilereference = {}
	tilereference["0,0"] = ""
	
	for i,tile in pairs(tileslist) do
		local tiledata = tile.tile
		
		local x = tiledata[1]
		local y = tiledata[2]
		
		local id = tostring(x) .. "," .. tostring(y)
		
		tilereference[id] = i
		
		if (tile.type == 1) or (tile.type == 3) or (tile.type == 7) or (tile.type == 6) then
			local name = string.sub(tile.name, 6)
			
			table.insert(operators.all, name)
			
			if (tile.operatortype ~= nil) then
				local optype = tile.operatortype
				
				table.insert(operators[optype], name)
				
				if (string.sub(optype, 1, 4) == "cond") then
					conditions[name] = {}
					
					local conddata = conditions[name]
					
					if (optype == "cond_arg") then
						conddata.arguments = true
						conddata.argtype = tile.argtype or {0}
						
						if (tile.argextra ~= nil) then
							conddata.argextra = {}
							
							for a,b in ipairs(tile.argextra) do
								table.insert(conddata.argextra, b)
							end
						end
					else
						conddata.arguments = false
					end
				end
			end
		end
	end
end

function worldinit()
	unitreference = {}
	
	for i,tile in pairs(tileslist) do
		local thisid = MF_create(i)
		local name = tile.name or "error"
		local sprite = tile.sprite or name
		local root = tile.sprite_in_root or false
		MF_changesprite(thisid,sprite,root)
		MF_cleanremove(thisid)
		
		if (name ~= "error") then
			unitreference[name] = i
		end
	end
	
	unitreference["level"] = "level"
end

function loadtile(x,y)
	local id = tostring(x) .. "," .. tostring(y)
	
	if (tilereference[id] ~= nil) then
		return tilereference[id]
	else
		print("Couldn't find object with tile id: " .. tostring(x) .. ", " .. tostring(y))
		return "error"
	end
end

function firstlevel()
	local world = generaldata.strings[WORLD]
	local level = generaldata.strings[CURRLEVEL]
	
	generaldata.strings[CURRLEVEL] = ""
	
	if (string.len(level) == 0) then
		local flevel = MF_read("world","general","firstlevel")
		local slevel = MF_read("world","general","start")
		
		local fstatus = tonumber(MF_read("save",world,flevel)) or 0
		local intro = tonumber(MF_read("save",world,"intro")) or 0
		
		if (string.len(flevel) > 0) then
			if (fstatus < 3) then
				sublevel(slevel,0,0)
				sublevel(flevel,0,0)
				
				generaldata.strings[CURRLEVEL] = flevel
				generaldata.strings[PARENT] = slevel
				
				if (world == "baba") and (intro == 0) then
					MF_intro()
				end
			elseif (fstatus == 3) then
				generaldata.strings[CURRLEVEL] = slevel
			end
		elseif (string.len(slevel) > 0) then
			generaldata.strings[CURRLEVEL] = slevel
			sublevel(slevel,0,0)
		end
	end
end