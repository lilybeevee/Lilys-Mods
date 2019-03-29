function code()
	if (updatecode == 1) then
		--MF_alert("code being updated!")
		
		MF_removeblockeffect(0)
		
		local checkthese = {}
		local wordidentifier = ""
		wordunits,wordidentifier = findwordunits()
		
		if (#wordunits > 0) then
			for i,v in ipairs(wordunits) do
				if testcond(v[2],v[1]) then
					table.insert(checkthese, v[1])
				end
			end
		end
		
		features = {}
		featureindex = {}
		visualfeatures = {}
		notfeatures = {}
		local firstwords = {}
		local alreadyused = {}
		
		featureindex["text"] = {}
		featureindex["push"] = {}
		featureindex["is"] = {}
		local textpush = {"text","is","push"}
		local fulltextpush = {textpush,{},{}}
		table.insert(features, fulltextpush)
		table.insert(featureindex["text"], fulltextpush)
		table.insert(featureindex["push"], fulltextpush)
		table.insert(featureindex["is"], fulltextpush)
		
		featureindex["level"] = {}
		featureindex["stop"] = {}
		local levelstop = {"level","is","stop"}
		local fulllevelstop = {levelstop,{},{}}
		table.insert(features, fulllevelstop)
		table.insert(featureindex["level"], fulllevelstop)
		table.insert(featureindex["stop"], fulllevelstop)
		table.insert(featureindex["is"], fulllevelstop)
		
		if (#codeunits > 0) then
			for i,v in ipairs(codeunits) do
				table.insert(checkthese, v)
			end
		end
	
		if (#checkthese > 0) then
			for iid,unitid in ipairs(checkthese) do
				local unit = mmf.newObject(unitid)
				local x,y = unit.values[XPOS],unit.values[YPOS]
				local ox,oy,nox,noy = 0,0
				local tileid = x + y * roomsizex

				setcolour(unit.fixed)
				
				if (alreadyused[tileid] == nil) then
					for i=1,2 do
						local drs = dirs[i+2]
						local ndrs = dirs[i]
						ox = drs[1]
						oy = drs[2]
						nox = ndrs[1]
						noy = ndrs[2]
						
						local hm = codecheck(unitid,ox,oy)
						local hm2 = codecheck(unitid,nox,noy)
						
						if (#hm == 0) and (#hm2 > 0) then
							table.insert(firstwords, {unitid, i})
							
							alreadyused[tileid] = 1
						end
					end
				end
			end
			
			docode(firstwords,wordunits)
			grouprules()
			postrules()
			updatecode = 0
			
			local newwordunits,newwordidentifier = findwordunits()
			
			--MF_alert("ID comparison: " .. newwordidentifier .. " - " .. wordidentifier)
			
			if (newwordidentifier ~= wordidentifier) then
				updatecode = 1
				code()
			else
				domaprotation()
			end
		end
	end
end

--[[
function dumpobj(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dumpobj(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
]]--

function docode(firstwords)
	local donefirstwords = {}
	local limiter = 0
	
	if (#firstwords > 0) then
		for k,unitdata in ipairs(firstwords) do
			local unitid = unitdata[1]
			local dir = unitdata[2]
			
			local unit = mmf.newObject(unitdata[1])
			local x,y = unit.values[XPOS],unit.values[YPOS]
			local tileid = x + y * roomsizex
			
			--MF_alert("Testing " .. unit.strings[UNITNAME] .. ": " .. tostring(donefirstwords[tileid]) .. ", " .. tostring(dir))
			limiter = limiter + 1
			
			if (limiter > 10000) then
				timedmessage("error - too complicated rules!")
			end
			
			if (donefirstwords[tileid] == nil) or ((donefirstwords[tileid] ~= nil) and (donefirstwords[tileid][dir] == nil)) and (limiter < 10000) then
				local ox,oy = 0,0
				local name = unit.strings[NAME]
				
				local drs = dirs[dir]
				ox = drs[1]
				oy = drs[2]
				
				if (donefirstwords[tileid] == nil) then
					donefirstwords[tileid] = {}
				end
				
				donefirstwords[tileid][dir] = 1
				
				local variations = 1
				local done = false
				local sentences = {}
				local variantcount = {}
				local combo = {}
				
				local finals = {}
				
				local steps = 0
				
				while (done == false) do
					local words = codecheck(unitdata[1],ox*steps,oy*steps,wordunits)
					steps = steps + 1
					
					sentences[steps] = {}
					local sent = sentences[steps]
					
					table.insert(variantcount, #words)
					table.insert(combo, 1)
					
					if (#words > 0) then
						variations = variations * #words
						
						if (variations > #finals) then
							local limitdiff = variations - #finals
							for i=1,limitdiff do
								table.insert(finals, {})
							end
						end
						
						for i,v in ipairs(words) do
							local tile = mmf.newObject(v)
							local tilename = tile.strings[NAME]
							local tiletype = tile.values[TYPE]
							
							if (tile.strings[UNITTYPE] ~= "text") then
								tiletype = 0
							end
							
							table.insert(sent, {tilename, tiletype, v})
						end
					else
						done = true
					end
				end
				
				if (#sentences > 2) then
					for i=1,variations do
						local current = finals[i]
						local letterword = ""
						local stage = 0
						local prevstage = 0
						local tileids = {}
						
						local notstatus = 0
						local stage3reached = false
						local stage2reached = false
						local doingcond = false
						
						local letterwordfound = false
						local firstrealword = false
						local letterword_prevstage = 0
						local letterword_firstid = 0
						
						local currtiletype = 0
						local prevtiletype = 0
						
						local stop = false
						
						local sent = getsentencevariant(sentences,combo)
						
						local thissent = ""
						
						for wordid=1,#sentences do
							if (variantcount[wordid] > 0) then
								local s = sent[wordid]
								local nexts = sent[wordid + 1] or {-1, -1, -1}
								
								prevtiletype = currtiletype
								
								local tilename = s[1]
								local tiletype = s[2]
								local tileid = s[3]
								
								local wordtile = false
								
								currtiletype = tiletype
								
								local dontadd = false
								
								thissent = thissent .. tilename .. "," .. tostring(wordid) .. "  "
								
								table.insert(tileids, tileid)
								
								--[[
									0 = objekti
									1 = linkityssana
									2 = verb
									3 = alkusana (LONELY)
									4 = Not
									5 = letter
									6 = And
									7 = ehtosana
								]]--
								
								if (tiletype == 5) then
									letterword = letterword .. tilename
									
									local lword,ltype,found,secondaryfound = findword(letterword,nexts,tilename)
									
									if letterwordfound and (found == false) then
										letterwordfound = false
										letterword = tilename
										found = true
										ltype = -1
									end
									
									if (letterword_firstid == 0) then
										letterword_firstid = tileid
									end
									
									wordtile = true
									
									if secondaryfound then
										--if (string.len(tilename) == 1) then
											local prevdata = sent[wordid-1]
											--MF_alert(prevdata[1] .. " added to firstwords A" .. ", " .. tostring(wordid))
											table.insert(firstwords, {prevdata[3], dir})
										--else
											--MF_alert(tilename .. " added to firstwords B" .. ", " .. tostring(wordid))
											--table.insert(firstwords, {tileid, dir})
										--end
									end
									
									--MF_alert(letterword .. ", " .. lword .. ", " .. tostring(ltype) .. ", " .. tostring(found) .. ", " .. tostring(secondaryfound))
									
									if found then
										if (ltype == -1) then
											dontadd = true
											
											if (nexts[2] ~= 5) then
												stage = -1
												stop = true
											end
										else
											s = {lword, ltype, tileid}
											tiletype = ltype
											currtiletype = ltype
											tilename = lword
											
											if letterwordfound then
												local new = {}
												
												for a,b in ipairs(current) do
													if (a < #current) then
														table.insert(new, b)
													end
												end
												
												local newfinalid = #finals + 1
												finals[newfinalid] = {}
												for a,b in ipairs(new) do
													table.insert(finals[newfinalid], b)
												end
												
												current = finals[newfinalid]
												stage = letterword_prevstage
											end
											letterwordfound = false
											
											if (nexts[2] ~= 5) then
												letterword = ""
											else
												letterwordfound = true
												letterword_prevstage = stage
											end
										end
									else
										dontadd = true
										stop = true
									end
								end
								
								if (tiletype ~= 5) then
									if (stage == 0) then
										if (tiletype == 0) then
											prevstage = stage
											stage = 2
										elseif (tiletype == 3) then
											prevstage = stage
											stage = 1
										elseif (tiletype ~= 4) then
											prevstage = stage
											stage = -1
											stop = true
										end
									elseif (stage == 1) then
										if (tiletype == 0) then
											prevstage = stage
											stage = 2
										elseif (tiletype ~= 4) then
											prevstage = stage
											stage = -1
											stop = true
										end
									elseif (stage == 2) then
										if (wordid ~= #sentences) then
											if (tiletype == 1) and (prevtiletype ~= 4) and ((prevstage ~= 4) or doingcond or (stage3reached == false)) then
												stage2reached = true
												prevstage = stage
												stage = 3
											elseif ((tiletype == 7) and (stage2reached == false)) then
												doingcond = true
												prevstage = stage
												stage = 3
											elseif (tiletype == 6) then
												prevstage = stage
												stage = 4
											elseif (tiletype ~= 4) then
												prevstage = stage
												stage = -1
												stop = true
											end
										else
											stage = -1
											stop = true
										end
									elseif (stage == 3) then
										stage3reached = true
										
										if (tiletype == 0) or (tiletype == 2) then
											prevstage = stage
											stage = 5
										elseif (tiletype ~= 4) then
											stage = -1
											stop = true
										end
									elseif (stage == 4) then
										if (wordid < #sentences) then
											if (tiletype == 0) or ((tiletype == 2) and stage3reached) then
												prevstage = stage
												stage = 2
											elseif ((tiletype == 1) and stage3reached) then
												stage2reached = true
												prevstage = stage
												stage = 3
											elseif ((tiletype == 7) and (stage2reached == false)) then
												doingcond = true
												stage2reached = true
												prevstage = stage
												stage = 3
											elseif (tiletype ~= 4) then
												prevstage = stage
												stage = -1
												stop = true
											end
										else
											stage = -1
											stop = true
										end
									elseif (stage == 5) then
										if (wordid ~= #sentences) then
											if (tiletype == 1) and doingcond then
												stage2reached = true
												doingcond = false
												prevstage = stage
												stage = 3
											elseif (tiletype == 6) then
												prevstage = stage
												stage = 4
											elseif (tiletype ~= 4) then
												prevstage = stage
												stage = -1
												stop = true
											end
										else
											stage = -1
											stop = true
										end
									end
								end
								
								if (stage > 0) then
									firstrealword = true
								end
								
								if (tiletype == 4) then
									if (notstatus == 0) then
										notstatus = tileid
									end
								else
									if (stop == false) and (tiletype ~= 0) then
										notstatus = 0
									end
								end
								
								--MF_alert(tostring(k) .. "_" .. tostring(i) .. "_" .. tostring(wordid) .. ": " .. tilename .. ", " .. tostring(tiletype) .. ", " .. tostring(stop) .. ", " .. tostring(stage) .. ", " .. tostring(letterword_firstid).. ", " .. tostring(prevtiletype))
								
								if (stop == false) then
									if (dontadd == false) then
										table.insert(current, {tilename, tiletype, tileids})
										tileids = {}
									end
								else
									table.remove(tileids, #tileids)
									
									if (tiletype == 0) and (prevtiletype == 0) and (notstatus ~= 0) then
										notstatus = 0
									end
									
									if (wordid < #sentences) then
										if (wordid > 1) then
												
											if (notstatus ~= 0) and firstrealword then
												--MF_alert("Notstatus added to firstwords" .. ", " .. tostring(wordid))
												table.insert(firstwords, {notstatus, dir})
											else
												if (prevtiletype == 0) and ((tiletype == 1) or (tiletype == 7)) then
													if (letterword_firstid == 0) then
														--MF_alert(sent[wordid - 1][1] .. " added to firstwords C" .. ", " .. tostring(wordid))
														table.insert(firstwords, {sent[wordid - 1][3], dir})
													else
														--MF_alert("First letterword added to firstwords C" .. ", " .. tostring(wordid))
														table.insert(firstwords, {letterword_firstid, dir})
														table.insert(firstwords, {sent[wordid - 1][3], dir})
													end
												else
													if (letterword_firstid == 0) then
														--MF_alert(tilename .. " added to firstwords D" .. ", " .. tostring(wordid))
														table.insert(firstwords, {tileid, dir})
													else
														--MF_alert("First letterword added to firstwords D" .. ", " .. tostring(wordid))
														table.insert(firstwords, {letterword_firstid, dir})
														table.insert(firstwords, {tileid, dir})
													end
												end
											end
											
											break
										elseif (wordid == 1) and (blockfirstwords == false) then
											if (nexts[3] ~= -1) then
												--MF_alert(nexts[1] .. " added to firstwords E" .. ", " .. tostring(wordid))
												table.insert(firstwords, {nexts[3], dir})
											end
											
											break
										end
									end
								end
								
								if (tiletype ~= 5) and (wordtile == false) then
									letterword_firstid = 0
								end
							end
						end
						
						--MF_alert("Hm: " .. thissent .. ": " .. tostring(stop))
						
						combo = updatecombo(combo,variantcount)
					end
				end
				
				if (#finals > 0) then
					for i,sentence in ipairs(finals) do
						local group_objects = {}
						local group_targets = {}
						local group_conds = {}
						
						local group = group_objects
						local stage = 0
						
						local prefix = ""
						
						local allowedwords = {0}
						local allowedwords_extra = {}
						
						local testing = ""
						
						local extraids = {}
						local extraids_current = ""
						local extraids_ifvalid = {}
						
						local valid = true
						
						if (#finals > 1) then
							for a,b in ipairs(finals) do
								if (#b == #sentence) and (a > i) then
									local identical = true
									
									for c,d in ipairs(b) do
										local currids = d[3]
										local equivids = sentence[c][3] or {}
										
										for e,f in ipairs(currids) do
											--MF_alert(tostring(a) .. ": " .. tostring(f) .. ", " .. tostring(equivids[e]))
											if (f ~= equivids[e]) then
												identical = false
											end
										end
									end
									
									if identical then
										valid = false
									end
								end
							end
						end
						
						if valid then
							for index,wdata in ipairs(sentence) do
								local wname = wdata[1]
								local wtype = wdata[2]
								local wid = wdata[3]
								
								testing = testing .. wname .. ", "
								
								local wcategory = -1
								
								if (wtype == 1) or (wtype == 3) or (wtype == 7) then
									wcategory = 1
								elseif (wtype ~= 4) and (wtype ~= 6) then
									wcategory = 0
								else
									table.insert(extraids_ifvalid, {prefix .. wname, wtype, wid})
									extraids_current = wname
								end
								
								if (wcategory == 0) then
									local allowed = false
									
									for a,b in ipairs(allowedwords) do
										if (b == wtype) then
											allowed = true
										end
									end
									
									if (allowed == false) then
										for a,b in ipairs(allowedwords_extra) do
											if (wname == b) then
												allowed = true
											end
										end
									end
									
									if allowed then
										table.insert(group, {prefix .. wname, wtype, wid})
									else
										table.insert(firstwords, {wid[1], dir})
										break
									end
								elseif (wcategory == 1) then
									if (index < #sentence) then
										allowedwords = {0}
										allowedwords_extra = {}
										
										local realname = unitreference["text_" .. wname]
										local verbtype = ""
										local argtype = {0}
										local argextra = {}
										
										if (changes[realname] ~= nil) then
											local wchanges = changes[realname]
											verbtype = wchanges.operatortype or ""
											argtype = wchanges.argtype or {0}
											argextra = wchanges.argextra or {}
										end
										
										if (verbtype == "") then
											local wvalues = tileslist[realname] or {}
											verbtype = wvalues.operatortype or ""
											argtype = wvalues.argtype or {0}
											argextra = wvalues.argextra or {}
										end
										
										if (verbtype == "") then
											--MF_alert("No operatortype found for " .. wname .. "!")
											return
										else
											if (wtype == 1) then
												if (verbtype ~= "verb_all") then
													allowedwords = {0}
												else
													allowedwords = {0,2}
												end
												
												stage = 1
												local target = {prefix .. wname, wtype, wid}
												table.insert(group_targets, {target, {}})
												local sid = #group_targets
												group = group_targets[sid][2]
												
												newcondgroup = 1
											elseif (wtype == 3) then
												allowedwords = {0}
												local cond = {prefix .. wname, wtype, wid}
												table.insert(group_conds, {cond, {}})
											elseif (wtype == 7) then
												allowedwords = argtype
												allowedwords_extra = argextra
												
												stage = 2
												local cond = {prefix .. wname, wtype, wid}
												table.insert(group_conds, {cond, {}})
												local sid = #group_conds
												group = group_conds[sid][2]
											end
										end
									end
								end
								
								if (wtype == 4) then
									if (prefix == "not ") then
										prefix = ""
									else
										prefix = "not "
									end
								else
									prefix = ""
								end
								
								if (wname ~= extraids_current) and (string.len(extraids_current) > 0) and (wtype ~= 4) then
									for a,extraids_valid in ipairs(extraids_ifvalid) do
										table.insert(extraids, {prefix .. extraids_valid[1], extraids_valid[2], extraids_valid[3]})
									end
									
									extraids_ifvalid = {}
									extraids_current = ""
								end
							end
							--MF_alert("Testing: " .. testing)
							
							local conds = {}
							local condids = {}
							for c,group_cond in ipairs(group_conds) do
								local rule_cond = group_cond[1][1]
								--table.insert(condids, group_cond[1][3])
								
								condids = copytable(condids, group_cond[1][3])
								
								table.insert(conds, {rule_cond,{}})
								local condgroup = conds[#conds][2]
								
								for e,condword in ipairs(group_cond[2]) do
									local rule_condword = condword[1]
									--table.insert(condids, condword[3])
									
									condids = copytable(condids, condword[3])
									
									table.insert(condgroup, rule_condword)
								end
							end
							
							local delconds = {}
							
							for c,cond in ipairs(conds) do
								local condwords = cond[2]
								
								local anticondwords = {}
								local newcondwords = {}
								
								for g,condword in ipairs(condwords) do
									local isnot = string.sub(condword, 1, 3)
									
									if (isnot == "not") then
										table.insert(anticondwords, string.sub(condword, 5))
									else
										table.insert(newcondwords, condword)
									end
								end
								
								if (#anticondwords > 0) then
									local anticond = cond[1]
									
									if (string.sub(anticond, 1, 3) ~= "not") then
										anticond = "not " .. cond[1]
									end
									
									local newcond = {anticond, anticondwords}
									
									table.insert(conds, newcond)
									
									if (#newcondwords > 0) then
										cond[2] = newcondwords
									else
										table.insert(delconds, c)
									end
								end
							end
							
							local delcondoffset = 0
							for c,d in ipairs(delconds) do
								table.remove(conds, d - delcondoffset)
								delcondoffset = delcondoffset + 1
							end
							
							for c,group_object in ipairs(group_objects) do
								local rule_object = group_object[1]
								
								for d,group_target in ipairs(group_targets) do
									local rule_verb = group_target[1][1]
									
									for e,target in ipairs(group_target[2]) do
										local rule_target = target[1]
										
										local finalconds = {}
										for g,finalcond in ipairs(conds) do
											table.insert(finalconds, {finalcond[1], finalcond[2]})
										end
										
										local rule = {rule_object,rule_verb,rule_target}
										
										local ids = {}
										ids = copytable(ids, group_object[3])
										ids = copytable(ids, group_target[1][3])
										ids = copytable(ids, target[3])
										
										for g,h in ipairs(extraids) do
											ids = copytable(ids, h[3])
										end
										
										for g,h in ipairs(condids) do
											ids = copytable(ids, h)
										end
									
										addoption(rule,finalconds,ids)
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

function codecheck(unitid,ox,oy)
	local unit = mmf.newObject(unitid)
	local x,y = unit.values[XPOS]+ox,unit.values[YPOS]+oy
	local result = {}
	
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,b in ipairs(unitmap[tileid]) do
			local v = mmf.newObject(b)
			
			if (v.strings[UNITTYPE] == "text") then
				table.insert(result, b)
			else
				if (#wordunits > 0) then
					for c,d in ipairs(wordunits) do
						if (b == d[1]) and testcond(d[2], d[1]) then
							table.insert(result, b)
						end
					end
				end
			end
		end
	end
	
	return result
end

function addoption(option,conds_,ids,visible,notrule)
	--MF_alert(option[1] .. ", " .. option[2] .. ", " .. option[3])
	
	local visual = true
	
	if (visible ~= nil) then
		visual = visible
	end
	
	local conds = {}
	
	if (conds_ ~= nil) then
		conds = conds_
	else
		print("nil conditions in rule: " .. option[1] .. ", " .. option[2] .. ", " .. option[3])
	end
	
	if (#option == 3) then
		local rule = {option,conds,ids}
		table.insert(features, rule)
		local target = option[1]
		local verb = option[2]
		local effect = option[3]
	
		if (featureindex[effect] == nil) then
			featureindex[effect] = {}
		end
		
		if (featureindex[target] == nil) then
			featureindex[target] = {}
		end
		
		if (featureindex[verb] == nil) then
			featureindex[verb] = {}
		end
		
		table.insert(featureindex[effect], rule)
		
		table.insert(featureindex[verb], rule)
		
		if (target ~= effect) then
			table.insert(featureindex[target], rule)
		end
		
		if visual then
			local visualrule = copyrule(rule)
			table.insert(visualfeatures, visualrule)
		end
		
		if (notrule ~= nil) then
			local notrule_effect = notrule[1]
			local notrule_id = notrule[2]
			
			if (notfeatures[notrule_effect] == nil) then
				notfeatures[notrule_effect] = {}
			end
			
			local nr_e = notfeatures[notrule_effect]
			
			if (nr_e[notrule_id] == nil) then
				nr_e[notrule_id] = {}
			end
			
			local nr_i = nr_e[notrule_id]
			
			table.insert(nr_i, rule)
		end
		
		if (#conds > 0) then
			for i,cond in ipairs(conds) do
				if (cond[2] ~= nil) then
					if (#cond[2] > 0) then
						local alreadyused = {}
						local newconds = {}
						local allfound = false
						
						--alreadyused[target] = 1
						
						for a,b in ipairs(cond[2]) do
							if (b ~= "all") then
								alreadyused[b] = 1
								table.insert(newconds, b)
							else
								allfound = true
							end
						end
						
						if allfound then
							for a,mat in pairs(objectlist) do
								if (alreadyused[a] == nil) and (a ~= "group") and (a ~= "all") and (a ~= "text") then
									table.insert(newconds, a)
									alreadyused[a] = 1
								end
							end
						end
						
						cond[2] = newconds
					end
				end
			end
		end

		local targetnot = string.sub(target, 1, 3)
		local targetnot_ = string.sub(target, 5)
		
		if (targetnot == "not") and (objectlist[targetnot_] ~= nil) then
			for i,mat in pairs(objectlist) do
				if (i ~= "empty") and (i ~= "all") and (i ~= "level") and (i ~= "group") and (i ~= targetnot_) and (i ~= "text") then
					local rule = {i,verb,effect}
					--print(i .. " " .. verb .. " " .. effect)
					local newconds = {}
					for a,b in ipairs(conds) do
						table.insert(newconds, b)
					end
					addoption(rule,newconds,ids,false,{effect,#featureindex[effect]})
				end
			end
		end
		
		if (effect == "all") then
			if (verb ~= "is") then 
				for i,mat in pairs(objectlist) do
					if (i ~= "empty") and (i ~= "all") and (i ~= "level") and (i ~= "group") and (i ~= "text") then
						local rule = {target,verb,i}
						local newconds = {}
						for a,b in ipairs(conds) do
							table.insert(newconds, b)
						end
						addoption(rule,newconds,ids,false)
					end
				end
			end
		end

		if (target == "all") then
			for i,mat in pairs(objectlist) do
				if (i ~= "empty") and (i ~= "all") and (i ~= "level") and (i ~= "group") and (i ~= "text") then
					local rule = {i,verb,effect}
					local newconds = {}
					for a,b in ipairs(conds) do
						table.insert(newconds, b)
					end
					addoption(rule,newconds,ids,false)
				end
			end
		end
	end
end

function postrules()
	local notfeatures = {}
	local limit = #features
	local newruleids = {}
	local ruleeffectlimiter = {}
	local playrulesound = false
	
	local rulesoundshort = ""
	
	local protects = {}
	
	for i,rules in ipairs(features) do
		if (i <= limit) then
			local rule = rules[1]
			local conds = rules[2]
			local ids = rules[3]
			
			if (rule[1] == rule[3]) and (rule[2] == "is") then
				table.insert(protects, i)
			end
			
			if (ids ~= nil) then
				local works = true
				local idlist = {}
				local effectsok = false
				
				if (#ids > 0) then
					for a,b in ipairs(ids) do
						table.insert(idlist, b)
					end
				end
				
				if (#idlist > 0) and works then
					for a,d in ipairs(idlist) do
						for c,b in ipairs(d) do
							if (b ~= 0) then
								local bunit = mmf.newObject(b)
								
								if (bunit.strings[UNITTYPE] == "text") then
									setcolour(b,"active")
								end
								newruleids[b] = 1
								
								if (ruleids[b] == nil) and (#undobuffer > 1) then
									if (ruleeffectlimiter[b] == nil) then
										local x,y = bunit.values[XPOS],bunit.values[YPOS]
										local c1,c2 = getcolour(b,"active")
										MF_particles("bling",x,y,5,c1,c2,1,1)
										ruleeffectlimiter[b] = 1
									end
									playrulesound = true
								end
							end
						end
					end
				elseif (#idlist > 0) and (works == false) then
					for a,visualrules in pairs(visualfeatures) do
						local vrule = visualrules[1]
						local same = comparerules(rule,vrule)
						
						if same then
							table.remove(visualfeatures, a)
						end
					end
				end
			end

			local rulenot = 0
			local neweffect = ""
			
			local nothere = string.sub(rule[3], 1, 3)
			
			if (nothere == "not") then
				rulenot = 1
				neweffect = string.sub(rule[3], 5)
			end
			
			if (rulenot == 1) then
				local newconds = {}
				
				if (#conds > 0) then
					for a,cond in ipairs(conds) do
						local newcond = {cond[1],cond[2]}
						local condname = cond[1]
						local params = cond[2]
						
						local prefix = string.sub(condname, 1, 3)
						
						if (prefix == "not") then
							condname = string.sub(condname, 5)
						else
							condname = "not " .. condname
						end
						
						newcond[1] = condname
						newcond[2] = {}
						
						if (#params > 0) then
							for m,n in ipairs(params) do
								table.insert(newcond[2], n)
							end
						end
						
						table.insert(newconds, newcond)
					end
				else
					table.insert(newconds, {"never"})
				end
				
				local newbaserule = {rule[1],rule[2],neweffect}
				
				local target = rule[1]
				local verb = rule[2]
				
				for a,b in ipairs(featureindex[target]) do
					local same = comparerules(newbaserule,b[1])
					
					if same then
						--MF_alert(rule[1] .. ", " .. rule[2] .. ", " .. neweffect .. ": " .. b[1][1] .. ", " .. b[1][2] .. ", " .. b[1][3])
						local theseconds = b[2]
						
						if (#newconds > 0) then
							if (newconds[1] ~= "never") then
								for c,d in ipairs(newconds) do
									table.insert(theseconds, d)
								end
							else
								theseconds = {"never"}
							end
						end
						
						b[2] = theseconds
					end
				end
			end
		end
	end
	
	if (#protects > 0) then
		for i,v in ipairs(protects) do
			local rule = features[v]
			
			local baserule = rule[1]
			local conds = rule[2]
			
			local target = baserule[1]
			
			local newconds = {{"never"}}
			
			if (conds[1] ~= "never") then
				if (#conds > 0) then
					newconds = {}
					
					for a,b in ipairs(conds) do
						local condword = b[1]
						local condgroup = {}
						
						local newcondword = "not " .. condword
						
						if (string.sub(condword, 1, 3) == "not") then
							newcondword = string.sub(condword, 5)
						end
						
						if (b[2] ~= nil) then
							for c,d in ipairs(b[2]) do
								table.insert(condgroup, d)
							end
						end
						
						table.insert(newconds, {newcondword, condgroup})
					end
				end		
			
				if (featureindex[target] ~= nil) then
					for a,rules in ipairs(featureindex[target]) do
						local targetrule = rules[1]
						local targetconds = rules[2]
						
						local object = targetrule[3]
						
						if (targetrule[1] == target) and (targetrule[2] == "is") and (target ~= object) and (getmat(object) ~= nil) and (object ~= "group") then
							if (#newconds > 0) then
								if (newconds[1] == "never") then
									targetconds = {}
								end
								
								for c,d in ipairs(newconds) do
									table.insert(targetconds, d)
								end
							end
							
							rules[2] = targetconds
						end
					end
				end
			end
		end
	end
	
	ruleids = newruleids
	
	if playrulesound then
		local pmult,sound = checkeffecthistory("rule")
		rulesoundshort = sound
		local rulename = "rule" .. tostring(math.random(1,5)) .. rulesoundshort
		MF_playsound(rulename)
	end
	
	ruleblockeffect()
end

function iscond(word)
	local found = false
	
	for i,v in pairs(conditions) do
		if (word == i) or (word == "not " .. i) then
			found = true
			local args = v.arguments
			return true,args
		end
	end
	
	return false,0
end

function grouprules()
	local isgroup = {}
	local groupis = {}
	local groups = findgroup()
	
	if (featureindex["group"] ~= nil) then
		for i,rule in ipairs(featureindex["group"]) do
			local baserule = rule[1]
			local conds = rule[2]
			
			if (baserule[1] == "group") then
				table.insert(groupis, rule)
			end

			if (baserule[3] == "group") and (baserule[1] ~= "group") then
				table.insert(isgroup, rule)
			end
		end
	end
	
	local ends = {}
	local starts = {}
	
	if (#groupis > 0) then
		for i,rule in ipairs(groupis) do
			local baserule = rule[1]
			local conds = rule[2]
			local ids = rule[3]
			
			local verb = baserule[2]
			local effect = baserule[3]
			
			table.insert(ends, {effect,verb,conds,ids})
		end
	end			
	
	if (#isgroup > 0) then
		for i,rule in ipairs(isgroup) do
			local baserule = rule[1]
			local conds = rule[2]
			local ids = rule[3]
			
			local verb = baserule[2]
			local target = baserule[1]
			
			table.insert(starts, {target,verb,conds,ids})
		end
	end
	
	for i,v in ipairs(starts) do
		local ids = v[4]
		
		if (v[2] ~= "is") then
			local conds = {}
			if (#v[3] > 0) then
				for a,b in ipairs(v[3]) do
					table.insert(conds, b)
				end
			end
			
			for a,b in ipairs(starts) do
				if (b[2] == "is") then
					if (#b[3] > 0) then
						for c,d in ipairs(b[3]) do
							table.insert(conds, d)
						end
					end
					
					addoption({v[1],v[2],b[1]},conds,ids,false)
				end
			end
		end
		
		for a,b in ipairs(ends) do
			local conds = {}
			
			if (#v[3] > 0) then
				for c,d in ipairs(v[3]) do
					table.insert(conds, d)
				end
			end
			
			if (#b[3] > 0) then
				for c,d in ipairs(b[3]) do
					table.insert(conds, d)
				end
			end
			
			if (v[2] == "is") then
				addoption({v[1],b[2],b[1]},conds,ids,false)
			end
		end
	end
	
	if (#features > 0) and (#groups > 0) then
		for i,rules in ipairs(features) do
			local rule = rules[1]
			local conds = rules[2]
			
			if (#conds > 0) then
				for m,n in ipairs(conds) do
					if (n[2] ~= nil) then
						if (#n[2] > 0) then
							local thisrule = n[2]
							local limit = #n[2]
							local delthese = {}

							for a=1,limit do
								local b = thisrule[a]
								
								if (b == "group") then
									if (#groups > 0) then
										for c,d in ipairs(groups) do
											if (d[1] ~= "group") then
												table.insert(n[2], d[1])
												
												if (d[2] ~= nil) then
													for e,f in ipairs(d[2]) do
														if (f ~= "group") then
															table.insert(n[2], f)
														end
													end
												end
											end
										end
									end
									
									table.insert(delthese, a)
								end
							end
							
							if (#delthese > 0) then
								local offset = 0
								for a,b in ipairs(delthese) do
									local id = b + offset
									table.remove(n[2], id)
									offset = offset - 1
								end
							end
						end
					end
				end
			end
		end
	end
end

function copyrule(rule)
	local baserule = rule[1]
	local conds = rule[2]
	local ids = rule[3]
	
	local newbaserule = {}
	local newconds = {}
	local newids = {}
	
	newbaserule = {baserule[1],baserule[2],baserule[3]}
	
	if (#conds > 0) then
		for i,cond in ipairs(conds) do
			local newcond = {cond[1]}
			
			if (cond[2] ~= nil) then
				local condnames = cond[2]
				newcond[2] = {}
				
				for a,b in ipairs(condnames) do
					table.insert(newcond[2], b)
				end
			end
			
			table.insert(newconds, newcond)
		end
	end
	
	if (#ids > 0) then
		for i,id in ipairs(ids) do
			local iid = {}
			
			for a,b in ipairs(id) do
				table.insert(iid, b)
			end
			
			table.insert(newids, iid)
		end
	end
	
	local newrule = {newbaserule,newconds,newids}
	
	return newrule
end

function updatecombo(combo_,variants)
	local increment = 1
	local combo = {}
	
	for i,v in ipairs(variants) do
		combo[i] = combo_[i]
		if (v > 1) then
			combo[i] = combo[i] + increment
			increment = 0
			
			if (combo[i] > v) then
				combo[i] = 1
				increment = 1
			end
		elseif (v == 0) then
			--print("no variants here?")
		end
	end
	
	if (increment == 0) then
		return combo
	else
		return nil
	end
end

function comparerules(baserule1,baserule2)
	local same = true
	
	for i,v in ipairs(baserule1) do
		if (v ~= baserule2[i]) then
			same = false
		end
	end
	
	return same
end

function findwordunits()
	local result = {}
	local alreadydone = {}
	local checkrecursion = {}
	
	local identifier = ""
	
	if (featureindex["word"] ~= nil) then
		for i,v in ipairs(featureindex["word"]) do
			local rule = v[1]
			local conds = v[2]
			local ids = v[3]
			
			local name = rule[1]
			
			if (objectlist[name] ~= nil) and (name ~= "text") and (alreadydone[name] == nil) then
				local these = findall({name,{}})
				alreadydone[name] = 1
				
				if (#these > 0) then
					for a,b in ipairs(these) do
						local bunit = mmf.newObject(b)
						table.insert(result, {b, conds})
						identifier = identifier .. name
						-- LISÄÄ TÄHÄN LISÄÄ DATAA
					end
				end
			end
			
			for a,b in ipairs(conds) do
				local condtype = b[1]
				local params = b[2] or {}
				
				identifier = identifier .. condtype
				
				if (#params > 0) then
					for c,d in ipairs(params) do
						identifier = identifier .. tostring(d)
					end
				end
			end
			
			--MF_alert("Going through " .. name)
			
			if (#ids > 0) then
				if (#ids[1] == 1) then
					local firstunit = mmf.newObject(ids[1][1])
					
					local notname = name
					if (string.sub(name, 1, 3) == "not") then
						notname = string.sub(name, 5)
					end
					
					if (firstunit.strings[UNITNAME] ~= "text_" .. name) and (firstunit.strings[UNITNAME] ~= "text_" .. notname) then
						--MF_alert("Checking recursion for " .. name)
						table.insert(checkrecursion, {name, i})
					end
				end
			else
				MF_alert("No ids listed in Word-related rule! rules.lua line 1302 - this needs fixing asap (related to grouprules line 1118)")
			end
		end
		
		for a,checkname_ in ipairs(checkrecursion) do
			local found = false
			
			local checkname = checkname_[1]
			
			local b = checkname
			if (string.sub(b, 1, 3) == "not") then
				b = string.sub(checkname, 5)
			end
			
			for i,v in ipairs(featureindex["word"]) do
				local rule = v[1]
				local ids = v[3]
				
				if (rule[1] == b) or (rule[1] == "all") or ((rule[1] ~= b) and (string.sub(rule[1], 1, 3) == "not")) then
					for c,g in ipairs(ids) do
						for a,d in ipairs(g) do
							local idunit = mmf.newObject(d)
							
							-- Tässä pitäisi testata myös Group!
							if (idunit.strings[UNITNAME] == "text_" .. rule[1]) or (rule[1] == "all") then
								--MF_alert("Matching objects - found")
								found = true
							elseif (rule[1] == "group") then
								--MF_alert("Group - found")
								found = true
							elseif (rule[1] ~= checkname) and (string.sub(rule[1], 1, 3) == "not") then
								--MF_alert("Not Object - found")
								found = true
							end
						end
					end
				end
			end
			
			if (found == false) then
				--MF_alert("Wordunit status for " .. b .. " is unstable!")
				identifier = "null"
				wordunits = {}
				
				for i,v in pairs(featureindex["word"]) do
					local rule = v[1]
					local ids = v[3]
					
					--MF_alert("Checking to disable: " .. rule[1] .. " " .. ", not " .. b)
					
					if (rule[1] == b) or (rule[1] == "not " .. b) then
						v[2] = {{"never",{}}}
					end
				end
				
				if (string.sub(checkname, 1, 3) == "not") then
					local notrules_word = notfeatures["word"]
					local notrules_id = checkname_[2]
					local disablethese = notrules_word[notrules_id]
					
					for i,v in ipairs(disablethese) do
						v[2] = {{"never",{}}}
					end
				end
			end
		end
	end
	
	--MF_alert("Current id (end): " .. identifier)
	
	return result,identifier
end

function findword(text,nexts,tilename)
	local name = ""
	local wtype = -1
	local found = false
	local secondaryfound = false
	
	local alttext = "text_" .. text
	
	if (string.len(text) > 0) then
		for i,v in pairs(unitreference) do
			if (string.len(text) > string.len(tilename) + 1) and (string.sub(i, 1, 2) == string.sub(text, -2)) and (i ~= text) then
				--MF_alert(i .. ", " .. text .. ", " .. tilename)
				secondaryfound = true
			end
			
			if (string.len(text) > string.len(tilename) + 1) and (string.sub(i, 1, 7) == "text_" .. string.sub(text, -2)) and (i ~= alttext) then
				--MF_alert(i .. ", " .. text .. ", " .. tilename)
				secondaryfound = true
			end
			
			if (string.len(i) >= string.len(text)) and (string.sub(i, 1, string.len(text)) == text) then
				found = true
			end
			
			if (string.len(i) >= string.len(alttext)) and (string.sub(i, 1, string.len(alttext)) == alttext) then
				found = true
			end
		end
	else
		found = true
	end
	
	if (string.len(text) > string.len(tilename)) and ((unitreference[text] ~= nil) or (unitreference[alttext] ~= nil)) then
		local realname = unitreference[text] or unitreference[alttext]
		
		local tiledata = tileslist[realname]
		
		if (tiledata ~= nil) then
			name = tiledata.name
			wtype = tonumber(tiledata.type) or 0
		end
		
		if (changes[realname] ~= nil) then
			local c = changes[realname]
			
			if (c.name ~= nil) then
				name = c.name
			end
			
			if (c.type ~= nil) then
				wtype = tonumber(c.type)
			end
		end
		
		if (unitreference[text] ~= nil) then
			objectlist[text] = 1
		elseif (((text == "all") or (text == "empty")) and (unitreference[alttext] ~= nil)) then
			objectlist[text] = 1
		end
		
		if (string.sub(name, 1, 5) == "text_") then
			name = string.sub(name, 6)
		end
		
		if (wtype == 5) then
			wtype = -1
		end
	end
	
	return name,wtype,found,secondaryfound
end

function ruleblockeffect()
	local handled = {}
	
	for i,rules in pairs(features) do
		local rule = rules[1]
		local conds = rules[2]
		local ids = rules[3]
		local blocked = false
		
		for a,b in ipairs(conds) do
			if (b[1] == "never") then
				blocked = true
				break
			end
		end
		
		--MF_alert(rule[1] .. " " .. rule[2] .. " " .. rule[3] .. ": " .. tostring(blocked))
		
		if blocked then
			for a,d in ipairs(ids) do
				for c,b in ipairs(d) do
					if (handled[b] == nil) then
						local blockid = MF_create("Ingame_blocked")
						local bunit = mmf.newObject(blockid)
						
						local runit = mmf.newObject(b)
						
						bunit.x = runit.x
						bunit.y = runit.y
						
						bunit.values[XPOS] = runit.values[XPOS]
						bunit.values[YPOS] = runit.values[YPOS]
						bunit.layer = 1
						bunit.values[ZLAYER] = 20
						bunit.values[TYPE] = b
						
						local c1,c2 = getuicolour("blocked")
						MF_setcolour(blockid,c1,c2)
						
						handled[b] = 2
					end
				end
			end
		else
			for a,d in ipairs(ids) do
				for c,b in ipairs(d) do
					if (handled[b] == nil) then
						handled[b] = 1
					elseif (handled[b] == 2) then
						MF_removeblockeffect(b)
					end
				end
			end
		end
	end
end

function getsentencevariant(sentences,combo)
	local result = {}
	
	for i,words in ipairs(sentences) do
		local currcombo = combo[i]
		
		local current = words[currcombo]
		
		table.insert(result, current)
	end
	
	return result
end