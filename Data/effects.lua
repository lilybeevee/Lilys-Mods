function effects(timer)
	doeffect(timer,"win","unlock",1,2,20,{2,4})
	doeffect(timer,"best","unlock",6,30,2,{2,4})
	doeffect(timer,"tele","glow",1,5,20,{1,4})
	doeffect(timer,"hot","hot",1,80,10,{0,1})
	doeffect(timer,"bonus","bonus",1,2,20,{4,1})
	doeffect(timer,"wonder","wonder",1,10,5,{0,3})
	doeffect(timer,"sad","tear",1,2,20,{3,2})
	doeffect(timer,"sleep","sleep",1,2,60,{3,2})
	
	local rnd = math.random(2,4)
	doeffect(timer,"end","unlock",1,1,10,{1,rnd},"inwards")

	if activemod.enabled["live"] then
		doliveturn()
	end
	
	--rnd = math.random(0,2)
	--doeffect(timer,"melt","unlock",1,1,10,{4,rnd},"inwards")
end
	
function doeffect(timer,keyword,particle,count,chance,timing,colour,specialrule_,layer_)
	local zoom = generaldata2.values[ZOOM]
	
	local specialrule = specialrule_ or ""
	local layer = layer_ or 1
	
	if (timer % timing == 0) then
		local this = findfeature(nil,"is",keyword)
		
		local c1 = colour[1]
		local c2 = colour[2]
		
		if (this ~= nil) then
			for k,v in ipairs(this) do
				if (v[1] ~= "empty") and (v[1] ~= "all") and (v[1] ~= "level") then
					local these = findall(v)
					
					if (#these > 0) then
						for a,b in ipairs(these) do
							local unit = mmf.newObject(b)
							local x,y = unit.values[XPOS],unit.values[YPOS]
							if unit.visible then
								for i=1,count do
									local partid = 0
									
									if (chance > 1) then
										if (math.random(chance) == 1) then
											partid = MF_particle(particle,x,y,c1,c2,layer)
										end
									else
										partid = MF_particle(particle,x,y,c1,c2,layer)
									end
									
									if (specialrule == "inwards") and (partid ~= 0) then
										local part = mmf.newObject(partid)
										
										part.values[ONLINE] = 2
										local midx = math.floor(roomsizex * 0.5)
										local midy = math.floor(roomsizey * 0.5)
										local mx = x + 0.5 - midx
										local my = y + 0.5 - midy
										
										local dir = 0 - math.atan2(my, mx)
										local dist = math.sqrt(my ^ 2 + mx ^ 2)
										local roomrad = math.rad(generaldata2.values[ROOMROTATION])
										
										mx = Xoffset + (midx + math.cos(dir + roomrad) * dist * zoom) * tilesize * spritedata.values[TILEMULT]
										my = Yoffset + (midy - math.sin(dir + roomrad) * dist * zoom) * tilesize * spritedata.values[TILEMULT]
										
										part.x = mx + math.random(0-tilesize * 1.5 * zoom,tilesize * 1.5 * zoom)
										part.y = my + math.random(0-tilesize * 1.5 * zoom,tilesize * 1.5 * zoom)
										part.values[XPOS] = part.x
										part.values[YPOS] = part.y
										
										dir = math.pi - math.atan2(part.y - my, part.x - mx)
										dist = math.sqrt((part.y - my)^2 + (part.x - mx)^2)
										part.values[XVEL] = math.cos(dir) * (dist * 0.2)
										part.values[YVEL] = 0 - math.sin(dir) * (dist * 0.2)
									end
								end
							end
						end
					end
				elseif (v[1] == "empty") or (v[1] == "level") then
					if (v[1] ~= "level") or ((v[1] == "level") and testcond(v[2],1)) then
						for i=1,roomsizex-2 do
							for j=1,roomsizey-2 do
								local tileid = i + j * roomsizex
								
								if (unitmap[tileid] == nil) or ((unitmap[tileid] ~= nil) and (#unitmap[tileid] == 0)) then
									for f=1,count do
										local partid = 0
										
										if (chance > 1) then
											if (math.random(chance) == 1) then
												partid = MF_particle(particle,i,j,c1,c2,layer)
											end
										else
											partid = MF_particle(particle,i,j,c1,c2,layer)
										end
										
										if (specialrule == "inwards") and (partid ~= 0) then
											local part = mmf.newObject(partid)
											
											part.values[ONLINE] = 2
											local mx = x * tilesize + tilesize * 0.5
											local my = y * tilesize + tilesize * 0.5
											part.x = Xoffset + mx + math.random(0-tilesize * 1.5,tilesize * 1.5)
											part.y = Yoffset + my + math.random(0-tilesize * 1.5,tilesize * 1.5)
											part.values[XPOS] = part.x
											part.values[YPOS] = part.y
											
											local dir = math.pi - math.atan2(part.y - my, part.x - mx)
											local dist = math.sqrt((part.y - my)^2 + (part.x - mx)^2)
											part.values[XVEL] = math.cos(dir) * (dist * 0.2)
											part.values[YVEL] = 0 - math.sin(dir) * (dist * 0.2)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function domaprotation()
	if (featureindex["level"] ~= nil) then
		for i,v in ipairs(featureindex["level"]) do
			local rule = v[1]
			local conds = v[2]
			
			if testcond(conds,1) then
				if (rule[1] == "level") and (rule[2] == "is") then
					if (rule[3] == "down") then
						addundo({"maprotation",maprotation,0,3})
						maprotation = 0
						mapdir = 3
						MF_levelrotation(maprotation)
					elseif (rule[3] == "right") then
						addundo({"maprotation",maprotation,90,0})
						maprotation = 90
						mapdir = 0
						MF_levelrotation(maprotation)
					elseif (rule[3] == "up") then
						addundo({"maprotation",maprotation,180,1})
						maprotation = 180
						mapdir = 1
						MF_levelrotation(maprotation)
					elseif (rule[3] == "left") then
						addundo({"maprotation",maprotation,270,2})
						maprotation = 270
						mapdir = 2
						MF_levelrotation(maprotation)
					end
				end
			end
		end
	end
end

function levelparticles(name)
	local particletypes =
	{
		bubbles =
		{
			amount = 30,
			animation = 0,
			colour = {1, 0},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[YVEL] = math.random(-3,-1)
					
					unit.scaleX = unit.values[YVEL] * -0.33
					unit.scaleY = unit.values[YVEL] * -0.33
				end,
		},
		soot =
		{
			amount = 30,
			animation = 1,
			colour = {0, 1},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[YVEL] = math.random(-3,-1)
					
					unit.scaleX = unit.values[YVEL] * -0.33
					unit.scaleY = unit.values[YVEL] * -0.33
				end,
		},
		sparks =
		{
			amount = 40,
			animation = 1,
			colour = {2, 3},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[YVEL] = math.random(-3,-1)
					
					unit.scaleX = unit.values[YVEL] * -0.23
					unit.scaleY = unit.values[YVEL] * -0.23
					
					local coloury = math.random(2,4)
					
					MF_setcolour(unitid,2,coloury)
					unit.strings[COLOUR] = tostring(2) .. "," .. tostring(coloury)
				end,
		},
		dust =
		{
			amount = 50,
			animation = 1,
			colour = {1, 0},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[YVEL] = math.random(-3,-1)
					
					unit.scaleX = unit.values[YVEL] * -0.33 * 1.1
					unit.scaleY = unit.values[YVEL] * -0.33 * 1.1
				end,
		},
		snow =
		{
			amount = 30,
			animation = 1,
			colour = {0, 3},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[XVEL] = math.random(-50,-10) * 0.1
					unit.values[YVEL] = math.abs(unit.values[XVEL]) * (math.random(5,15) * 0.1)
					
					unit.scaleX = math.abs(unit.values[XVEL]) * 0.2
					unit.scaleY = math.abs(unit.values[XVEL]) * 0.2
					unit.flags[INFRONT] = true
				end,
		},
		clouds =
		{
			amount = 10,
			animation = 2,
			colour = {0, 3},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.scaleX = 1 + math.random(-30,30) * 0.01
					unit.scaleY = unit.scaleX * 0.9
					
					unit.values[YVEL] = 0 - unit.scaleX
					unit.values[XVEL] = 0 - unit.scaleX
				end,
		},
		smoke =
		{
			amount = 30,
			animation = 3,
			colour = {1, 0},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.angle = math.random(0,359)
					
					unit.scaleX = 1 + math.random(-30,30) * 0.01
					unit.scaleY = unit.scaleX
					
					unit.values[YVEL] = -1
					unit.values[DIR] = math.random(-25,25) * 0.05
				end,
		},
		pollen =
		{
			amount = 20,
			animation = 5,
			colour = {1, 0},
			extra = 
				function(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[XVEL] = math.random(-20,20) * 0.1
					unit.values[YVEL] = math.random(40,80) * 0.05
					
					local size = math.random(2,5)
					unit.scaleX = size * 0.2
					unit.scaleY = size * 0.2
				end,
		},
	}
	
	if (particletypes[name] ~= nil) then
		local data = particletypes[name]
		
		if (data.customfunc == nil) then
			local amount = data.amount
			
			for i=1,amount do
				local unitid = MF_specialcreate("Level_particle")
				local unit = mmf.newObject(unitid)
				
				unit.values[ONLINE] = 1
				unit.x = Xoffset + math.random(0, screenw - 1)
				unit.y = Yoffset + math.random(0, screenh - 1)
				unit.layer = 1
				
				unit.values[XPOS] = unit.x
				unit.values[YPOS] = unit.y
				
				if (data.animation ~= nil) then
					unit.direction = data.animation
				end
				
				if (data.x_velocity ~= nil) then
					unit.values[XVEL] = data.x_velocity
				end
				
				if (data.y_velocity ~= nil) then
					unit.values[YVEL] = data.y_velocity
				end
				
				if (data.colour ~= nil) then
					local c = data.colour
					MF_setcolour(unitid,c[1],c[2])
					
					unit.strings[COLOUR] = tostring(c[1]) .. "," .. tostring(c[2])
				end
				
				unit.values[DIR] = math.random(0,259)
				unit.strings[1] = name
				
				if (data.extra ~= nil) then
					data.extra(unitid)
				end
			end
		else
			data.customfunc()
		end
	else
		print("No particles with name " .. name)
	end
end

function dotransition()
	local sw = screenw * 0.5
	local sh = screenh * 0.5
	
	local mult = 1.5
	
	local initialdistx = sw * mult
	local initialdisty = sh * mult
	
	local xpos = sw
	local ypos = sh
	
	local count = 36
	local increment = 360 / count
	
	for i=0,count-1 do
		local blobid = MF_specialcreate("Transition_blob")
		local blob = mmf.newObject(blobid)
		
		blob.values[ONLINE] = 1
		blob.values[XPOS] = xpos + math.cos(math.rad(increment) * i) * initialdistx
		blob.values[YPOS] = ypos - math.sin(math.rad(increment) * i) * initialdisty
		blob.flags[10] = true
		MF_setcolour(blobid,1,0)
		
		local x,y = blob.values[XPOS],blob.values[YPOS]
		
		local steps = 50
		if (generaldata.values[FASTTRANSITION] == 1) then
			steps = 22.5
		end
		
		local spd = math.sqrt((y - sh) ^ 2 + (x - sw) ^ 2) / steps * 5 + math.random(-9,7)
		
		local dir = 0 - math.atan2(ypos - y,xpos - x)
		blob.values[XVEL] = math.cos(dir) * spd
		blob.values[YVEL] = 0 - math.sin(dir) * spd
		blob.layer = 2
		blob.x = -256
		blob.y = -256
	end
	
	count = 12
	increment = 360 / count
	mult = 1.8
	
	initialdistx = sw * mult
	initialdisty = sh * mult
	
	for i=1,count do
		local blobid = MF_specialcreate("Transition_bigblob")
		local blob = mmf.newObject(blobid)
		
		blob.values[ONLINE] = 1
		blob.values[XPOS] = xpos + math.cos(math.rad(increment) * i) * initialdistx
		blob.values[YPOS] = ypos - math.sin(math.rad(increment) * i) * initialdisty
		blob.flags[10] = true
		MF_setcolour(blobid,1,0)
		
		local x,y = blob.values[XPOS],blob.values[YPOS]
		
		local steps = 72
		if (generaldata.values[FASTTRANSITION] == 1) then
			steps = 36
		end
		
		local spd = math.sqrt((y - sh) ^ 2 + (x - sw) ^ 2) / steps * 5
		
		local dir = 0 - math.atan2(ypos - y,xpos - x)
		blob.values[XVEL] = math.cos(dir) * spd * 1.01
		blob.values[YVEL] = 0 - math.sin(dir) * spd
		blob.layer = 2
		blob.x = -256
		blob.y = -256
		blob.scale = 1.15
	end
	
	count = 4
	local locations = {{-1,-1},{1,-1},{1,1},{-1,1}}
	mult = 1.8
	
	for i=1,count do
		local blobid = MF_specialcreate("Transition_bigblob")
		local blob = mmf.newObject(blobid)
		
		local l = locations[i]
		local lx,ly = l[1],l[2]
		
		blob.values[ONLINE] = 1
		blob.values[XPOS] = sw + lx * sw * mult
		blob.values[YPOS] = sh + ly * sh * mult
		blob.flags[10] = true
		MF_setcolour(blobid,1,0)
		
		local x,y = blob.values[XPOS],blob.values[YPOS]
		
		local steps = 72
		if (generaldata.values[FASTTRANSITION] == 1) then
			steps = 36
		end
		
		local spd = math.sqrt((y - sh) ^ 2 + (x - sw) ^ 2) / steps * 5
		
		local dir = 0 - math.atan2(ypos - y,xpos - x)
		blob.values[XVEL] = math.cos(dir) * spd * 1.01
		blob.values[YVEL] = 0 - math.sin(dir) * spd
		blob.layer = 2
		blob.x = -256
		blob.y = -256
		blob.scale = 1.15
	end
end

function particles(name,x,y,count,colour,layer_,zoom_)
	local layer = layer_ or 1
	local zoom = zoom_ or 1
	
	MF_particles(name,x,y,count,colour[1],colour[2],layer,zoom)
end

function doparticles(name,x,y,count,c1,c2,layer_,zoom_)
	local layer = layer_ or 1
	local zoom = zoom_ or 1
	
	local ax,ay = 0,0
	local rx,ry = 0,0
	local mult = 0
	
	if (zoom == 1) then
		local mtx = roomsizex * 0.5
		local mty = roomsizey * 0.5
		
		local mx = mtx * tilesize * spritedata.values[TILEMULT]
		local my = mty * tilesize * spritedata.values[TILEMULT]
		
		local dx = x - (mtx - 0.5)
		local dy = y - (mty - 0.5)
		
		local dir = 0 - math.atan2(dy, dx)
		local dist = math.sqrt(dy ^ 2 + dx ^ 2)
		
		local roomrotrad = math.rad(generaldata2.values[ROOMROTATION])
		mult = tilesize * spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
		
		ax = Xoffset + mx + (math.cos(dir + roomrotrad) * dist) * mult
		ay = Yoffset + my - (math.sin(dir + roomrotrad) * dist) * mult
	elseif (zoom == 0) then
		ax = Xoffset + x * tilesize + tilesize * 0.5
		ay = Yoffset + y * tilesize + tilesize * 0.5
		
		mult = tilesize
	end
		
	for i=1,count do
		local unitid = MF_effectcreate("effect_" .. name)
		local unit = mmf.newObject(unitid)
		
		rx = math.random(0 - mult * 0.5,mult * 0.5)
		ry = math.random(0 - mult * 0.5,mult * 0.5)
		
		unit.x = ax + rx
		unit.y = ay + ry
		
		MF_setcolour(unitid, c1, c2)
		
		unit.values[XPOS] = -20
		unit.values[YPOS] = -20
		unit.values[24] = ax
		unit.values[25] = ay
		
		unit.layer = layer
		
		if (zoom == 1) then
			unit.scaleX = spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
			unit.scaleY = spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
		end
	end
end

function doliveturn()
	levelmovetimer = levelmovetimer + 1

	local live = findallfeature(nil,"is","live")
	local livecount = {}

	for _,unitid in ipairs(live) do
		if not livecount[unitid] then
			livecount[unitid] = 1
		else
			livecount[unitid] = livecount[unitid] + 1
		end
	end

	local finals = {}
	local hasfinals = false

	for unitid,count in pairs(livecount) do
		local movespeed = math.max(1, math.floor(activemod.live_speed/count))
		if levelmovetimer % movespeed == 0 then
			finals[unitid] = true
			hasfinals = true
		end
	end

	if hasfinals then
		liveunits = finals
		liveturn = true
		movecommand(0,0,4,1)
		MF_update()
	end
end