function savechange(target,params,updateid_)
	local updateid = updateid_ or 0
	
	if (changes[target] == nil) then
		changes[target] = {}
	end
	
	local this = changes[target]
	
	local default = tileslist[target]
	
	if (target == "Editor_levelnum") then
		local icon = params[1]
		local file = params[2]
		local root = params[3]
		
		this[icon] = {}
		local thisdat = this[icon]
		thisdat.file = file
		thisdat.root = root
	else
		local name = params[1]
		local image = params[2]
		local colour = params[3]
		local tiling = params[4]
		local type = params[5]
		local unittype = params[6]
		local activecolour = params[7]
		local root = params[8]
		local layer = params[9]
<<<<<<< HEAD
		local operatortype = params[10]
		local argtype = params[11]
		local argextra = params[12]
=======
		local argtype = params[10]
		local argextra = params[11]
>>>>>>> vanilla
		
		if (name ~= nil) then
			if (string.len(name) > 0) then
				this.name = name
				
				if (name == default.name) then
					this.name = nil
				else
					if (unitreference[default.name] ~= nil) then
						local uid = unitreference[default.name]
						
						unitreference[this.name] = uid
						unitreference[default.name] = nil
					end
				end
			end
		end
		
		if (image ~= nil) then
			if (string.len(image) > 0) then
				this.image = image
				
				if (image == default.sprite) then
					this.image = nil
				end
			end
		end
		
		if (colour ~= nil) then
			if (string.len(colour) > 0) then
				this.colour = colour
				
				if (colour == default.colour) then
					this.colour = nil
				end
			end
		end
		
		if (activecolour ~= nil) then
			if (string.len(activecolour) > 0) then
				this.activecolour = activecolour
				
				if (activecolour == default.active) then
					this.activecolour = nil
				end
			end
		end
		
		if (tiling ~= nil) then
			if (string.len(tiling) > 0) then
				this.tiling = tiling
				
				if (tiling == default.tiling) then
					this.tiling = nil
				end
			end
		end
		
		if (type ~= nil) then
			if (string.len(type) > 0) then
				this.type = type
				
				if (type == default.type) then
					this.type = nil
				end
			end
		end
		
		if (unittype ~= nil) then
			if (string.len(unittype) > 0) then
				this.unittype = unittype
				
				if (unittype == default.unittype) then
					this.unittype = nil
				end
			end
		end
		
		if (root ~= nil) then
			this.root = root
			
			if (root == default.sprite_in_root) then
				this.root = nil
			end
		end
		
		if (layer ~= nil) then
			if (string.len(layer) > 0) then
				this.layer = layer
				
				if (layer == default.layer) then
					this.layer = nil
				end
			end
		end
<<<<<<< HEAD

		if (operatortype ~= nil) then
			if (string.len(operatortype) > 0) then
				this.operatortype = operatortype

				if (operatortype == default.operatortype) then
					this.operatortype = nil
				end
			end
		end

		if (argtype ~= nil) then
			if (string.len(argtype) > 0) then
				local function returntable()
					return load("return " .. argtype)()
				end
				local status,result = pcall(returntable)
				if status then
					this.argtype = result

					local anychanged = false
					if this.argtype ~= nil and default.argtype ~= nil then
						if #this.argtype ~= #default.argtype then
							anychanged = true
						else
							for i,v in ipairs(this.argtype) do
								if default.argtype[i] ~= v then
									anychanged = true
								end
							end
						end
					elseif this.argtype ~= default.argtype then
						anychanged = true
					end

					if not anychanged then
						this.argtype = nil
					end
				else
					print(result)
				end
			end
		end

		if (argextra ~= nil) then
			if (string.len(argextra) > 0) then
				local function returntable()
					return load("return " .. argextra)()
				end
				local status,result = pcall(returntable)
				if status then
					this.argextra = result

					local anychanged = false
					if this.argextra ~= nil and default.argextra ~= nil then
						if #this.argextra ~= #default.argextra then
							anychanged = true
						else
							for i,v in ipairs(this.argextra) do
								if default.argextra[i] ~= v then
									anychanged = true
								end
							end
						end
					elseif this.argextra ~= default.argextra then
						anychanged = true
					end

					if not anychanged then
						this.argextra = nil
					end
				else
					print(result)
