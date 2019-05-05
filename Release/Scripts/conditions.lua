function testcond(conds,unitid,x_,y_)
	local result = true
	
	local x,y,name,dir = 0,0,"",4
	local surrounds = {}
	
	-- 0 = bug, 1 = level, 2 = empty
	
	if (unitid ~= 3) and (unitid ~= 2) and (unitid ~= 0) and (unitid ~= 1) then
		local unit = mmf.newObject(unitid)
		x = unit.values[XPOS]
		y = unit.values[YPOS]
		name = unit.strings[UNITNAME]
		dir = unit.values[DIR]
		
		if (unit.strings[UNITTYPE] == "text") then
			name = "text"
		end
	elseif (unitid == 2) then
		x = x_
		y = y_
		name = "empty"
	elseif (unitid == 1) then
		name = "level"
		surrounds = parsesurrounds()
		dir = tonumber(surrounds.dir)
	elseif (unitid == 3) then
		name = "gravity"
		dir = gravitydir
	end
	
	if (unitid == 0) then
		print("WARNING!! Unitid is zero!!")
	end
	
	if (conds ~= nil) then
		if (#conds > 0) then
			local valid = false
			
			for i,cond in ipairs(conds) do
				local condtype = cond[1]
				local params_ = cond[2]

				local iconds = {}

				local params = {}
				if params_ then
					for a,b in ipairs(params_) do
						if type(b) == "table" then
							table.insert(iconds,b)
						else
							table.insert(params,b)
						end
					end
				end
				
				local extras = {}
				
				local isnot = string.sub(condtype, 1, 3)
				
				if (isnot == "not") then
					isnot = string.sub(condtype, 5)
				else
					isnot = condtype
				end
				
				if (condtype ~= "never") then
					local conddata = conditions[isnot]
					if (conddata.argextra ~= nil) then
						extras = conddata.argextra
					end
				end
				
				if (condtype == "never") then
					result = false
					valid = true
				elseif (condtype == "on") then
					valid = true
					local allfound = 0
					local alreadyfound = {}
					
					local tileid = x + y * roomsizex
					
					if (#params > 0) then
						for a,b in ipairs(params) do
							if (unitid ~= 1) then
								if (b ~= "empty") and (b ~= "level") then
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit)
												
												if ((name_ == b) or (b == "any")) and (alreadyfound[b] == nil) then
													if testcondstack(iconds,d,x,y) then
														alreadyfound[b] = 1
														allfound = allfound + 1
													end
												end
											end
										end
									else
										print("unitmap is nil at " .. tostring(x) .. ", " .. tostring(y) .. " for object " .. unit.strings[UNITNAME] .. " (" .. tostring(unitid) .. ")!")
									end
								elseif (b == "empty") then
									result = false
								elseif (b == "level") then
									if testcondstack(iconds,1,x,y) then
										alreadyfound[b] = 1
										allfound = allfound + 1
									end
								end
							else
								local ulist = false
								
								if (b ~= "empty") and (b ~= "level") then
									if (unitlists[b] ~= nil) then
										if (#unitlists[b] > 0) then
											if #iconds == 0 then
												ulist = true
											else
												for c,d in ipairs(unitlists[b]) do
													if testcondstack(iconds,d,x,y) then
														ulist = true
														break
													end
												end
											end
										end
									end
								elseif (b == "empty") then
									local empties = findempty()
									
									if (#empties > 0) then
										if #iconds == 0 then
											ulist = true
										else
											for c,d in ipairs(empties) do
												if testcondstack(iconds,2,d % roomsizex,math.floor(d/roomsizex)) then
													ulist = true
													break
												end
											end
										end
									end
								end
								
								if (b ~= "text") and (ulist == false) then
									if (surrounds["o"] ~= nil) then
										for c,d in ipairs(surrounds["o"]) do
											if (d == b) then
												ulist = true
											end
										end
									end
								end
								
								if ulist or (#iconds == 0 and (b == "text")) then
									if (alreadyfound[b] == nil) then
										alreadyfound[b] = 1
										allfound = allfound + 1
									end
								end
							end
						end
					else
						print("no parameters given!")
					end
					
					--MF_alert(tostring(allfound) .. ", " .. tostring(#params) .. " for " .. name)
					
					if (allfound ~= #params) then
						result = false
					end
				elseif (condtype == "not on") then
					valid = true
					local tileid = x + y * roomsizex
					
					if (#params > 0) then
						for a,b in ipairs(params) do
							if (unitid ~= 1) then
								if (b ~= "empty") and (b ~= "level") then
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit)
												
												if (name_ == b) or (b == "any") then
													if testcondstack(iconds,d,x,y) then
														result = false
													end
												end
											end
										end
									else
										print("unitmap is nil at " .. tostring(x) .. ", " .. tostring(y) .. "!")
									end
								elseif (b == "empty") then
									local onempty = false

									if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then 
										if testcondstack(iconds,2,x,y) then
											onempty = true
										end
									end
									
									if onempty then
										result = false
									end
								elseif (b == "level") then
									result = false
								end
							else
								if (b ~= "empty") and (b ~= "level") and (iconds or (b ~= "text")) then
									if (unitlists[b] ~= nil) then
										if (#unitlists[b] > 0) then
											if #iconds == 0 then
												result = false
											else
												for c,d in ipairs(unitlists[b]) do
													if testcondstack(iconds,d,x,y) then
														result = false
														break
													end
												end
											end
										end
									end
								elseif (b == "empty") then
									local empties = findempty()
									
									if (#findempty > 0) then
										if #iconds == 0 then
											result = false
										else
											for c,d in ipairs(findempty) do
												if testcondstack(iconds,2,d % roomsizex,math.floor(d/roomsizex)) then
													result = false
													break
												end
											end
										end
									end
								elseif (b == "text") then
									result = false
								end
								
								if result then
									if (surrounds["o"] ~= nil) then
										for c,d in ipairs(surrounds["o"]) do
											if (d == b) then
												result = false
											end
										end
									end
								end
							end
						end
					else
						print("no parameters given!")
					end
				elseif (condtype == "facing") then
					valid = true
					local allfound = 0
					local alreadyfound = {}
					
					local ndrs = ndirs[dir+1]
					local ox = ndrs[1]
					local oy = ndrs[2]
					
					local tileid = (x + ox) + (y + oy) * roomsizex
					
					if (#params > 0) then
						if (name ~= "empty") then
							for a,b in ipairs(params) do
								if (unitid ~= 1) then
									if (b ~= "empty") and (b ~= "level") then
										if (stringintable(b,extras) == false) then
											if (unitmap[tileid] ~= nil) then
												for c,d in ipairs(unitmap[tileid]) do
													if (d ~= unitid) then
														local unit = mmf.newObject(d)
														local name_ = getname(unit)
														
														if ((name_ == b) or (b == "any")) and (alreadyfound[b] == nil) then
															if testcondstack(iconds,d,(x+ox),(y+oy)) then
																alreadyfound[b] = 1
																allfound = allfound + 1
															end
														end
													end
												end
											end
										else
											if ((b == "right") and (dir == 0)) or ((b == "up") and (dir == 1)) or ((b == "left") and (dir == 2)) or ((b == "down") and (dir == 3)) then
												alreadyfound[b] = 1
												allfound = allfound + 1
											end
										end
									elseif (b == "empty") then
										if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then
											if (alreadyfound[b] == nil) then
												if testcondstack(iconds,2,(x+ox),(y+oy)) then
													alreadyfound[b] = 1
													allfound = allfound + 1
												end
											end
										end
									elseif (b == "level") then
										if testcondstack(iconds,1,(x+ox),(y+oy)) then
											alreadyfound[b] = 1
											allfound = allfound + 1
										end
									end
								else
									local dirids = {"r","u","l","d"}
									local dirid = dirids[dir + 1]
									
									if (surrounds[dirid] ~= nil) then
										for c,d in ipairs(surrounds[dirid]) do
											if (d == b) and (alreadyfound[b] == nil) then
												alreadyfound[b] = 1
												allfound = allfound + 1
											end
										end
									end
								end
							end
						else
							result = false
						end
					else
						print("no parameters given!")
					end
					
					if (allfound ~= #params) then
						result = false
					end
				elseif (condtype == "not facing") then
					valid = true

					local ndrs = ndirs[dir+1]
					local ox = ndrs[1]
					local oy = ndrs[2]
					
					local tileid = (x + ox) + (y + oy) * roomsizex
					
					if (#params > 0) then
						if (name ~= "empty") then
							for a,b in ipairs(params) do
								if (unitid ~= 1) then
									if (b ~= "empty") and (b ~= "level") then
										if (stringintable(b, extras) == false) then
											if (unitmap[tileid] ~= nil) then
												for c,d in ipairs(unitmap[tileid]) do
													if (d ~= unitid) then
														local unit = mmf.newObject(d)
														local name_ = getname(unit)
														
														if (name_ == b) or (b == "any") then
															if testcondstack(iconds,d,(x+ox),(y+oy)) then
																result = false
															end
														end
													end
												end
											end
										else
											if ((b == "right") and (dir == 0)) or ((b == "up") and (dir == 1)) or ((b == "left") and (dir == 2)) or ((b == "down") and (dir == 3)) then
												result = false
											end
										end
									elseif (b == "empty") then
										if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then
											if testcondstack(iconds,2,(x+ox),(y+oy)) then
												result = false
											end
										end
									elseif (b == "level") then
										if testcondstack(iconds,1,(x+ox),(y+oy)) then
											result = false
										end
									end
								else
									local dirids = {"r","u","l","d"}
									local dirid = dirids[dir + 1]
									
									if (surrounds[dirid] ~= nil) then
										for c,d in ipairs(surrounds[dirid]) do
											if (d == b) and (alreadyfound[b] == nil) then
												result = false
											end
										end
									end
								end
							end
						elseif (name == "empty") then
							result = false
						end
					else
						print("no parameters given!")
					end
				elseif (condtype == "near") then
					valid = true
					local allfound = 0
					local alreadyfound = {}
					
					if (#params > 0) then
						for a,b in ipairs(params) do
							if (unitid ~= 1) then
								if (b ~= "level") then
									for g=-1,1 do
										for h=-1,1 do
											if (b ~= "empty") then
												local tileid = (x + g) + (y + h) * roomsizex
												if (unitmap[tileid] ~= nil) then
													for c,d in ipairs(unitmap[tileid]) do
														if (d ~= unitid) then
															local unit = mmf.newObject(d)
															local name_ = getname(unit)
															
															if ((name_ == b) or (b == "any")) and (alreadyfound[b] == nil) then
																if testcondstack(iconds,d,(x+g),(y+h)) then
																	alreadyfound[b] = 1
																	allfound = allfound + 1
																end
															end
														end
													end
												end
											else
												local nearempty = false
										
												local tileid = (x + g) + (y + h) * roomsizex
												if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then 
													nearempty = true
												end
												
												if nearempty and (alreadyfound[b] == nil) then
													if testcondstack(iconds,2,(x+g),(y+h)) then
														alreadyfound[b] = 1
														allfound = allfound + 1
													end
												end
											end
										end
									end
								elseif (b == "level") then
									if testcondstack(iconds,1,x,y) then
										alreadyfound[b] = 1
										allfound = allfound + 1
									end
								end
							else
								local ulist = false
							
								if (b ~= "empty") and (b ~= "level") then
									if (unitlists[b] ~= nil) then
										if (#unitlists[b] > 0) then
											if #iconds == 0 then
												ulist = true
											else
												for c,d in ipairs(unitlists[b]) do
													if testcondstack(iconds,d,x,y) then
														ulist = true
														break
													end
												end
											end
										end
									end
								elseif (b == "empty") then
									local empties = findempty()
									
									if (#findempty > 0) then
										if #iconds == 0 then
											ulist = true
										else
											for c,d in ipairs(findempty) do
												if testcondstack(iconds,2,d % roomsizex,math.floor(d/roomsizex)) then
													ulist = true
													break
												end
											end
										end
									end
								end
								
								if (b ~= "text") and (ulist == false) then
									for e,f in pairs(surrounds) do
										if (e ~= "dir") then
											for c,d in ipairs(f) do
												if (ulist == false) and (d == b) then
													ulist = true
												end
											end
										end
									end
								end
								
								if ulist or (#iconds == 0 and (b == "text")) then
									if (alreadyfound[b] == nil) then
										alreadyfound[b] = 1
										allfound = allfound + 1
									end
								end
							end
						end
					else
						print("no parameters given!")
					end

					if (allfound ~= #params) then
						result = false
					end
				elseif (condtype == "not near") then
					valid = true
					
					if (#params > 0) then
						for a,b in ipairs(params) do
							if (unitid ~= 1) then
								if (b ~= "level") then
									for g=-1,1 do
										for h=-1,1 do
											if (b ~= "empty") then
												local tileid = (x + g) + (y + h) * roomsizex
												if (unitmap[tileid] ~= nil) then
													for c,d in ipairs(unitmap[tileid]) do
														local unit = mmf.newObject(d)
														local name_ = getname(unit)
														
														if (name_ == b) or (b == "any") then
															if testcondstack(iconds,d,(x+g),(y+h)) then
																result = false
															end
														end
													end
												end
											else
												local nearempty = false
										
												local tileid = (x + g) + (y + h) * roomsizex
												if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then 
													nearempty = true
												end
												
												if nearempty then
													if testcondstack(iconds,2,(x+g),(y+h)) then
														result = false
													end
												end
											end
										end
									end
								else
									if testcondstack(iconds,1,x,y) then
										result = false
									end
								end
							else
								local ulist = false
							
								if (b ~= "empty") and (b ~= "level") and (iconds or (b ~= "text")) then
									if (unitlists[b] ~= nil) then
										if (#unitlists[b] > 0) then
											if #iconds == 0 then
												result = false
											else
												for c,d in ipairs(unitlists[b]) do
													if testcondstack(iconds,d,x,y) then
														result = false
														break
													end
												end
											end
										end
									end
								elseif (b == "empty") then
									local empties = findempty()
									
									if (#findempty > 0) then
										if #iconds == 0 then
											result = false
										else
											for c,d in ipairs(findempty) do
												if testcondstack(iconds,2,d % roomsizex,math.floor(d/roomsizex)) then
													result = false
													break
												end
											end
										end
									end
								elseif (b == "text") then
									result = false
								end
								
								if (b ~= "text") and result then
									for e,f in pairs(surrounds) do
										if (e ~= "dir") then
											for c,d in ipairs(f) do
												if result and (d == b) then
													result = false
												end
											end
										end
									end
								end
							end
						end
					else
						print("no parameters given!")
					end
				elseif (condtype == "lonely") then
					valid = true
					
					if (unitid ~= 1) then
						local tileid = x + y * roomsizex
						if (unitmap[tileid] ~= nil) then
							for c,d in ipairs(unitmap[tileid]) do
								if (d ~= unitid) then
									result = false
								end
							end
						end
					else
						result = false
					end
				elseif (condtype == "not lonely") then
					valid = true
					
					if (unitid ~= 1) then
						local tileid = x + y * roomsizex
						if (unitmap[tileid] ~= nil) then
							if (#unitmap[tileid] == 1) then
								result = false
							end
						end
					else
						if (surrounds["o"] ~= nil) then
							if (#surrounds["o"] > 0) then
								result = false
							end
						end
					end
				elseif (condtype == "still") then
					valid = true
					if still[unitid] ~= true then
						result = false
					end
				elseif (condtype == "not still") then
					valid = true
					if still[unitid] ~= false then
						result = false
					end
				elseif (condtype == "with") then
					valid = true

					local isfirst = false
					if withrecursion == nil then
						isfirst = true
						withrecursion = {}
					end

					if not withrecursion[conds] then
						withrecursion[conds] = true
						for a,b in ipairs(params) do
							if not hasfeature(name,"is",b,unitid,x,y) then
								result = false
							end
						end

						if isfirst then
							withrecursion = nil
						end
					else
						result = false
					end
				elseif (condtype == "not with") then
					valid = true

					local isfirst = false
					if withrecursion == nil then
						isfirst = true
						withrecursion = {}
					end

					if not withrecursion[conds] then
						withrecursion[conds] = true
						for a,b in ipairs(params) do
							if hasfeature(name,"is",b,unitid,x,y) then
								result = false
							end
						end

						if isfirst then
							withrecursion = nil
						end
					else
						result = false
					end
				elseif (condtype == "nearest") or (condtype == "not nearest") then
					valid = true
					local allfound = 0

					if #params > 0 then
						for a,b in ipairs(params) do
							if unitid ~= 1 then
								if b ~= "level" then
									local selfdist = 9999
									local closest = 9999
									local allself = {}
									local checkpositions = {}

									if name ~= "empty" then
										if unitlists[name] ~= nil then
											for c,d in ipairs(unitlists[name]) do
												local dunit = mmf.newObject(d)
												table.insert(allself, {dunit.values[XPOS], dunit.values[YPOS]})
											end
										end
									else
										local empties = findempty()
										for c,d in ipairs(empties) do
											table.insert(allself, {d % roomsizex, math.floor(d/roomsizex)})
										end
									end

									if b ~= "empty" then
										local ulist = {}
										if b == "any" then
											ulist = units
										elseif unitlists[b] then
											ulist = unitlists[b]
										end
										for c,d in ipairs(ulist) do
											local dunit = mmf.newObject(d)
											local tx,ty = dunit.values[XPOS], dunit.values[YPOS]
											if testcondstack(iconds,d,tx,ty) then
												table.insert(checkpositions, {tx, ty})
											end
										end
									else
										local empties = findempty()
										for c,d in ipairs(empties) do
											local tx,ty = d % roomsizex, math.floor(d/roomsizex)
											if testcondstack(iconds,2,tx,ty) then
												table.insert(checkpositions, {tx, ty})
											end
										end
									end

									for c,d in ipairs(checkpositions) do
										for e,f in ipairs(allself) do
											local dx = f[1] - d[1]
											local dy = f[2] - d[2]
											--local dist = math.abs(dx) + math.abs(dy) -- Manhattan
											--local dist = math.sqrt(dx * dx + dy * dy) -- Euclidean
											local dist = math.max(math.abs(dx), math.abs(dy)) -- Chebyshev

											if dist < closest then
												closest = dist
											end
											
											if x == f[1] and y == f[2] then
												if dist < selfdist then
													selfdist = dist
												end
											end
										end
									end

									if closest ~= 9999 and selfdist == closest then
										allfound = allfound + 1
									end
								else
									allfound = allfound + 1
								end
							else
								local ulist = false
							
								if (b ~= "empty") and (b ~= "level") then
									if (unitlists[b] ~= nil) then
										if (#unitlists[b] > 0) then
											if #iconds == 0 then
												ulist = true
											else
												for c,d in ipairs(unitlists[b]) do
													if testcondstack(iconds,d,x,y) then
														ulist = true
														break
													end
												end
											end
										end
									end
								elseif (b == "empty") then
									local empties = findempty()
									
									if (#findempty > 0) then
										if #iconds == 0 then
											ulist = true
										else
											for c,d in ipairs(findempty) do
												if testcondstack(iconds,2,d % roomsizex,math.floor(d/roomsizex)) then
													ulist = true
													break
												end
											end
										end
									end
								end
								
								if (b ~= "text") and (ulist == false) then
									for e,f in pairs(surrounds) do
										if (e ~= "dir") then
											for c,d in ipairs(f) do
												if (ulist == false) and (d == b) then
													ulist = true
												end
											end
										end
									end
								end
								
								if ulist or (#iconds == 0 and (b == "text")) then
									allfound = allfound + 1
								end
							end
						end
					end

					if allfound ~= #params then
						result = false
					end

					if isnot ~= condtype then
						result = not result
					end
				elseif (condtype == "touch") or (condtype == "not touch") then
					valid = true
					local allfound = 0
					local alreadyfound = {}
					
					if (#params > 0) then
						for a,b in ipairs(params) do
							if (unitid ~= 1) then
								if (b ~= "level") then
									for _,dir in ipairs(ndirs) do
										local dx,dy = dir[1],dir[2]
										if (b ~= "empty") then
											local tileid = (x + dx) + (y + dy) * roomsizex
											if (unitmap[tileid] ~= nil) then
												for c,d in ipairs(unitmap[tileid]) do
													if (d ~= unitid) then
														local unit = mmf.newObject(d)
														local name_ = getname(unit)
														
														if ((name_ == b) or (b == "any")) and (alreadyfound[b] == nil) then
															if testcondstack(iconds,d,(x+dx),(y+dy)) then
																alreadyfound[b] = 1
																allfound = allfound + 1
															end
														end
													end
												end
											end
										else
											local nearempty = false
									
											local tileid = (x + dx) + (y + dy) * roomsizex
											if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then 
												nearempty = true
											end
											
											if nearempty and (alreadyfound[b] == nil) then
												if testcondstack(iconds,2,(x+dx),(y+dy)) then
													alreadyfound[b] = 1
													allfound = allfound + 1
												end
											end
										end
									end
								elseif (b == "level") then
									if testcondstack(iconds,1,x,y) then
										alreadyfound[b] = 1
										allfound = allfound + 1
									end
								end
							else
								local ulist = false
							
								if (b ~= "empty") and (b ~= "level") then
									if (unitlists[b] ~= nil) then
										if (#unitlists[b] > 0) then
											if #iconds == 0 then
												ulist = true
											else
												for c,d in ipairs(unitlists[b]) do
													if testcondstack(iconds,d,x,y) then
														ulist = true
														break
													end
												end
											end
										end
									end
								elseif (b == "empty") then
									local empties = findempty()
									
									if (#findempty > 0) then
										if #iconds == 0 then
											ulist = true
										else
											for c,d in ipairs(findempty) do
												if testcondstack(iconds,2,d % roomsizex,math.floor(d/roomsizex)) then
													ulist = true
													break
												end
											end
										end
									end
								end
								
								if (b ~= "text") and (ulist == false) then
									for e,f in pairs(surrounds) do
										if (e == "r") or (e == "u") or (e == "d") or (e == "l") then
											for c,d in ipairs(f) do
												if (ulist == false) and (d == b) then
													ulist = true
												end
											end
										end
									end
								end
								
								if ulist or (#iconds == 0 and (b == "text")) then
									if (alreadyfound[b] == nil) then
										alreadyfound[b] = 1
										allfound = allfound + 1
									end
								end
							end
						end
					else
						print("no parameters given!")
					end

					if (allfound ~= #params) then
						result = false
					end

					if isnot ~= condtype then
						result = not result
					end
				elseif (isnot == "reset any") then
					valid = true
					if resetcount == 0 then
						result = false
					end
					if isnot ~= condtype then
						result = not result
					end
				elseif (isnot == "reset even") then
					valid = true
					if resetcount % 2 == 1 then
						result = false
					end
					if isnot ~= condtype then
						result = not result
					end
				elseif (isnot == "reset odd") then
					valid = true
					if resetcount % 2 == 0 then
						result = false
					end
					if isnot ~= condtype then
						result = not result
					end
				elseif (isnot == "reset count") then
					valid = true
					if resetmoves == 0 then
						result = false
					end
					if isnot ~= condtype then
						result = not result
					end
				end
			end
			
			if (valid == false) then
				print("invalid condition: " .. condtype)
				result = true
			end
		end
	end
	
	return result
end

function testcondstack(conds,unitid,x,y)
	for _,cond in ipairs(conds) do
		if not testcond(cond,unitid,x,y) then
			return false
		end
	end
	return true
end