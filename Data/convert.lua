function conversion(dolevels_,persistonly_)
	local alreadydone = {}
	local dolevels = dolevels_ or false
	
	for i,v in pairs(features) do
		local words = v[1]
		
		local operator = words[2]
		
		if (operator == "is") then
			local output = {}
			local name = words[1]
			local thing = words[3]
			
			if (getmat(thing) ~= nil) or (thing == "not " .. name) or (thing == "all") or (thing == "cursor") then
				if (featureindex[name] ~= nil) and (alreadydone[name] == nil) then
					alreadydone[name] = 1
					
					for a,b in ipairs(featureindex[name]) do
						local rule = b[1]
						local conds = b[2]
						local target,verb,object = rule[1],rule[2],rule[3]
						
						if (target == name) and (verb == "is") and (object ~= name) and (object ~= "word") then
							if (object ~= "text") then
								if (object == "not " .. name) then
									table.insert(output, {"error", conds})
								else
									for d,mat in pairs(objectlist) do
										if (d ~= "group") and (d == object) then
											table.insert(output, {object, conds})
										end
									end
								end
							elseif (object == "text") then
								if (name ~= object) then
									table.insert(output, {object, conds})
								end
							end
						end
					end
				end
				
				if (#output > 0) then
					local conversions = {}
					
					for k,v3 in pairs(output) do
						local object = v3[1]
						local conds = v3[2]

						if (object ~= "all") and (object ~= "text") and (object ~= "group") and (object ~= "word") and (object ~= "any") then
							table.insert(conversions, v3)
						elseif (object == "all") then
							addaction(0,{"createall",{name,conds},dolevels})
							--createall({name,conds})
						elseif (object == "text") then
							table.insert(conversions, {"text_" .. name,conds})
						end
					end
					
					if (#conversions > 0) then
						convert(name,conversions,dolevels)
					end
				end
			end
		end
	end
end

function convert(stuff,mats,dolevels_)
	local layer = map[0]
	local delthese = {}
	local mat1 = stuff
	local dolevels = dolevels_ or false
	
	if (mat1 ~= "empty") and (mat1 ~= "level") then
		local targets = {}
		
		if (mat1 ~= "cursor") and (unitlists[mat1] ~= nil) then
			targets = unitlists[mat1]
		elseif (mat1 == "cursor") then
			targets = MF_getmapcursor()
			editor.values[NAMEFLAG] = 0
		end
		
		if (#targets > 0) then
			for i,unitid in pairs(targets) do
				local unit = mmf.newObject(unitid)
				local x,y,dir,id = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.values[ID]
				local name = getname(unit)

				if (unit.flags[CONVERTED] == false) then
					for a,matdata in pairs(mats) do
						local mat2 = matdata[1]
						local conds = matdata[2]
						
						local objectfound = false
						
						if (unitreference[mat2] ~= nil) and (mat2 ~= "level") then
							local object = unitreference[mat2]
							
							if (tileslist[object]["name"] == mat2) and ((changes[object] == nil) or (changes[object]["name"] == nil)) then
								objectfound = true
							elseif (changes[object] ~= nil) then
								if (changes[object]["name"] ~= nil) and (changes[object]["name"] == mat2) then
									objectfound = true
								end
							end
						else
							objectfound = true
						end
						
						if testcond(conds,unit.fixed) and objectfound then
							local ingameid = 0
							if (a == 1) then
								ingameid = id
							elseif (a > 1) then
								ingameid = newid()
							end
							
							addaction(unit.fixed,{"convert",mat2,ingameid,id})
							unit.flags[CONVERTED] = true
						end
					end
				end
			end
		end
	elseif (mat1 == "empty") then
		for a,matdata in pairs(mats) do
			local mat2 = matdata[1]
			local conds = matdata[2]
			
			local objectfound = false
			
			if (unitreference[mat2] ~= nil) and (mat2 ~= "level") then
				local object = unitreference[mat2]
				
				if (tileslist[object]["name"] == mat2) and ((changes[object] == nil) or (changes[object]["name"] == nil)) then
					objectfound = true
				elseif (changes[object] ~= nil) then
					if (changes[object]["name"] ~= nil) and (changes[object]["name"] == mat2) then
						objectfound = true
					end
				end
			elseif (mat2 == "level") then
				objectfound = true
			end

			if (mat2 ~= "empty") and objectfound then
				local convunitmap = {}
				
				for a,unit in pairs(units) do
					local tileid = unit.values[XPOS] + unit.values[YPOS] * roomsizex
					convunitmap[tileid] = 1
				end
				
				for i=0,roomsizex-1 do
					for j=0,roomsizey-1 do
						local empty = 1
						
						local tileid = i + j * roomsizex
						if (convunitmap[tileid] ~= nil) then
							empty = 0
						end
						
						if (layer:get_x(i,j) ~= 255) then
							empty = 0
						end

						if (empty == 1) and testcond(conds,2,i,j) then
							addaction(2,{"emptyconvert",mat2,i,j})
						end
					end
				end
			end
		end
	elseif (mat1 == "level") and dolevels then
		for i,v in ipairs(mats) do
			table.insert(levelconversions, v)
		end
	end
end

function dolevelconversions()
	if (#features > 0) and (generaldata.values[WINTIMER] == 0) then
		local mats = levelconversions
		local mat1 = "level"
		local levelmats = {}
		
		for i,matdata in pairs(mats) do
			local conds = matdata[2]
			local mat2 = matdata[1]
			
			local objectfound = false
			
			if (unitreference[mat2] ~= nil) then
				local object = unitreference[mat2]
				
				if (tileslist[object]["name"] == mat2) and ((changes[object] == nil) or (changes[object]["name"] == nil)) then
					objectfound = true
				elseif (changes[object] ~= nil) then
					if (changes[object]["name"] ~= nil) and (changes[object]["name"] == mat2) then
						objectfound = true
					end
				end
			elseif (mat2 == "error") then
				destroylevel()
			end
			
			if testcond(conds,1) and objectfound then
				table.insert(levelmats, matdata[1])
			end
		end

		if (#levelmats > 0) then
			level_to_convert = {generaldata.strings[CURRLEVEL], levelmats}
			
			local savestring = ""
			for a,b in pairs(levelmats) do
				savestring = savestring .. b .. ","
			end
			
			local upperlevel = leveltree[#leveltree - 1] or generaldata.strings[CURRLEVEL]
			local convertdata = MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts")
			local levelconverts = tonumber(convertdata) or 0
			local idtostore = levelconverts
			
			if (levelconverts == 0) then
				local totalconverts = tonumber(MF_read("save",generaldata.strings[WORLD] .. "_converts","total")) or 0
				MF_store("save",generaldata.strings[WORLD] .. "_converts",tostring(totalconverts),generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert")
				totalconverts = totalconverts + 1
				MF_store("save",generaldata.strings[WORLD] .. "_converts","total",tostring(totalconverts))
			end
			
			if (levelconverts > 0) then
				for a=1,levelconverts do
					local result = string.find(MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(a-1)), generaldata.strings[CURRLEVEL])
					
					if (result ~= nil) then
						idtostore = a - 1
					end
				end
			end
			
			MF_store("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(idtostore),generaldata.strings[CURRLEVEL] .. "," .. savestring)
			
			if (idtostore == levelconverts) then
				levelconverts = levelconverts + 1
				
				MF_store("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts",tostring(levelconverts))
			end
			
			uplevel()
			MF_levelconversion()
		end
		
		levelconversions = {}
	end
end

function doconvert(data,extrarule_)
	local style = data[2]
	local mat2 = data[3]
	
	local unitid = data[1]
	local unit = {}
	local x,y,dir,name,id,completed,float = 0,0,0,"",0,0,0
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y,dir,name,id,completed = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.strings[UNITNAME],unit.values[ID],unit.values[COMPLETED]
	end
	
	if (style == "convert") then
		local ingameid = data[4]
		local baseingameid = data[5]
		local delthis = false
		
		if (mat2 ~= "empty") and (mat2 ~= "error") then
			--MF_alert(tostring(id) .. " unit, " .. tostring(data[1]) .. ", name: " .. name .. ", result: " .. tostring(ingameid))
			
			local unitname = unitreference[mat2]
			
			if (mat2 == "level") then
				unitname = "level"
			elseif (mat2 == "cursor") then
				editor.values[NAMEFLAG] = 0
				unitname = "Editor_selector"
			end
			
			if (unitname == nil) then
				MF_alert("no className found for " .. mat2 .. "!")
				return
			end
			
			local newunitid = 0
			
			if (mat2 ~= "cursor") then
				newunitid = MF_emptycreate(unitname,0,0)
			else
				newunitid = MF_specialcreate(unitname)
				setundo(1)
			end
			
			local newunit = mmf.newObject(newunitid)
			
			newunit.values[ONLINE] = 1
			newunit.values[XPOS] = x
			newunit.values[YPOS] = y
			newunit.values[DIR] = dir
			newunit.values[POSITIONING] = 20
			poscorrect(newunitid,generaldata2.values[ROOMROTATION],generaldata2.values[ZOOM],0)
			
			newunit.values[VISUALLEVEL] = unit.values[VISUALLEVEL]
			newunit.values[VISUALSTYLE] = unit.values[VISUALSTYLE]
			newunit.values[COMPLETED] = completed
			
			if (unitname == "level") then
				newunit.values[COMPLETED] = math.max(completed, 1)
				
				if (string.len(unit.strings[LEVELFILE]) > 0) then
					newunit.values[COMPLETED] = math.max(completed, 2)
				end
				
				newunit.strings[COLOUR] = "1,2"
				newunit.strings[CLEARCOLOUR] = "1,3"
				MF_setcolour(newunitid,1,2)
				newunit.visible = true
			end
			
			local simplename = unitname
			if tileslist[unitname].unittype == "text" then
				simplename = "text"
			end
			
			if ingameid == baseingameid then--and findfeature(simplename,"is","persist") ~= nil then
				--print("HECK YOU")
				ingameid = newid()
			end

			newunit.values[ID] = ingameid
			
			newunit.strings[U_LEVELFILE] = unit.strings[U_LEVELFILE]
			newunit.strings[U_LEVELNAME] = unit.strings[U_LEVELNAME]
			newunit.flags[MAPLEVEL] = unit.flags[MAPLEVEL]
			
			newunit.values[EFFECT] = 1
			newunit.flags[9] = true
			newunit.flags[CONVERTED] = true
			
			if (mat2 ~= "cursor") then
				addunit(newunitid)
				addunitmap(newunitid,x,y,newunit.strings[UNITNAME])
				dynamic(newunitid)
			else
				MF_setcolour(newunitid,4,2)
				newunit.visible = true
				newunit.layer = 2
			end

			addundo({"create",newunit.strings[UNITNAME],ingameid,baseingameid})

			if (newunit.strings[UNITTYPE] == "text") then
				updatecode = 1
			elseif (#wordunits > 0) then
				for i,v in ipairs(featureindex["word"]) do
					local rule = v[1]
					if (rule[1] == newunit.strings[UNITNAME]) then
						updatecode = 1
					elseif (unitid ~= 2) then
						if (rule[1] == unit.strings[UNITNAME]) then
							updatecode = 1
						end
					end
				end
			end
			
			delthis = true
		elseif (mat2 == "error") then
			if (unitid ~= 2) then
				local unit = mmf.newObject(unitid)
				local x,y = unit.values[XPOS],unit.values[YPOS]
				local pmult,sound = checkeffecthistory("paradox")
				local c1,c2 = getcolour(unitid)
				MF_particles("unlock",x,y,20 * pmult,c1,c2,1,1)
				--paradox[id] = 1
			end
			
			delthis = true
		else
			if testcond(conds,unit.fixed) then
				updateunitmap(unitid,x,y,x,y,unit.strings[UNITNAME])
				delthis = true
			end
		end
		
		if delthis and (unit.flags[15] == false) then
			addundo({"remove",unit.strings[UNITNAME],unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.values[ID],baseingameid,unit.strings[U_LEVELFILE],unit.strings[U_LEVELNAME],unit.values[VISUALLEVEL],unit.values[COMPLETED],unit.values[VISUALSTYLE],unit.flags[MAPLEVEL],unit.strings[COLOUR],unit.strings[CLEARCOLOUR],gettags(unit)})
			istimeless[unitid] = nil
			
			if (name ~= "cursor") then
				delunit(unitid)
				dynamic(unitid)
				MF_specialremove(unitid,2)
			else
				editor.values[NAMEFLAG] = 0
				MF_cleanspecialremove(unitid)
			end
		end
	elseif (style == "emptyconvert") then
		local i = data[4]
		local j = data[5]
		local unitname = unitreference[mat2]
		local newunitid = MF_emptycreate(unitname,i,j)
		local newunit = mmf.newObject(newunitid)
		
		local id = newid()
		local dir = math.random(0,3)
		
		newunit.values[ONLINE] = 1
		newunit.values[XPOS] = i
		newunit.values[YPOS] = j
		newunit.values[DIR] = dir
		newunit.values[ID] = id
		newunit.values[EFFECT] = 1
		newunit.flags[9] = true
		newunit.flags[CONVERTED] = true
		
		addunit(newunitid)
		addunitmap(newunitid,i,j,newunit.strings[UNITNAME])
		dynamic(newunitid)
		
		addundo({"create",newunit.strings[UNITNAME],id})
		
		if (newunit.strings[UNITTYPE] == "text") then
			updatecode = 1
		elseif (#wordunits > 0) then
			for i,v in ipairs(featureindex["word"]) do
				local rule = v[1]
				if (rule[1] == newunit.strings[UNITNAME]) then
					updatecode = 1
				elseif (unitid ~= 2) then
					if (rule[1] == unit.strings[UNITNAME]) then
						updatecode = 1
					end
				end
			end
		end
	end
end

function handleconvertedlevels(level,mats)
	if (#mats > 0) then
		level_to_convert = {level, mats}
		
		convertlevel()
	end
end

function convertlevel()
	local doundostate = doundo
	doundo = false
	for i,unit in pairs(units) do
		if (unit.className == "level") then
			if (unit.strings[LEVELFILE] == level_to_convert[1]) then
				local mats = level_to_convert[2]
				
				for a,b in ipairs(mats) do
					doconvert({unit.fixed,"convert",b,unit.values[ID]})
				end
			end
		end
	end
	doundo = doundostate
end