=======
		
		if (argtype ~= nil) then
			if (string.len(argtype) > 0) then
				local argtype_ = MF_parsestring(argtype)
				this.argtype = argtype_
				
				local otype = this.type or default.type
				
				if (conditions[target] ~= nil) then
					conditions[target] = {}
					
					if (otype == 7) then
						conddata.arguments = true
						conddata.argtype = default.argtype or {0}
						
						if (default.argextra ~= nil) then
							conddata.argextra = {}
							
							for a,b in ipairs(default.argextra) do
								table.insert(conddata.argextra, b)
							end
						end
					else
						conddata.arguments = false
					end
				end
			end
		end
		
		if (argextra ~= nil) then
			if (string.len(argextra) > 0) then
				local argextra_ = MF_parsestring(argextra)
				this.argextra = argextra_
				
				local isdefault = true
				local defeaultargextra = default.argextra or {}
				
				if (#argextra_ ~= #defeaultargextra) then
					isdefault = false
				else
					for i,v in ipairs(argextra_) do
						local compare = defeaultargextra[i] or ""
						
						if (compare ~= v) then
							isdefault = false
						end
					end
				end
				
				if isdefault then
					this.argextra = nil
>>>>>>> vanilla
				end
			end
		end
	end
	
	if (updateid ~= 0) then
		dochanges(updateid)
	else
		MF_alert("updateid == 0, changes.lua line 124")
	end
end

function changedump(o)
	if type(o) == 'table' then
		local s = '{'
		for k,v in pairs(o) do
			s = s .. changedump(v)
			if k < #o then
				s = s .. ','
			end
		end
		return s .. '}'
	elseif type(o) == 'string' then
		return '"' .. o .. '"'
	else
		return tostring(o)
	end
end

function storechanges()
	local changedobjects = ""

	for target,this in pairs(changes) do
		if (target == "Editor_levelnum") then
			for i,icondata in pairs(this) do
				MF_store("level","icons",tostring(i) .. "file",icondata.file)
				MF_store("level","icons",tostring(i) .. "root",icondata.root)
			end
		else
			for i,thing_ in pairs(this) do
				local thing = thing_
				if type(thing) == "table" then
					thing = changedump(thing)
				end
				MF_store("level","tiles",target .. "_" .. i,thing)
			end
			
			changedobjects = changedobjects .. target .. ","
		end
	end
	
	editor.strings[CHANGEDOBJECTS] = changedobjects
	
	MF_store("level","tiles","changed",changedobjects)
end

function restoredefaults()
	local namesetups = {}
	
	for target,this in pairs(changes) do
		if (target == "Editor_levelnum") then
			for i,icondata in pairs(this) do
				local thisid = MF_create(target)
				MF_defaultsprite(thisid,31,i,"icon")
				MF_cleanremove(thisid)
			end
		else
			local thisid = MF_create(target)
			
			local tiledata = tileslist[target]
			local root = false
			
			if (tiledata.sprite_in_root ~= nil) then
				root = tiledata.sprite_in_root
			end
			
			if (objectcolours[target] ~= nil) then
				objectcolours[target] = nil
			end
			
			if (this.name ~= nil) then
				if (unitreference[this.name] ~= nil) then
					local uid = unitreference[this.name]
					
					table.insert(namesetups, {tiledata.name, target})
					
					unitreference[tiledata.name] = target
					unitreference[this.name] = nil
				end
			end
			
			if (this.argtype ~= nil) then
				local argtype_ = this.argtype
				local argtype = tiledata.argtype or {0}
				local otype = this.type or tiledata.type
				
				if (conditions[target] ~= nil) then
					conditions[target] = {}
					
					local conddata = conditions[target]
					
					if (otype == 1) or (otype == 3) or (otype == 6) or (otype == 7) then
						conddata.arguments = true
						conddata.argtype = tiledata.argtype or {0}
						
						if (tiledata.argextra ~= nil) then
							conddata.argextra = {}
							
							for a,b in ipairs(tiledata.argextra) do
								table.insert(conddata.argextra, b)
							end
						end
					else
						conddata.arguments = false
					end
				end
			end
			
			MF_restoredefaults(thisid,tiledata.sprite,root)
			MF_cleanremove(thisid)
		end
	end
	
	for i,v in ipairs(namesetups) do
		local name = v[1]
		local uid = v[2]
		unitreference[name] = uid
	end
	
	changes = {}
	
	collectgarbage()
end

function dospritechanges(name)
	if (tileslist[name] ~= nil) then
		local thisid = MF_create(name)
		local tiledata = tileslist[name]

		if (changes[name] ~= nil) then
			local c = changes[name]
			
			local root = false
			if (tiledata.sprite_in_root ~= nil) then
				root = tiledata.sprite_in_root
			end
			
			local croot = root
			if (c.root ~= nil) then
				croot = c.root
			end
			
			if (c.image ~= nil) then
				MF_restoredefaults(thisid,tiledata.sprite,root)
				MF_changesprite(thisid,c.image,croot)
			end
		end
		
		MF_cleanremove(thisid)
	else
		print("No object with name " .. name)
	end
end

function dochanges(unitid)
	local unit = mmf.newObject(unitid)
	
	local realname = unit.className
	local name = unit.strings[UNITNAME]
	local name_ = ""
	
	if (changes[realname] ~= nil) then
		local c = changes[realname]
		
		if (c.name ~= nil) then
			name = c.name
			unit.strings[UNITNAME] = c.name
			
			if (string.sub(c.name, 1, 5) == "text_") then
				name_ = string.sub(c.name, 6)
			else
				name_ = c.name
			end
			
			unit.strings[NAME] = name_
			
			unitreference[name] = realname
		end
		
		if (c.colour ~= nil) then
			local cutoff = 0
			
			for a=1,string.len(c.colour) do
				if (string.sub(c.colour, a, a) == ",") then
					cutoff = a
				end
			end
			
			if (cutoff > 0) then
				local c1 = string.sub(c.colour, 1, cutoff-1)
				local c2 = string.sub(c.colour, cutoff+1)
				
				addobjectcolour(realname,"colour",c1,c2)
			else
				print("New object colour formatted wrong!")
			end
		end
		
		if (c.activecolour ~= nil) then
			local cutoff = 0
			for a=1,string.len(c.activecolour) do
				if (string.sub(c.activecolour, a, a) == ",") then
					cutoff = a
				end
			end
			
			if (cutoff > 0) then
				local c1 = string.sub(c.activecolour, 1, cutoff-1)
				local c2 = string.sub(c.activecolour, cutoff+1)
				
				addobjectcolour(realname,"active",c1,c2)
			else
				print("New object active colour formatted wrong!")
			end
		end
		
		if (c.tiling ~= nil) then
			unit.values[TILING] = tonumber(c.tiling)
		end
		
		if (c.type ~= nil) then
			unit.values[TYPE] = tonumber(c.type)
		end
		
		if (c.unittype ~= nil) then
			unit.strings[UNITTYPE] = c.unittype
		end
		
		if (c.layer ~= nil) then
			unit.values[ZLAYER] = tonumber(c.layer)
		end
	end
end

function dochanges_full(name)
	if (tileslist[name] ~= nil) then
		local changedobjects = ""
		for i,v in pairs(changes) do
			changedobjects = changedobjects .. i .. ","
		end
		
		dospritechanges(name)
		
		editor.strings[CHANGEDOBJECTS] = changedobjects
		
		for i,unit in ipairs(units) do
			if (unit.className == name) then
				dochanges(unit.fixed,name)
				dynamic(unit.fixed)
			end
		end
	else
		print("No object with name " .. name)
	end
end

function resetchanges(unitid)
	local unit = mmf.newObject(unitid)
	local name = unit.className
	
	local tiledata = tileslist[name]
	local root = false
	
	if (tiledata.sprite_in_root ~= nil) then
		root = tiledata.sprite_in_root
	end
	
	if (changes[name] ~= nil) then
		local c = changes[name]
		
		if (c.name ~= nil) then
			local cname = c.name
			local rname = tiledata.name
			unitreference[cname] = nil
			unitreference[rname] = name
		end
		
		changes[name] = nil
	end
	
	if (objectcolours[name] ~= nil) then
		objectcolours[name] = nil
	end
	
	MF_restoredefaults(unitid,tiledata.sprite,root)
	
	getmetadata(unit)
	
	updateunitcolour(unitid,true)
	
	updatecolours(true)
end

function addchange(unitid)
	local unit = mmf.newObject(unitid)
	local name = unit.className
	
	local default = tileslist[name]
	
<<<<<<< HEAD
	local things = {"name","image","colour","tiling","type","unittype","activecolour","root","layer","operatortype","argtype","argextra"}
=======
	local things = {"name","image","colour","tiling","type","unittype","activecolour","root","layer","argtype","argextra"}
>>>>>>> vanilla
	local allchanges = {}
	
	for i,v in ipairs(things) do
		local result = ""
		
		local data = MF_read("level","tiles",name .. "_" .. v)
		
		if (string.len(data) > 0) then
			result = data
		end
		
		if (v == "root") then
			if (string.len(data) > 0) then
				if (data == "1") then
					result = true
				elseif (data == "0") then
					result = false
				else
					MF_alert("Root contains garbage data in addchange() for " .. default.name)
				end
			else
				result = default.sprite_in_root
			end
		end
		
		table.insert(allchanges, result)
	end
	
	savechange(name,allchanges,unitid)
end