function movecommand(ox,oy,dir_,playerid_)
	wastimeless = timelessturn
	timelessturn = false

	local statusblockids = nil
	if autoturn then
		statusblockids = {}
		for id,v in pairs(autounits) do
			if id ~= 3 and id ~= 2 and id ~= 1 then
				table.insert(statusblockids, id)
			end
		end
	end

	if autoturn then
		timelessturn = wastimeless or false
	elseif dir_ ~= 4 then
		timelessturn = checktimelessturn(playerid_)
	end

	local timelessdelcopy = {}
	for _,v in ipairs(timelessdels) do
		table.insert(timelessdelcopy, v)
	end
	addundo({"timeless","delete",timelessdelcopy})

	if wastimeless ~= timelessturn then
		updatecode = 1
		updateundo = true
	end

	autoignored = {}
	chosenany = {}

	statusblock(statusblockids)

	movelist = {}
	hasmoved = {}
	
	local take = 1
	local takecount = 3
	local finaltake = false
	
	local still_moving = {}
	
	local levelpush = -1
	local levelpull = -1
	local levelmove = findfeature("level","is","you")
	if (levelmove ~= nil) then
		local ndrs = ndirs[dir_ + 1]
		local ox,oy = ndrs[1],ndrs[2]
		
		addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,dir_})
		MF_scrollroom(ox * tilesize,oy * tilesize)
		mapdir = dir_
		updateundo = true
		hasmoved[1] = true
	end

	local turn = findallfeature(nil,"is","turn",true)
	for _,v in ipairs(turn) do
		if v ~= 2 then
			local unit = mmf.newObject(v)
			local turndir = unit.values[DIR]
			if string.lower(activemod.turn_dir) == "cw" then
				turndir = (turndir - 1) % 4
			else
				turndir = (turndir + 1) % 4
			end
			updatedir(unit.fixed,turndir)
		end
	end

	if autocheck(3) and timecheck(3) then
		updategravity(dir_,false)
	end

	local gravitychecks = nil
	gravityfall = findfeature("gravity","is","fall") 
	if gravityfall then
		for a,unit in ipairs(units) do
			local name = getname(unit)

			local isstop = hasfeature(name,"is","stop",unit.fixed)
			local isfall = hasfeature(name,"is","fall",unit.fixed)

			if (not isstop or isfall) and autocheck(unit.fixed) and timecheck(unit.fixed) then
				if not gravitychecks then
					gravitychecks = {}
				end
				table.insert(gravitychecks, unit.fixed)
			end
		end
	end
	
	while (take <= takecount) or finaltake do
		local moving_units = {}
		local been_seen = {}
		
		if (finaltake == false) then
			if (dir_ ~= 4) and (take == 1) then
				local players = {}
				local empty = {}
				local playerid = 1
				
				if (playerid_ ~= nil) then
					playerid = playerid_
				end
				
				if (playerid == 1) then
					players,empty = findallfeature(nil,"is","you")
				elseif (playerid == 2) then
					players,empty = findallfeature(nil,"is","you2")
					
					if (#players == 0) then
						players,empty = findallfeature(nil,"is","you")
					end
				end
				
				for i,v in ipairs(players) do
					local sleeping = false
					
					if (v ~= 2) then
						local unit = mmf.newObject(v)
						
						local unitname = getname(unit)
						local sleep = hasfeature(unitname,"is","sleep",v)
						
						if (sleep ~= nil) then
							sleeping = true
						else
							updatedir(v, dir_)
						end
					else
						local thisempty = empty[i]
						
						for a,b in pairs(thisempty) do
							local x = a % roomsizex
							local y = math.floor(a / roomsizex)
							
							local sleep = hasfeature("empty","is","sleep",2,x,y)
							
							if (sleep ~= nil) then
								thisempty[a] = nil
							end
						end
					end
					
					if (sleeping == false) then
						if (been_seen[v] == nil) then
							local x,y = -1,-1
							if (v ~= 2) then
								local unit = mmf.newObject(v)
								x,y = unit.values[XPOS],unit.values[YPOS]
								
								table.insert(moving_units, {unitid = v, reason = "you", state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
								been_seen[v] = #moving_units
								autoignored[v] = true
							else
								local thisempty = empty[i]
								
								for a,b in pairs(thisempty) do
									x = a % roomsizex
									y = math.floor(a / roomsizex)
								
									table.insert(moving_units, {unitid = 2, reason = "you", state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
									been_seen[v] = #moving_units
									autoignored[v] = true
								end
							end
						else
							local id = been_seen[v]
							local this = moving_units[id]
							--this.moves = this.moves + 1
						end
					end
				end
			end
			
			if (take == 2) then
				local movers,mempty = findallfeature(nil,"is","move")
				moving_units,been_seen = add_moving_units("move",movers,moving_units,been_seen,mempty)
				
				local chillers,cempty = findallfeature(nil,"is","chill")
				moving_units,been_seen = add_moving_units("chill",chillers,moving_units,been_seen,cempty)
				
				local fears,empty = findallfeature(nil,"fear",nil)
				
				for i,v in ipairs(fears) do
					local valid,feardir = findfears(v)
					local sleeping = false
					
					if valid then
						if (v ~= 2) then
							local unit = mmf.newObject(v)
						
							local unitname = getname(unit)
							local sleep = hasfeature(unitname,"is","sleep",v)
							
							if (sleep ~= nil) then
								sleeping = true
							else
								updatedir(v, feardir)
							end
						else
							local thisempty = empty[i]
							
							for a,b in pairs(thisempty) do
								local x = a % roomsizex
								local y = math.floor(a / roomsizex)
								
								local sleep = hasfeature("empty","is","sleep",2,x,y)
								
								if (sleep ~= nil) then
									thisempty[a] = nil
								end
							end
						end
						
						if (sleeping == false) then
							if (been_seen[v] == nil) then
								local x,y = -1,-1
								if (v ~= 2) then
									local unit = mmf.newObject(v)
									x,y = unit.values[XPOS],unit.values[YPOS]
									
									table.insert(moving_units, {unitid = v, reason = "you", state = 0, moves = 1, dir = feardir, xpos = x, ypos = y})
									been_seen[v] = #moving_units
								else
									local thisempty = empty[i]
								
									for a,b in pairs(thisempty) do
										x = a % roomsizex
										y = math.floor(a / roomsizex)
									
										table.insert(moving_units, {unitid = 2, reason = "you", state = 0, moves = 1, dir = feardir, xpos = x, ypos = y})
										been_seen[v] = #moving_units
									end
								end
							else
								local id = been_seen[v]
								local this = moving_units[id]
								this.moves = this.moves + 1
							end
						end
					end
				end

				-- BAIT AND LURE START
				local lures = findallfeature(nil,"is","lure",true)

				for i,id in ipairs(lures) do
					local baited = getlured(id)

					if (baited ~= -1) then
						updatedir(id, baited)

						if (been_seen[id] == nil) then
							local unit = mmf.newObject(id)
							local x,y = unit.values[XPOS],unit.values[YPOS]

							table.insert(moving_units, {unitid = id, reason = "bait", state = 0, moves = 1, dir = baited, xpos = x, ypos = y})
							been_seen[id] = #moving_units
						else
							local this = moving_units[been_seen[id]]
							this.moves = this.moves + 1
						end
					end
				end
				-- BAIT AND LURE END
			elseif (take == 3) then
				local shifts = findallfeature(nil,"is","shift",true)
				
				for i,v in ipairs(shifts) do
					if (v ~= 2) and autocheck(v) and timecheck(v) then
						local affected = {}
						local unit = mmf.newObject(v)
						
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local tileid = x + y * roomsizex
						
						if (unitmap[tileid] ~= nil) then
							if (#unitmap[tileid] > 1) then
								for a,b in ipairs(unitmap[tileid]) do
									if (b ~= v) and floating(b,v) then
										local newunit = mmf.newObject(b)
										
										updatedir(b, unit.values[DIR])
										--newunit.values[DIR] = unit.values[DIR]
										
										if (been_seen[b] == nil) then
											table.insert(moving_units, {unitid = b, reason = "shift", state = 0, moves = 1, dir = unit.values[DIR], xpos = x, ypos = y})
											been_seen[b] = #moving_units
										else
											local id = been_seen[b]
											local this = moving_units[id]
											this.moves = this.moves + 1
										end
									end
								end
							end
						end
					end
				end
				
				local levelshift = findfeature("level","is","shift")
				
				if (levelshift ~= nil) and autocheck(1) and timecheck(1) then
					local leveldir = mapdir
						
					for a,unit in ipairs(units) do
						local x,y = unit.values[XPOS],unit.values[YPOS]
						
						if floating_level(unit.fixed) then
							updatedir(unit.fixed, leveldir)
							table.insert(moving_units, {unitid = unit.fixed, reason = "shift", state = 0, moves = 1, dir = unit.values[DIR], xpos = x, ypos = y})
						end
					end
				end

				local gravityshift = findfeature("gravity","is","shift")

				if gravityshift and timecheck(3) then
					local gshifts = {}
					if gravitychecks then
						for i,v in ipairs(gravitychecks) do
							table.insert(gshifts, v)
						end
					else
						local falls = findallfeature(nil,"is","fall",true)
						for i,v in ipairs(falls) do
							if v ~= 2 then
								table.insert(gshifts, v)
							end
						end
					end

					for i,v in ipairs(gshifts) do
						local unit = mmf.newObject(v)
						local x,y = unit.values[XPOS],unit.values[YPOS]

						updatedir(v, gravitydir)

						if not been_seen[v] then
							table.insert(moving_units, {unitid = v, reason = "gravity", state = 0, moves = 1, dir = gravitydir, xpos = x, ypos = y})
							been_seen[v] = #moving_units
						else
							local id = been_seen[v]
							local this = moving_units[id]
							this.moves = this.moves + 1
						end
					end
				end
			end
		else
			for i,data in ipairs(still_moving) do
				if (data.unitid ~= 2) then
					local unit = mmf.newObject(data.unitid)
					
					table.insert(moving_units, {unitid = data.unitid, reason = data.reason, state = data.state, moves = data.moves, dir = unit.values[DIR], xpos = unit.values[XPOS], ypos = unit.values[YPOS]})
				else
					table.insert(moving_units, {unitid = data.unitid, reason = data.reason, state = data.state, moves = data.moves, dir = data.dir, xpos = -1, ypos = -1})
				end
			end
			
			still_moving = {}
		end
		
		local unitcount = #moving_units

		local alreadycopied = {}
		for i,data in ipairs(moving_units) do
			if i <= unitcount then
				local name = ""
				local dir = data.dir
				if data.unitid ~= 2 then
					local unit = mmf.newObject(data.unitid)
					name = getname(unit)
					dir = unit.values[DIR]
				else
					name = "empty"
				end
				local copycats = findcopycats(name)
				for _,v in ipairs(copycats) do
					local x,y = -1,-1
					if v ~= 2 then
						updatedir(data.unitid, dir)
					end
					table.insert(moving_units, {unitid = v, reason = "copy", state = 4, moves = data.moves, dir = dir, xpos = x, ypos = y, copy = data.unitid})
					if autocheck(data.unitid,autoignored) then
						autoignored[v] = true
					end
				end
			end
		end

		unitcount = #moving_units
			
		for i,data in ipairs(moving_units) do
			if (i <= unitcount) then
				if (data.unitid == 2) and (data.xpos == -1) and (data.ypos == -1) then
					local positions = getemptytiles()
					
					for a,b in ipairs(positions) do
						local x,y = b[1],b[2]
						table.insert(moving_units, {unitid = 2, reason = data.reason, state = data.state, moves = data.moves, dir = data.dir, xpos = x, ypos = y})
					end
				end
			else
				break
			end
		end

		local new_moving_units = {}
		for i,data in ipairs(moving_units) do
			if data.reason == "shift" or (data.reason == "you" and timecheck(data.unitid)) or (data.reason == "copy" and autocheck(data.copy) and timecheck(data.unitid)) or (data.reason == "gravity" and autocheck(3) and timecheck(3)) or (autocheck(data.unitid) and timecheck(data.unitid)) then
				table.insert(new_moving_units, data)
			end
		end
		moving_units = new_moving_units
		
		local done = false
		local state = 0
		
		local newdirs = {}
		while (done == false) do
			local smallest_state = 99
			local delete_moving_units = {}
			
			for i,data in ipairs(moving_units) do
				local solved = false
				smallest_state = math.min(smallest_state,data.state)
				
				if (data.unitid == 0) then
					solved = true
				end
				
				if (data.state == state) and (data.moves > 0) and (data.unitid ~= 0) then
					local unit = {}
					local dir,name = 4,""
					local x,y = data.xpos,data.ypos
					
					if (data.unitid ~= 2) then
						unit = mmf.newObject(data.unitid)
						dir = unit.values[DIR]
						name = getname(unit)
						x,y = unit.values[XPOS],unit.values[YPOS]
					else
						dir = data.dir
						name = "empty"
					end
					
					if (x ~= -1) and (y ~= -1) then
						local result = -1
						solved = false
						
						if (state == 0) then
							if (data.reason == "chill") then
								dir = math.random(0,3)
								
								if (data.unitid ~= 2) then
									updatedir(data.unitid, dir)
									--unit.values[DIR] = dir
								end
							end
							
							if (data.reason == "move") and (data.unitid == 2) then
								dir = math.random(0,3)
							end
						elseif (state == 3) then
							if ((data.reason == "move") or (data.reason == "chill")) then
								dir = rotate(dir)
								
								if (data.unitid ~= 2) then
									updatedir(data.unitid, dir)
									--unit.values[DIR] = dir
								end
							end
						end

						if data.reason == "copy" then
							if newdirs[data.copy] ~= nil then
								dir = newdirs[data.copy]

								if data.unitid ~= 2 then
									updatedir(data.unitid, dir)
								end
							end
						end

						newdirs[data.unitid] = dir
						

						local ndrs = ndirs[dir + 1]
						local ox,oy = ndrs[1],ndrs[2]
						local pushobslist = {}

						local allsticky,pushsticky,pullsticky,stickyresult = stickycheck(data.unitid,dir,false,data.unitid)
						local doingsticky = #allsticky > 0 or result == 1
						
						local obslist,allobs,specials,pushids = {},{},{},{}
						local pullobs,pullallobs,pullspecials,pullids = {},{},{},{}

						if not doingsticky then
							obslist,allobs,specials = check(data.unitid,x,y,dir,false,data.reason)
							pullobs,pullallobs,pullspecials = check(data.unitid,x,y,dir,true,data.reason)
						else
							for _,v in ipairs(pushsticky) do
								local newobs,allnewobs,newspecials = check(v[1],v[2],v[3],dir,false,data.reason)
								for c,d in ipairs(newobs) do
									if stickyresult == 1 then
										table.insert(obslist, 1)
									else
										table.insert(obslist, d)
									end
									table.insert(pushids, v[1])
								end
								for c,d in ipairs(allnewobs) do
									table.insert(allobs, d)
								end
								for c,d in ipairs(newspecials) do
									table.insert(specials, d)
								end
							end
							for _,v in ipairs(pullsticky) do
								local newobs,allnewobs,newspecials = check(v[1],v[2],v[3],dir,true,data.reason)
								for c,d in ipairs(newobs) do
									if stickyresult == 1 then
										table.insert(pullobs, 1)
									else
										table.insert(pullobs, d)
									end
									table.insert(pullids, v[1])
								end
								for c,d in ipairs(allnewobs) do
									table.insert(pullallobs, d)
								end
								for c,d in ipairs(newspecials) do
									table.insert(pullspecials, d)
								end
							end
						end
						
						local swap = hasfeature(name,"is","swap",data.unitid,x,y)
						local ignoreweak = true
						
						for c,obs in pairs(obslist) do
							if (solved == false) then
								if (obs == 0) then
									if (state == 0) then
										result = math.max(result, 0)
									else
										result = math.max(result, 0)
									end
								elseif (obs == -1) then
									result = math.max(result, 2)
									
									local levelpush_ = findfeature("level","is","push")
									local levelsoft = hasfeature("level","is","soft",1)
									
									if (levelpush_ ~= nil) then
										for e,f in ipairs(levelpush_) do
											if testcond(f[2],1) then
												levelpush = dir
											end
										end
									end

									if not levelsoft then
										ignoreweak = false
									end
								else
									if (swap == nil) then
										if (#allobs == 0) then
											obs = 0
										end
										
										if (obs == 1) then
											local thisobs = allobs[c]
											local solid = true
											local soft = false

											for f,g in pairs(specials) do
												if (g[1] == thisobs) and (g[2] == "soft") then
													soft = true
												end
											end
											
											for f,g in pairs(specials) do
												if ((g[1] == thisobs) and not soft) or (g[1] == pushids[c]) and (g[2] == "weak") then
													solid = false
													obs = 0
													result = math.max(result, 0)
												end
											end
											
											if solid then
												if not soft then
													ignoreweak = false
												end
												if (state < 2) then
													data.state = math.max(data.state, 2)
													result = math.max(result, 2)
												else
													result = math.max(result, 2)
												end
											end
										else
											if (state < 1) then
												data.state = math.max(data.state, 1)
												result = math.max(result, 1)
											else
												table.insert(pushobslist, obs)
												result = math.max(result, 1)
											end
										end
									else
										result = math.max(result, 0)
									end
								end
							end
						end
						
						local result_check = false
						
						while (result_check == false) and (solved == false) do
							if (result == 0) then
								if (state > 0) then
									for j,jdata in pairs(moving_units) do
										if (jdata.state >= 2) then
											jdata.state = 0
										end
									end
								end
								
								table.insert(movelist, {data.unitid,ox,oy,dir,specials})

								for _,v in ipairs(allsticky) do
									table.insert(movelist, {v[1],ox,oy,dir,specials})
								end
								--move(data.unitid,ox,oy,dir,specials)
								
								local swapped = {}
								
								if (swap ~= nil) then
									for a,b in ipairs(allobs) do
										if (b ~= -1) and (b ~= 2) and (b ~= 0) then
											addaction(b,{"update",x,y,nil})
											swapped[b] = 1
										end
									end
								end
								
								local swaps = findfeatureat(nil,"is","swap",x+ox,y+oy)
								if (swaps ~= nil) then
									for a,b in ipairs(swaps) do
										if (swapped[b] == nil) then
											addaction(b,{"update",x,y,nil})
										end
									end
								end
								
								local finalpullobs = {}
								
								for c,pobs in ipairs(pullobs) do
									if (pobs < -1) or (pobs > 1) then
										local paobs = pullallobs[c]
										local pullid = pullids[c] or data.unitid
										
										local hm = trypush(paobs,ox,oy,dir,true,x,y,data.reason,pullid)
										--babaprint("pull: " .. hm)
										if (hm == 0) then
											table.insert(finalpullobs, {paobs, pullid})
										end
									elseif (pobs == -1) then
										local levelpull_ = findfeature("level","is","pull")
									
										if (levelpull_ ~= nil) then
											for e,f in ipairs(levelpull_) do
												if testcond(f[2],1) then
													levelpull = dir
												end
											end
										end
									end
								end
								
								for c,pobs in ipairs(finalpullobs) do
									pushedunits = {}
									dopush(pobs[1],ox,oy,dir,true,x,y,data.reason,pobs[2])
								end
								
								solved = true
							elseif (result == 1) then
								if (state < 1) then
									data.state = math.max(data.state, 1)
									result_check = true
								else
									local finalpushobs = {}
									
									for c,pushobs in ipairs(pushobslist) do
										local hm = trypush(pushobs,ox,oy,dir,false,x,y,data.reason)
										if (hm == 0) then
											table.insert(finalpushobs, pushobs)
										elseif (hm == 1) or (hm == -1) then
											result = math.max(result, 2)
										else
											MF_alert("HOO HAH")
											return
										end
									end
									
									if (result == 1) then
										for c,pushobs in ipairs(finalpushobs) do
											pushedunits = {}
											dopush(pushobs,ox,oy,dir,false,x,y,data.reason)
										end
										result = 0
									end
								end
							elseif (result == 2) then
								if (state < 2) then
									data.state = math.max(data.state, 2)
									result_check = true
								else
									if (state < 3) then
										data.state = math.max(data.state, 3)
										result_check = true
									else
										if ((data.reason == "move") or (data.reason == "chill")) and (state < 4) then
											data.state = math.max(data.state, 4)
											result_check = true
										else
											local weak = hasfeature(name,"is","weak",data.unitid,x,y)
											
											if (weak ~= nil) and not ignoreweak then
												delete(data.unitid,x,y)
												generaldata.values[SHAKE] = 3
												
												local pmult,sound = checkeffecthistory("weak")
												MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
												setsoundname("removal",1,sound)
												data.moves = 1
											end
											solved = true
										end
									end
								end
							else
								result_check = true
							end
						end
					else
						solved = true
					end
				end
				
				if solved then
					data.moves = data.moves - 1
					data.state = 10
					
					local tunit = mmf.newObject(data.unitid)

					if (data.moves <= 0) then
						--print(tunit.strings[UNITNAME] .. " - removed from queue")
						table.insert(delete_moving_units, i)
					else
						if (data.unitid ~= 2) or ((data.unitid == 2) and (data.xpos == -1) and (data.ypos == -1)) then
							table.insert(still_moving, {unitid = data.unitid, reason = data.reason, state = data.state, moves = data.moves, dir = data.dir, xpos = data.xpos, ypos = data.ypos})
						end
						--print(tunit.strings[UNITNAME] .. " - removed from queue")
						table.insert(delete_moving_units, i)
					end
				end
			end
			
			local deloffset = 0
			for i,v in ipairs(delete_moving_units) do
				local todel = v - deloffset
				table.remove(moving_units, todel)
				deloffset = deloffset + 1
			end
			
			if (#movelist > 0) then
				for i,data in ipairs(movelist) do
					hasmoved[data[1]] = true
					move(data[1],data[2],data[3],data[4],data[5])
				end
			end
			
			movelist = {}
			
			if (smallest_state > state) then
				state = state + 1
			else
				state = smallest_state
			end
			
			if (#moving_units == 0) then
				doupdate()
				done = true
			end
		end

		if (#still_moving > 0) then
			finaltake = true
			moving_units = {}
		else
			finaltake = false
		end
		
		if (finaltake == false) then
			take = take + 1
		end
	end
	
	if (levelpush >= 0) then
		local ndrs = ndirs[levelpush + 1]
		local ox,oy = ndrs[1],ndrs[2]
		
		mapdir = levelpush
		
		addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,levelpush})
		MF_scrollroom(ox * tilesize,oy * tilesize)
		updateundo = true
		hasmoved[1] = true
	end
	
	if (levelpull >= 0) then
		local ndrs = ndirs[levelpull + 1]
		local ox,oy = ndrs[1],ndrs[2]
		
		mapdir = levelpush
		
		addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,levelpull})
		MF_scrollroom(ox * tilesize,oy * tilesize)
		updateundo = true
		hasmoved[1] = true
	end
	
	if hasfeature("level","is","turn",1) and autocheck(1) then
		addundo({"maprotation",maprotation,mapdir})
		if string.lower(activemod.turn_dir) == "cw" then
			mapdir = (mapdir - 1) % 4
		else
			mapdir = (mapdir + 1) % 4
		end
		if mapdir == 3 then
			maprotation = 0
		elseif mapdir == 0 then
			maprotation = 90
		elseif mapdir == 1 then
			maprotation = 180
		elseif mapdir == 2 then
			maprotation = 270
		end
		MF_levelrotation(maprotation)
		updateundo = true
	end

	updatestill()
	doupdate()
	updatetimeless()
	code()
	updategravity(dir_,true)
	domaprotation()
	conversion()
	doupdate()
	updatetimeless()
	code()
	updategravity(dir_,true)
	domaprotation()
	moveblock()
	
	if (dir_ ~= nil) then
		MF_mapcursor(ox,oy,dir_)
	end
end

function updatestill()
	local haschanged = false
	for _,unit in ipairs(units) do
		if autocheck(unit.fixed,autoignored) and timecheck(unit.fixed) then
			local newstill = not (hasmoved[unit.fixed] or false)
			if settag(unit.fixed,"still",newstill,true) then
				haschanged = true
			end
		end
	end
	for i=1,3 do
		if autocheck(i,autoignored) and timecheck(i) then
			local newstill = not (hasmoved[i] or false)
			if settag(i,"still",newstill,true) then
				haschanged = true
			end
		end
	end
	if haschanged then
		forceupdateundo = true
	end
end

function check(unitid,x,y,dir,pulling_,reason)
	local pulling = false
	if (pulling_ ~= nil) then
		pulling = pulling_
	end
	
	local dir_ = dir
	if pulling then
		dir_ = rotate(dir)
	end
	
	local ndrs = ndirs[dir_ + 1]
	local ox,oy = ndrs[1],ndrs[2]
	
	local result = {}
	local results = {}
	local specials = {}
	
	local emptystop = hasfeature("empty","is","stop",2,x+ox,y+oy)
	local emptypush = hasfeature("empty","is","push",2,x+ox,y+oy)
	local emptypull = hasfeature("empty","is","pull",2,x+ox,y+oy)
	local emptyswap = hasfeature("empty","is","swap",2,x+ox,y+oy)
	
	local unit = {}
	local name = ""
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		name = getname(unit)
	else
		name = "empty"
	end
	
	local lockpartner = ""
	local open = hasfeature(name,"is","open",unitid,x,y)
	local shut = hasfeature(name,"is","shut",unitid,x,y)
	local eat = hasfeature(name,"eat",nil,unitid,x,y)
	local sticky = hasfeature(name,"is","sticky",unitid,x,y)
	
	if (open ~= nil) then
		lockpartner = "shut"
	elseif (shut ~= nil) then
		lockpartner = "open"
	end
	
	local obs = findobstacle(x+ox,y+oy)
	
	if (#obs > 0) then
		for i,id in ipairs(obs) do
			if (id == -1) then
				table.insert(result, -1)
				table.insert(results, -1)

				if hasfeature("level","is","soft",1) then
					table.insert(specials, {-1, "soft"})
				end
			else
				local obsunit = mmf.newObject(id)
				local obsname = getname(obsunit)
				
				local alreadymoving = findupdate(id,"update")
				local valid = true
				
				local localresult = 0

				local issticky = hasfeature(obsname,"is","sticky",id)
				local stickyconnect = false

				if sticky and issticky then
					stickyconnect = true
				end
				
				if (#alreadymoving > 0) then
					for a,b in ipairs(alreadymoving) do
						local nx,ny = b[3],b[4]
						
						if ((nx ~= x) and (ny ~= y)) and ((reason == "shift") and (pulling == false)) then
							valid = false
						end
						
						if ((nx == x) and (ny == y + oy * 2)) or ((ny == y) and (nx == x + ox * 2)) then
							valid = false
						end
					end
				end
				
				local weak = hasfeature(obsname,"is","weak",id)
				local selfweak = hasfeature(name,"is","weak",unitid)

				if not stickyconnect then
					if (lockpartner ~= "") and (pulling == false) then
						local partner = hasfeature(obsname,"is",lockpartner,id)
						
						if (partner ~= nil) and ((issafe(id) == false) or (issafe(unitid) == false)) and (floating(id, unitid)) and ((lockpartner == "shut" and timecheck(unitid)) or (lockpartner == "open" and timecheck(id))) then
							valid = false
							table.insert(specials, {id, "lock"})
						end
					end
					
					if (eat ~= nil) and (pulling == false) then
						local eats = hasfeature(name,"eat",obsname,unitid)
						
						if (eats ~= nil) and (issafe(id) == false) and timecheck(unitid) then
							valid = false
							table.insert(specials, {id, "eat"})
						end
					end
					
					if (weak ~= nil) and (pulling == false) then
						if (issafe(id) == false) and (issoft(unitid) == false) and timecheck(id) then
							--valid = false
							table.insert(specials, {id, "weak"})
						end
					elseif sticky and selfweak and not pulling then
						if (issafe(unitid) == false) and (issoft(id) == false) then
							--valid = false
							table.insert(specials, {unitid, "weak"})
						end
					end

					if issoft(id) and not pulling then
						table.insert(specials, {id, "soft"})
					end
				end
				
				local added = false
				
				if valid then
					--MF_alert("checking for solidity for " .. obsname .. " by " .. name .. " at " .. tostring(x) .. ", " .. tostring(y))
					
					local isstop = hasfeature(obsname,"is","stop",id)
					local ispush = hasfeature(obsname,"is","push",id)
					local ispull = hasfeature(obsname,"is","pull",id)
					local isswap = hasfeature(obsname,"is","swap",id)
					
					--MF_alert(obsname .. " -- stop: " .. tostring(isstop) .. ", push: " .. tostring(ispush))
					
					if (isstop ~= nil) and (obsname == "level") and (obsunit.visible == false) then
						isstop = nil
					end
					
					if (((isstop ~= nil) and (ispush == nil) and ((ispull == nil) or ((ispull ~= nil) and (pulling == false)))) or ((ispull ~= nil) and (pulling == false) and (ispush == nil))) and (isswap == nil) then
						if (weak == nil) or issoft(unitid) then
							table.insert(result, 1)
							table.insert(results, id)
							localresult = 1
							added = true
						end
					end
					
					if (localresult ~= 1) and (localresult ~= -1) then
						if (ispush ~= nil) and (pulling == false) and (isswap == nil) then
							--MF_alert(obsname .. " added to push list")
							table.insert(result, id)
							table.insert(results, id)
							added = true
						end
						
						if (ispull ~= nil) and pulling then
							table.insert(result, id)
							table.insert(results, id)
							added = true
						end
					end
				end
				
				if (added == false) then
					table.insert(result, 0)
					table.insert(results, id)
				end
			end
		end
	else
		local localresult = 0
		local valid = true
		local bname = "empty"
		
		if (eat ~= nil) and (pulling == false) then
			local eats = hasfeature(name,"eat",bname,unitid,x+ox,y+oy)
			
			if (eats ~= nil) and (issafe(2,x+ox,y+oy) == false) and timecheck(unitid) then
				valid = false
				table.insert(specials, {2, "eat"})
			end
		end
		
		if (lockpartner ~= "") and (pulling == false) then
			local partner = hasfeature(bname,"is",lockpartner,2,x+ox,y+oy)
			
			if (partner ~= nil) and ((issafe(2,x+ox,y+oy) == false) or (issafe(unitid) == false)) and ((lockpartner == "shut" and timecheck(unitid)) or (lockpartner == "open" and timecheck(2,x+ox,y+oy))) then
				valid = false
				table.insert(specials, {2, "lock"})
			end
		end
		
		local weak = hasfeature(bname,"is","weak",2,x+ox,y+oy)
		if (weak ~= nil) and (pulling == false) then
			if (issafe(2,x+ox,y+oy) == false) and (issoft(unitid) == false) and timecheck(2,x+ox,y+oy) then
				--valid = false
				table.insert(specials, {2, "weak"})
			end
		end
		
		local added = false
		
		if valid and (emptyswap == nil) then
			if (emptystop ~= nil) or ((emptypull ~= nil) and (pulling == false)) then
				localresult = 1
				table.insert(result, 1)
				table.insert(results, 2)
				added = true
			end
			
			if (localresult ~= 1) then
				if (emptypush ~= nil) or ((emptypull ~= nil) and pulling) then
					table.insert(result, 2)
					table.insert(results, 2)
				end
				added = true
			end
		end
		
		if (added == false) then
			table.insert(result, 0)
			table.insert(results, 2)
		end
	end
	
	if (#results == 0) then
		result = {0}
		results = {0}
	end
	
	return result,results,specials
end

function trypush(unitid,ox,oy,dir,pulling_,x_,y_,reason,pusherid,stickied_)
	local x,y = 0,0
	local unit = {}
	local name = ""
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y = unit.values[XPOS],unit.values[YPOS]
		name = getname(unit)
	else
		x = x_
		y = y_
		name = "empty"
	end
	
	local pulling = pulling_ or false
	local stickied = stickied_ or {}
	
	local sticky = hasfeature(name,"is","sticky",unitid,x_,y_)
	local weak = hasfeature(name,"is","weak",unitid,x_,y_)
	local soft = hasfeature(name,"is","soft",unitid,x_,y_)

	if not stickied[unitid] then
		local fulllist,pushlist,pulllist,result_ = stickycheck(unitid,dir,pulling)
		if #fulllist > 0 then
			if result_ == 1 and (not weak or pulling) then
				return 1
			end

			pushdir = dir

			local pushndrs = ndirs[pushdir + 1]
			local pushox,pushoy = pushndrs[1],pushndrs[2]

			--local pullndrs = ndirs[pulldir + 1]
			--local pullox,pulloy = pullndrs[1],pullndrs[2]

			local stuck = {}
			for i,v in pairs(stickied) do
				stuck[i] = v
			end
			for _,v in ipairs(fulllist) do
				stuck[v[1]] = true
			end

			local result = 0
			for _,push in ipairs(pushlist) do
				result = math.max(result, trypush(push[1],pushox,pushoy,pushdir,false,push[2],push[3],reason,pusherid,stuck))
			end

			if weak and not pulling then
				result = 0
			end

			return result
		end
	end

	local result = 0
	local ignoreweak = true

	local hmlist,hms,specials = check(unitid,x,y,dir,false,reason)
	
	for i,hm in pairs(hmlist) do
		local done = false
		
		while (done == false) do
			if (hm == 0) then
				result = math.max(0, result)
				done = true
			elseif (hm == 1) or (hm == -1) then
				if (pulling == false) or ((pulling or sticky) and (hms[i] ~= pusherid)) then
					result = math.max(1, result)
					done = true

					local soft = false
					for _,v in ipairs(specials) do
						if v[1] == hms[i] and v[2] == "soft" then
							soft = true
						end
					end

					if not soft then
						ignoreweak = false
					end
				else
					result = math.max(0, result)
					done = true
				end
			else
				if (not pulling and not sticky) or ((pulling or sticky) and (hms[i] ~= pusherid)) then
					hm = trypush(hm,ox,oy,dir,pulling,x+ox,y+oy,reason,unitid,stickied)
				else
					result = math.max(0, result)
					done = true
				end
			end
		end
	end

	if weak and not pulling and not ignoreweak then
		return 0
	else
		return result
	end
end

function dopush(unitid,ox,oy,dir,pulling_,x_,y_,reason,pusherid,stickied_,stickyspecials)
	local pid2 = tostring(ox + oy * roomsizex) .. tostring(unitid)
	pushedunits[pid2] = 1
	
	local x,y = 0,0
	local unit = {}
	local name = ""
	local pushsound = false
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y = unit.values[XPOS],unit.values[YPOS]
		name = getname(unit)
	else
		x = x_
		y = y_
		name = "empty"
	end
	
	local pulling = false
	if (pulling_ ~= nil) then
		pulling = pulling_
	end
	local stickied = stickied_ or {}


	if not stickied[unitid] then
		local fulllist,pushlist,pulllist,result_ = stickycheck(unitid,dir,pulling)
		if #fulllist > 0 then
			if result_ == 1 then
				return 1
			end

			local pushdir = 0
			--local pulldir = 0
			pushdir = dir

			local pushndrs = ndirs[pushdir + 1]
			local pushox,pushoy = pushndrs[1],pushndrs[2]

			--local pullndrs = ndirs[rotate(pushdir) + 1]
			--local pullox,pulloy = pullndrs[1],pullndrs[2]

			local stuck = {}
			for i,v in pairs(stickied) do
				stuck[i] = v
			end
			for _,v in ipairs(fulllist) do
				stuck[v[1]] = true
			end

			local stickyspecials = {}
			local result = 0
			for _,push in ipairs(pushlist) do
				result = math.max(result, dopush(push[1],pushox,pushoy,pushdir,false,push[2],push[3],reason,pusherid,stuck,stickyspecials))
			end 

			if result > 0 then
				if not hasfeature(name,"is","weak",unitid,x,y) then
					local localresult = 0
					for _,v in ipairs(pushlist) do
						local punit = mmf.newObject(v[1])
						local pname = getname(punit)
						local px,py = v[2],v[3]

						if not hasfeature(pname,"is","weak",v[1],px,py) then
							localresult = 1
						end
					end
					if localresult == 0 then
						result = 0
					end
				else
					delete(unitid,x,y)
				
					local pmult,sound = checkeffecthistory("weak")
					setsoundname("removal",1,sound)
					generaldata.values[SHAKE] = 3
					MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
					result = 0
				end
			end

			if result < 1 then
				local moveentry = {}
				for _,v in ipairs(fulllist) do
					moveentry[v[1]] = {v[1],ox,oy,dir,{}}
					table.insert(movelist, moveentry[v[1]])
				end
				local movespecial = {}
				for _,v in ipairs(stickyspecials) do
					movespecial[v[1]] = v[2]
				end
				for _,v in ipairs(pushlist) do
					if movespecial[v[1]] then
						moveentry[v[1]][5] = movespecial[v[1]]
					end
				end
				for _,pull in ipairs(pulllist) do
					local pullobs,pullallobs,pullspecials = check(pull[1],pull[2],pull[3],pushdir,true,reason)
					for i,v in ipairs(pullobs) do
						if v < -1 or v > 1 then
							local paobs = pullallobs[i]

							local hm = trypush(paobs,pushox,pushoy,pushdir,true,pull[2],pull[3],reason,pull[1],stuck)
							if hm == 0 then
								pushedunits = {}
								dopush(paobs,pushox,pushoy,pushdir,true,pull[2],pull[3],reason,pull[1],stuck)
							end
						end
					end
				end
			end

			return result
		end
	end
	
	local swaps = findfeatureat(nil,"is","swap",x+ox,y+oy)
	if (swaps ~= nil) and ((unitid ~= 2) or ((unitid == 2) and (pulling == false))) then
		for a,b in ipairs(swaps) do
			if (pulling == false) or (pulling and (b ~= pusherid)) and timecheck(b) then
				local alreadymoving = findupdate(b,"update")
				local valid = true
				
				if (#alreadymoving > 0) then
					valid = false
				end
				
				if valid then
					addaction(b,{"update",x,y,nil})
				end
			end
		end
	end
	
	if pulling then
		local swap = hasfeature(name,"is","swap",unitid,x,y)
		
		if swap and timecheck(unitid) then
			local swapthese = findallhere(x+ox,y+oy)
			
			for a,b in ipairs(swapthese) do
				local alreadymoving = findupdate(b,"update")
				local valid = true
				
				if (#alreadymoving > 0) then
					valid = false
				end
				
				if valid then
					addaction(b,{"update",x,y,nil})
					pushsound = true
				end
			end
		end
	end

	if not dopushcopy then
		isfirstcopy = true
		dopushcopy = true

		local copycats = findcopycats(name)
		for _,v in ipairs(copycats) do
			if v ~= pusherid then
				local cx,cy = -1,-1
				if v ~= 2 then
					local cunit = mmf.newObject(v)
					local cx,cy = cunit.values[XPOS],cunit.values[YPOS]

					dopush(v,ox,oy,dir,false,cx,cy,unitid)
				else
					local positions = getemptytiles()
							
					for a,b in ipairs(positions) do
						local cx,cy = b[1],b[2]

						dopush(v,ox,oy,dir,false,cx,cy,unitid)
					end
				end
			end
		end

		dopushcopy = false
	end

	local hm = 0
	
	if (HACK_MOVES < 10000) then
		local hmlist,hms,specials = check(unitid,x,y,dir,false,reason)
		local pullhmlist,pullhms,pullspecials = check(unitid,x,y,dir,true,reason)
		local result = 0
		
		local sticky = hasfeature(name,"is","sticky",unitid,x_,y_)
		local weak = hasfeature(name,"is","weak",unitid,x_,y_)

		local ignoreweak = true
		
			--MF_alert(name .. " is looking... (" .. tostring(unitid) .. ")" .. ", " .. tostring(pulling))
		for i,obs in pairs(hmlist) do
			local done = false
			while (done == false) do
				if (obs == 0) then
					result = math.max(0, result)
					done = true
				elseif (obs == 1) or (obs == -1) then
					if (not pulling and not sticky) or ((pulling or sticky) and (hms[i] ~= pusherid)) then
						result = math.max(2, result)
						done = true

						local soft = false
						for _,v in ipairs(specials) do
							if v[1] == hms[i] and v[2] == "soft" then
								soft = true
							end
						end

						if not soft then
							ignoreweak = false
						end
					else
						result = math.max(0, result)
						done = true
					end
				else
					if (not pulling and not sticky) or ((pulling or sticky) and (hms[i] ~= pusherid)) then
						result = math.max(1, result)
						done = true
					else
						result = math.max(0, result)
						done = true
					end
				end
			end
		end
			
		local finaldone = false
		
		while (finaldone == false) and (HACK_MOVES < 10000) do
			if (result == 0) then
				if not stickied[unitid] then
					table.insert(movelist, {unitid,ox,oy,dir,specials})
				elseif stickyspecials then
					table.insert(stickyspecials, {unitid,specials})
				end
				--move(unitid,ox,oy,dir,specials)
				pushsound = true
				finaldone = true
				hm = 0
				
				if (pulling == false) then
					for i,obs in ipairs(pullhmlist) do
						if (obs < -1) or (obs > 1) and (obs ~= pusherid) then
							if (obs ~= 2) then
								local obsunit = mmf.newObject(obs)
								local obsname = getname(obsunit)

								if hasfeature(obsname,"is","sticky",obs) then
									dopush(obs,ox,oy,dir,true,x-ox,y-oy,reason,unitid,stickied)
								else
									table.insert(movelist, {obs,ox,oy,dir,pullspecials})
								end
								pushsound = true
								--move(obs,ox,oy,dir,specials)
							end
							
							local pid = tostring(x-ox + (y-oy) * roomsizex) .. tostring(obs)
							
							if (pushedunits[pid] == nil) then
								pushedunits[pid] = 1
								hm = dopush(obs,ox,oy,dir,true,x-ox,y-oy,reason,unitid,stickied)
							end
						end
					end
				end
			elseif (result == 1) then
				for i,v in ipairs(hmlist) do
					if (v ~= -1) and (v ~= 0) and (v ~= 1) then
						local pid = tostring(x+ox + (y+oy) * roomsizex) .. tostring(v)
						
						if (pulling == false) or (pulling and (hms[i] ~= pusherid)) and (pushedunits[pid] == nil) then
							pushedunits[pid] = 1
							hm = dopush(v,ox,oy,dir,false,x+ox,y+oy,reason,unitid,stickied)

							local soft = false
							for _,v in ipairs(specials) do
								if v[1] == hms[i] and v[2] == "soft" then
									soft = true
								end
							end

							if not soft then
								ignoreweak = false
							end
						end
					end
				end
				
				if (hm == 0) then
					result = 0
				else
					result = 2
				end
			elseif (result == 2) then
				hm = 1
				
				if (weak ~= nil) and not ignoreweak then
					delete(unitid,x,y)
					
					local pmult,sound = checkeffecthistory("weak")
					setsoundname("removal",1,sound)
					generaldata.values[SHAKE] = 3
					MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
					result = 0
					hm = 0
				end
				
				finaldone = true
			end
		end
		
		if pulling and (HACK_MOVES < 10000) then
			hmlist,hms,specials = check(unitid,x,y,dir,pulling,reason)
			hm = 0
			
			for i,obs in pairs(hmlist) do
				if (obs < -1) or (obs > 1) then
					if (obs ~= 2) then
						local obsunit = mmf.newObject(obs)
						local obsname = getname(obsunit)

						if hasfeature(obsname,"is","sticky",obs) then
							dopush(obs,ox,oy,dir,true,x-ox,y-oy,reason,unitid,stickied)
						else
							table.insert(movelist, {obs,ox,oy,dir,specials})
						end
						pushsound = true
						--move(obs,ox,oy,dir,specials)
					end
					
					local pid = tostring(x-ox + (y-oy) * roomsizex) .. tostring(obs)
					
					if (pushedunits[pid] == nil) then
						pushedunits[pid] = 1
						hm = dopush(obs,ox,oy,dir,pulling,x-ox,y-oy,reason,unitid,stickied)
					end
				end
			end
		end
		
		if pushsound and (generaldata2.strings[TURNSOUND] == "") then
			setsoundname("turn",5)
		end
	end
	
	HACK_MOVES = HACK_MOVES + 1
	
	return hm
end

function move(unitid,ox,oy,dir,specials_,instant_,simulate_)
	local instant = instant_ or false
	local simulate = simulate_ or false
	
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		local x,y = unit.values[XPOS],unit.values[YPOS]
		
		local specials = {}
		if (specials_ ~= nil) then
			specials = specials_
		end
		
		local gone = false
		
		for i,v in pairs(specials) do
			if (gone == false) then
				local b = v[1]
				local reason = v[2]
				local dodge = false
				
				local bx,by = 0,0
				if (b ~= 2) then
					local bunit = mmf.newObject(b)
					bx,by = bunit.values[XPOS],bunit.values[YPOS]
					
					if (bx ~= x+ox) or (by ~= y+oy) then
						dodge = true
					else
						for c,d in ipairs(movelist) do
							if (d[1] == b) then
								local nx,ny = d[2],d[3]
								
								--print(tostring(nx) .. "," .. tostring(ny) .. " --> " .. tostring(x+ox) .. "," .. tostring(y+oy) .. " (" .. tostring(bx) .. "," .. tostring(by) .. ")")
								if (nx ~= x+ox) or (ny ~= y+oy) then
									dodge = true
								end
							end
						end
					end
				else
					bx,by = x+ox,y+oy
				end
				
				if (dodge == false) then
					if (reason == "lock") then
						local unlocked = false
						local valid = true
						local soundshort = ""
						
						if (b ~= 2) then
							local bunit = mmf.newObject(b)
							
							if bunit.flags[DEAD] then
								valid = false
							end
						end
						
						if unit.flags[DEAD] then
							valid = false
						end
						
						if valid then
							local pmult = 1.0
							local effect1 = false
							local effect2 = false
							
							if (issafe(b,bx,by) == false) then
								if timecheck(b) then
									delete(b,bx,by)
									unlocked = true
									effect1 = true
								else
									timelessdelete({"lock",b,bx,by})
								end
							end
							
							if (issafe(unitid) == false) then
								if timecheck(unitid) then
									delete(unitid,x,y)
									unlocked = true
									gone = true
									effect2 = true
								else
									timelessdelete({"lock",unitid,x,y})
								end
							end
							
							if effect1 or effect2 then
								local pmult,sound = checkeffecthistory("unlock")
								soundshort = sound
							end
							
							if effect1 then
								MF_particles("unlock",bx,by,15 * pmult,2,4,1,1)
								generaldata.values[SHAKE] = 8
							end
							
							if effect2 then
								MF_particles("unlock",x,y,15 * pmult,2,4,1,1)
								generaldata.values[SHAKE] = 8
							end
						end
						
						if unlocked then
							setsoundname("turn",7,soundshort)
						end
					elseif (reason == "eat") then
						local pmult,sound = checkeffecthistory("eat")
						MF_particles("eat",bx,by,10 * pmult,0,3,1,1)
						generaldata.values[SHAKE] = 3
						delete(b,bx,by)
						
						setsoundname("removal",1,sound)
					elseif (reason == "weak") then
						--[[
						MF_particles("destroy",bx,by,5,0,3,1,1)
						generaldata.values[SHAKE] = 3
						delete(b,bx,by)
						]]--
					end
				end
			end
		end
		
		if (gone == false) and (simulate == false) then
			if instant then
				update(unitid,x+ox,y+oy,dir)
				MF_alert("Instant movement on " .. tostring(unitid))
			else
				addaction(unitid,{"update",x+ox,y+oy,dir})
			end
			
			if unit.visible and (#movelist < 700) then
				if (generaldata.values[DISABLEPARTICLES] == 0) then
					local effectid = MF_effectcreate("effect_bling")
					local effect = mmf.newObject(effectid)
					
					local midx = math.floor(roomsizex * 0.5)
					local midy = math.floor(roomsizey * 0.5)
					local mx = x - midx
					local my = y - midy
					
					local c1,c2 = getcolour(unitid)
					MF_setcolour(effectid,c1,c2)
					
					local xvel,yvel = 0,0
					
					if (ox ~= 0) then
						xvel = 0 - ox / math.abs(ox)
					end
					
					if (oy ~= 0) then
						yvel = 0 - oy / math.abs(oy)
					end
					
					local dx = mx + 0.5
					local dy = my + 0.75
					local dxvel = xvel
					local dyvel = yvel
					
					if (generaldata2.values[ROOMROTATION] == 90) then
						dx = my + 0.75
						dy = 0 - mx - 0.5
						dxvel = yvel
						dyvel = 0 - xvel
					elseif (generaldata2.values[ROOMROTATION] == 180) then
						dx = 0 - mx - 0.5
						dy = 0 - my - 0.75
						dxvel = 0 - xvel
						dyvel = 0 - yvel
					elseif (generaldata2.values[ROOMROTATION] == 270) then
						dx = 0 - my - 0.75
						dy = mx + 0.5
						dxvel = 0 - yvel
						dyvel = xvel
					end
					
					effect.values[ONLINE] = 3
					effect.values[XPOS] = Xoffset + (midx + (dx) * generaldata2.values[ZOOM]) * tilesize * spritedata.values[TILEMULT]
					effect.values[YPOS] = Yoffset + (midy + (dy) * generaldata2.values[ZOOM]) * tilesize * spritedata.values[TILEMULT]
					effect.scaleX = generaldata2.values[ZOOM] * spritedata.values[TILEMULT]
					effect.scaleY = generaldata2.values[ZOOM] * spritedata.values[TILEMULT]
					
					effect.values[XVEL] = dxvel * math.random(10,30) * 0.1 * spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
					effect.values[YVEL] = dyvel * math.random(10,30) * 0.1 * spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
				end
				
				if (unit.values[TILING] == 2) then
					unit.values[VISUALDIR] = ((unit.values[VISUALDIR] + 1) + 4) % 4
				end
			end
		end
		
		return gone
	end
end

function add_moving_units(rule,newdata,data,been_seen,empty_)
	local result = data
	local seen = been_seen
	local empty = empty_ or {}
	
	for i,v in ipairs(newdata) do
		local sleeping = false
		
		if (v ~= 2) then
			local unit = mmf.newObject(v)
			local unitname = getname(unit)
			local sleep = hasfeature(unitname,"is","sleep",v)
			
			if (sleep ~= nil) then
				sleeping = true
			end
		else
			local thisempty = empty[i]
			
			for a,b in pairs(thisempty) do
				local x = a % roomsizex
				local y = math.floor(a / roomsizex)
				
				local sleep = hasfeature("empty","is","sleep",2,x,y)
				
				if (sleep ~= nil) then
					thisempty[a] = nil
				end
			end
		end
		
		if (sleeping == false) then
			if (seen[v] == nil) then
				-- Dir set only for the purposes of Empty
				local dir_ = math.random(0,3)
				
				local x,y = -1,-1
				if (v ~= 2) then
					local unit = mmf.newObject(v)
					x,y = unit.values[XPOS],unit.values[YPOS]
					
					table.insert(result, {unitid = v, reason = rule, state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
					seen[v] = #result
				else
					local thisempty = empty[i]
				
					for a,b in pairs(thisempty) do
						x = a % roomsizex
						y = math.floor(a / roomsizex)
					
						table.insert(result, {unitid = 2, reason = rule, state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
						seen[v] = #result
					end
				end
			else
				local id = seen[v]
				local this = result[id]
				this.moves = this.moves + 1
			end
		end
	end
	
	return result,seen
end

-- BAIT AND LURE START
function getlured(unitid)
	if (unitid == 2) then
		return -1
	end

	local unit = mmf.newObject(unitid)
	local name = getname(unit)
	local x,y,unitdir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]

	local closeststop = 1
	local closestdist = -1
	local closestdir = -1
	
	for dir=0,3 do
		local ndrs = ndirs[dir+1]
		local ox,oy = 0,0

		local stopped = false
		local dist = 0

		local newstop = 0

		while not stopped do
			local obs = findobstacle(x+ox,y+oy)
			local emptybait = hasfeature("empty","is","bait",2,x+ox,y+oy)

			if emptybait then
				if closestdist == -1 or dist < closestdist then
					closestdist = dist
					closestdir = dir
				end
			end

			for i,id in ipairs(obs) do
				if (id == -1) then
					stopped = true
				elseif id ~= unitid then
					local obsunit = mmf.newObject(id)
					local obsname = obsunit.strings[UNITNAME]
					local obstype = obsunit.strings[UNITTYPE]

					if (obstype == "text") then
						obsname = "text"
					end

					local isbait = hasfeature(obsname,"is","bait",id,x+ox,y+oy)
					local isstop = hasfeature(obsname,"is","stop",id,x+ox,y+oy) or hasfeature(obsname,"is","pull",id,x+ox,y+oy)
					
					if isstop then
						newstop = 1
					end

					if isbait then
						if (closestdist == -1 or dist < closestdist) and newstop <= closeststop then
							closeststop = newstop
							closestdist = dist
							closestdir = dir
						end
					end
				end
			end

			ox = ox + ndrs[1]
			oy = oy + ndrs[2]
			dist = dist + 1
		end
	end
	
	if closestdist == 0 then
		return -1
	else
		return closestdir
	end
end
-- BAIT AND LURE END

function findcopycats(target)
	local result = {}

	local copycats = findallfeature(nil,"copy",target,true)
	for _,v in ipairs(copycats) do
		table.insert(result, v)
	end

	return result
end

function stickycheck(unitid,dir,pulling,ignored,alreadychecked,fromdir,lastpull,topull_,allowpull)
	local pushlist = {}
	local pulllist = {}
	local fulllist = {}
	local result = 0

	local root = false
	local topull = topull_ or {}

	if alreadychecked == nil then
		alreadychecked = {}
		root = true
	end

	if unitid == -1 then
		return fulllist,pushlist,pulllist,result
	end

	local unit = mmf.newObject(unitid)
	local x,y,unitdir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
	local name = getname(unit)

	local isstop = hasfeature(name,"is","stop",unitid,x,y)
	local ispush = hasfeature(name,"is","push",unitid,x,y)
	local ispull = hasfeature(name,"is","pull",unitid,x,y)
	local sticky = hasfeature(name,"is","sticky",unitid,x,y)

	if sticky == nil or not timecheck(unitid) then
		return fulllist,pushlist,pulllist,result
	end

	if not allowpull and not lastpull and not root and not pulling and ispull and not ispush then
		if fromdir ~= rotate(dir) then
			if not topull[unitid] then
				topull[unitid] = 0
			end
			return fulllist,pushlist,pulllist,result
		elseif fromdir == rotate(dir) then
			topull[unitid] = 1
		end
	end

	local selfstop = false
	local alreadysetcolour = false

	if (isstop and not ispush and not ispull) then
		result = 1
		selfstop = true
	end

	table.insert(alreadychecked, unitid)

	if ignored ~= unitid then
		table.insert(fulllist, {unitid, x, y, unitdir})
	end

	for i=1,4 do
		local ndrs = ndirs[i]
		local ox,oy = ndrs[1],ndrs[2]
		local obs = findobstacle(x+ox,y+oy)
		local foundnone = true
		for _,id in ipairs(obs) do
			local ignore = false
			for _,checked in ipairs(alreadychecked) do
				if checked == id then
					ignore = true
					foundnone = false
					break
				end
			end
			--[[if not pulling and ispull and not ispush and i-1 == dir then
				ignore = true
			end]]
			if not ignore then
				local fulllist_,pushlist_,pulllist_,result_ = stickycheck(id,dir,pulling,ignored,alreadychecked,i-1,ispull,topull,allowpull)
				if #fulllist_ > 0 then
					foundnone = false
				end
				for _,v in ipairs(pushlist_) do
					table.insert(pushlist, v)
				end
				for _,v in ipairs(pulllist_) do
					table.insert(pulllist, v)
				end
				for _,v in ipairs(fulllist_) do
					table.insert(fulllist, v)
				end
				result = math.max(result, result_)
			end
		end
		if foundnone then
			if i-1 == rotate(dir) then
				table.insert(pulllist, {unitid, x, y, unitdir})
				if not alreadysetcolour then
					--MF_setcolour(unitid,4,2)
					alreadysetcolour = true
				else
					--MF_setcolour(unitid,3,1)
				end
			elseif i-1 == dir then
				table.insert(pushlist, {unitid, x, y, unitdir})
				if not alreadysetcolour then
					--MF_setcolour(unitid,1,3)
					alreadysetcolour = true
				else
					--MF_setcolour(unitid,3,1)
				end
			end
		end
	end

	if selfstop then
		--MF_setcolour(unitid,4,1)
	elseif not alreadysetcolour then
		--MF_setcolour(unitid,0,3)
	end

	if root then
		local pullcount = 0
		for i,v in pairs(topull) do
			pullcount = pullcount + 1
			if v == 0 then
				result = 1
				--MF_setcolour(i,4,1)
			end
		end
		if pullcount > 0 and result == 0 then
			local a,b,c,d = stickycheck(unitid,dir,pulling,ignored,{},fromdir,false,{},true)
			return a,b,c,d
		end
	end

	return fulllist,pushlist,pulllist,result
end

function updategravity(dir,small)
	if not timecheck(3) then
		return
	end

	-- Gravity direction code
	local newgrav = nil

	if findfeature("gravity","is","turn") then
		if not small then
			if string.lower(activemod.turn_dir) == "cw" then
				newgrav = (gravitydir - 1) % 4
			else
				newgrav = (gravitydir + 1) % 4
			end
		else
			newgrav = gravitydir
		end
	end

	if findfeature("gravity","is","move") then
		if not small then
			newgrav = rotate(gravitydir)
		else
			newgrav = gravitydir
		end
	end

	if findfeature("gravity","is","stop") then
		newgrav = -1
	elseif findfeature("gravity","is","you") then
		if dir ~= 4 then
			newgrav = dir
		else
			newgrav = gravitydir
		end
	elseif findfeature("gravity","is","right") then
		newgrav = 0
	elseif findfeature("gravity","is","up") then
		newgrav = 1
	elseif findfeature("gravity","is","left") then
		newgrav = 2
	elseif findfeature("gravity","is","down") then
		newgrav = 3
	end

	if not newgrav then
		newgrav = 3
	end

	if newgrav ~= gravitydir then
		addundo({"gravity",gravitydir,newgrav})
		doundo = true
		hasmoved[3] = true
	end
	gravitydir = newgrav

	-- Gravity specials
	gravityconvert = nil
	gravitymake = {}
	gravityeat = {}

	if featureindex["gravity"] then
		for i,v in ipairs(featureindex["gravity"]) do
			local rule = v[1]
			local conds = v[2]

			local isnot = string.sub(rule[3], 1, 4) == "not "

			if rule[1] == "gravity" and rule[2] == "is" and rule[3] == "not gravity" then
				gravitydir = -1
			end

			if not isnot then
				if rule[1] == "gravity" then
					if testcond(conds,3) then
						if rule[3] ~= "gravity" and getmat(rule[3]) then
							if rule[2] == "is" then
								if not gravityconvert then
									gravityconvert = {}
								end
								table.insert(gravityconvert, rule[3])
							elseif rule[2] == "make" then
								table.insert(gravitymake, rule[3])
							end
						end
					end
				elseif rule[3] == "gravity" then
					if rule[1] ~= "group" and rule[1] ~= "all" and rule[1] ~= "any" then
						if rule[2] == "eat" then
							if rule[1] == "gravity" then
								gravitydir = -1
							else
								local units = unitlists[rule[1]]
								if units then
									print("nyaagh")
									for _,v in ipairs(units) do
										print("nyani")
										if testcond(conds,v) then
											print("NYOOM")
											gravityeat[v] = true
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

function checktimelessturn(playerid_)
	if not autoturn then
		local players = {}
		local empty = {}
		local playerid = 1

		if (playerid_ ~= nil) then
			playerid = playerid_
		end
		
		if (playerid == 1) then
			players,empty = findallfeature(nil,"is","you")
		elseif (playerid == 2) then
			players,empty = findallfeature(nil,"is","you2")
			
			if (#players == 0) then
				players,empty = findallfeature(nil,"is","you")
			end
		end

		local players,empty = findallfeature(nil,"is","you")
		local result = true
		if #players == 0 then
			result = false
		else
			local allsleep = true
			for i,v in ipairs(players) do
				if (v ~= 2) then
					local unit = mmf.newObject(v)
					
					local name = getname(unit)
					local sleep = hasfeature(name,"is","sleep",v)
					local timeless = gettag(v,"timeless")
					
					if timeless and not sleep then
						allsleep = false
					elseif not timeless then
						result = false
					end
				else
					local thisempty = empty[i]
					
					for a,b in pairs(thisempty) do
						local x = a % roomsizex
						local y = math.floor(a / roomsizex)
						
						local sleep = hasfeature("empty","is","sleep",2,x,y)
						local timeless = hasfeature("empty","is","timeless",2,x,y)

						if timeless and not sleep then
							allsleep = false
						elseif not timeless then
							result = false
						end
					end
				end
			end

			if allsleep then
				result = false
			end
		end

		return result
	else
		local result = true
		local allsleep = true

		for unitid,_ in pairs(autounits) do
			local unit = mmf.newObject(unitid)
			local name = getname(unit)
			
			local sleep = hasfeature(name,"is","sleep",unitid)
			local timeless = gettag(unitid,"timeless")

			if timeless and not sleep then
				allsleep = false
			elseif not timeless then
				result = false
			end
		end

		if allsleep then
			result = false
		end

		return result
	end
end