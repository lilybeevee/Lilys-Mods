function code()
	if featureindex["beam"] and #featureindex["beam"] > 0 then
		updatecode = 1
	end

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

		if meansidentifier ~= nil then
			prevmeansidentifier = meansidentifier
		else
			prevmeansidentifier = ""
		end
		if altfeatures == nil then
			altfeatures = {}
		end
		if notaltfeatures == nil then
			notaltfeatures = {}
		end
		
		sentencecount = 0
		sentencemap = {}
		features = {}
		featureindex = {}
		visualfeatures = {}
		notfeatures = {}
		macros = {}
		isactive = {}
		hasany = false
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
			altfeatures,notaltfeatures,meansidentifier = meansrules()
			updatecode = 0
			dobeams()
			postrules()
			
			if doingundo then
				dotimelesscolours()
			end
			local newwordunits,newwordidentifier = findwordunits()
			
			--MF_alert("ID comparison: " .. newwordidentifier .. " - " .. wordidentifier)

			if hasany then
				updatecode = 1
			end
			
			if (newwordidentifier ~= wordidentifier) or (meansidentifier ~= prevmeansidentifier) then
				updatecode = 1
			else
				codeloops = 0
				--domaprotation()
			end

			if updatecode == 1 then
				code()
			end
		end
	end
end


function dumpobj(o)
   if type(o) == 'table' then
      local s = '{'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. simpledump(v) .. ','
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

function simpledump(o)
	if type(o) == 'table' then
		if o[1] == nil then
			return dumpobj(o)
		else
			local s = '{'
			for k,v in pairs(o) do
				s = s .. simpledump(v)
				if k < #o then
					s = s .. ','
				end
			end
			return s .. '}'
		end
	else
		return tostring(o)
	end
end

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
												doingcond = false
												prevstage = stage
												stage = 3
											elseif ((tiletype == 7) and (not doingcond or activemod.condition_stacking) and (stage2reached == false)) then
												doingcond = true
												prevstage = stage
												stage = 3
											elseif (tiletype == 6) and (prevtiletype ~= 4) then
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
										elseif (tiletype == 3) and doingcond and activemod.condition_stacking then
											prevstage = stage
											stage = 1
										elseif (tiletype ~= 4) then
											stage = -1
											stop = true
										end
									elseif (stage == 4) then
										if (wordid < #sentences) then
											if (tiletype == 0) or ((tiletype == 2) and stage3reached) then
												prevstage = stage
												stage = 2
											elseif ((tiletype == 1) and stage3reached) and (doingcond == false) then
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
											if (tiletype == 1) and doingcond and (prevtiletype ~= 4) then
												stage2reached = true
												doingcond = false
												prevstage = stage
												stage = 3
											elseif (tiletype == 7) and doingcond then
												prevstage = stage
												stage = 3
											elseif (tiletype == 6) and (prevtiletype ~= 4) then
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

						local condstack = false
						local doingand = false
						local hasproperty = false
						
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

								if wtype == 6 then
									doingand = true
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
										if wtype == 2 then
											hasproperty = true
										end
										doingand = false
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
										
										if (tileslist[realname] ~= nil) then
											local wvalues = tileslist[realname]
											verbtype = wvalues.operatortype or verbtype
											argtype = wvalues.argtype or argtype
											argextra = wvalues.argextra or argextra
										end

										if (changes[realname] ~= nil) then
											local wchanges = changes[realname]
											verbtype = wchanges.operatortype or verbtype
											argtype = wchanges.argtype or argtype
											argextra = wchanges.argextra or argextra
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
												if not condstack then
													table.insert(group_conds, {cond, {}})
												else
													table.insert(group, {cond, {}})
												end
											elseif (wtype == 7) then
												allowedwords = argtype
												allowedwords_extra = argextra

												if condstack and doingand then
													condstack = false
												end
												doingand = false
												hasproperty = false

												stage = 2
												local cond = {prefix .. wname, wtype, wid}
												if not condstack then
													table.insert(group_conds, {cond, {}})
													local sid = #group_conds
													group = group_conds[sid][2]
													condstack = true
												else
													table.insert(group, {cond, {}})
													local sid = #group
													group = group[sid][2]
												end
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
							local function docondloop(group_conds,condids)
								local conds = {}
								for c,group_cond in ipairs(group_conds) do
									local rule_cond = group_cond[1][1]
									--table.insert(condids, group_cond[1][3])
									
									condids = copytable(condids, group_cond[1][3])
									
									table.insert(conds, {rule_cond,{}})
									local condgroup = conds[#conds][2]
									
									for e,condword in ipairs(group_cond[2]) do
										if #condword == 2 then
											table.insert(condgroup, docondloop({condword},condids))
										else
											local rule_condword = condword[1]
											--table.insert(condids, condword[3])
											
											condids = copytable(condids, condword[3])
											
											table.insert(condgroup, rule_condword)
										end
									end
								end
								return conds
							end

							conds = docondloop(group_conds,condids)
							
							local function cleanconds(conds)
								local delconds = {}
								
								for c,cond in ipairs(conds) do
									local condwords = cond[2]
									
									local anticondwords = {}
									local newcondwords = {}
									
									for g,condword in ipairs(condwords) do
										if type(condword) == "table" then
											cleanconds(condword)
										else
											local isnot = string.sub(condword, 1, 3)
											
											if (isnot == "not") then
												table.insert(anticondwords, string.sub(condword, 5))
											else
												table.insert(newcondwords, condword)
											end
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
							end
							cleanconds(conds)
							
							for c,group_object in ipairs(group_objects) do
								local rule_object = group_object[1]
								
								for d,group_target in ipairs(group_targets) do
									local rule_verb = group_target[1][1]
									
									for e,target in ipairs(group_target[2]) do
										local rule_target = target[1]
										
										local function addfinalconds(conds)
											local finalconds = {}
											for g,finalcond in ipairs(conds) do
												--[[if type(finalcond[2]) == "table" then
													table.insert(finalconds, {finalcond[1], addfinalconds(finalcond[2])})
												else]]
													table.insert(finalconds, {finalcond[1], finalcond[2]})
												--end
											end
											return finalconds
										end
										local finalconds = addfinalconds(conds)
										
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
	
	if not timelessturn then
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
	else
		if gettag(unitid,"timepos") then
			local newpos = gettag(unitid,"timepos")
			x,y = newpos[1]+ox,newpos[2]+oy
			tileid = x + y * roomsizex
		end
		if (timemap[tileid] ~= nil) then
			for i,b in ipairs(timemap[tileid]) do
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
	end
	
	return result
end

-- MEANS START
function iteratealtoptions(newoptions,fulltable,itable,index)
	for i,v in ipairs(newoptions[index]) do
		local newtable = {}
		for j=1,#itable do
			newtable[j] = itable[j]
		end
		table.insert(newtable, v)
		if index == #newoptions then
			table.insert(fulltable, newtable)
		else
			iteratealtoptions(newoptions,fulltable,newtable,index+1)
		end
	end
end

function applyaltfeatures(option,conds,ids,visible,notrule)
	local newoptions = {}
	local hasmeans = false
	local validoption = true
	for i=1,#option do
		newoptions[i] = {}
		local validfeatures,hasfeatures = getaltfeatures(option[i])
		if hasfeatures then
			newoptions[i] = validfeatures
			hasmeans = true
		else
			newoptions[i] = {option[i]}
		end
	end
	local newconds = {}
	if conds ~= nil then
		local function applyconds(conds)
			local newconds = {}
			for _,cond in ipairs(conds) do
				local targets = cond[2]

				local alreadyadded = {}
				local newtargets = {}

				for i=1,#targets do
					if type(targets[i]) == "table" then
						table.insert(newtargets, applyconds(targets[i]))
					else
						local validfeatures,hasfeatures = getaltfeatures(targets[i])
						if hasfeatures then
							for _,newtarget in ipairs(validfeatures) do
								if not alreadyadded[newtarget] then
									table.insert(newtargets, newtarget)
									alreadyadded[newtarget] = true
								end
							end
							hasmeans = true
						elseif not alreadyadded[targets[i]] then
							table.insert(newtargets, targets[i])
							alreadyadded[targets[i]] = true
						end
					end
				end
				if #targets > 0 and #newtargets == 0 then
					validoption = false
				end

				table.insert(newconds, {cond[1],newtargets})
			end
			return newconds
		end
		newconds = applyconds(conds)
	end
	if hasmeans then
		local alttable = {}
		iteratealtoptions(newoptions,alttable,{},1)
		for _,nopt in ipairs(alttable) do
			if #nopt == 0 then
				validoption = false
			end
			if validoption then
				addoption(nopt,newconds,ids,visible,notrule,true)
			end
		end
		return true
	end
	return false
end

function addmacros(option,ids,ignoremeans)
	for k,v in pairs(activemod.macros) do
		local wordi = 0
		local valid = true
		local vars = {}
		for word in string.gmatch(k, "%S+") do
			wordi = wordi + 1

			local isvar = ""
			if string.sub(word, 1, 1) == "{" then
				isvar = string.sub(word, 2, -2)
			end

			if isvar == "" and option[wordi] ~= word then
				valid = false
			elseif isvar ~= "" then
				if vars[isvar] and vars[isvar] ~= word then
					valid = false
				else
					vars[isvar] = option[wordi]
				end
			end
		end

		if valid then
			for _,text in ipairs(v) do
				local rules,conds = rulefromtext(text,vars)
				if rules ~= nil then
					for _,i in ipairs(rules[1]) do
						for _,j in ipairs(rules[2]) do
							for _,k in ipairs(rules[3]) do
								addoption({i,j,k},conds,ids,false,nil,ignoremeans,option)
							end
						end
					end
				end
			end
		end
	end
end


function addoption(option,conds_,ids,visible,notrule,ignoremeans,baserule)
	if not ignoremeans and #option == 3 then
		local hasmeans = applyaltfeatures(option,conds_,ids,visible,notrule)

		if hasmeans then
			return
		end
	end

	if not baserule and #option == 3 then
		addmacros(option,ids,ignoremeans)
	end

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

		if option[2] ~= "means" then
			sentencecount = sentencecount + 1
			for _,idlist in ipairs(ids) do
				for _,id in ipairs(idlist) do
					if sentencemap[id] == nil then
						sentencemap[id] = {}
					end
					table.insert(sentencemap[id], sentencecount)
				end
			end
		end
	
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
		
		local function fixgroupconds(conds)
			if (#conds > 0) then
				for i,cond in ipairs(conds) do
					if (cond[2] ~= nil) then
						if (#cond[2] > 0) then
							local alreadyused = {}
							local newconds = {}
							local allfound = false
							
							--alreadyused[target] = 1
							
							for a,b in ipairs(cond[2]) do
								if (type(b) == "table") then
									fixgroupconds(b)
									table.insert(newconds, b)
								elseif (b ~= "all") then
									alreadyused[b] = 1
									table.insert(newconds, b)
								else
									allfound = true
								end
							end
							
							if allfound then
								for a,mat in pairs(objectlist) do
									if (alreadyused[a] == nil) and (a ~= "group") and (a ~= "all") and (a ~= "text") and (a ~= "any") then
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
		end
		fixgroupconds(conds)

		local targetnot = string.sub(target, 1, 3)
		local targetnot_ = string.sub(target, 5)

		local effectnot = string.sub(effect, 1, 3)
		local effectnot_ = string.sub(effect, 5)
		
		if (targetnot == "not") and (objectlist[targetnot_] ~= nil) then
			for i,mat in pairs(objectlist) do
				if (i ~= "empty") and (i ~= "all") and (i ~= "level") and (i ~= "group") and (i ~= targetnot_) and (i ~= "text") and (i ~= "any") then
					local rule = {i,verb,effect}
					--print(i .. " " .. verb .. " " .. effect)
					local newconds = {}
					for a,b in ipairs(conds) do
						table.insert(newconds, b)
					end
					addoption(rule,newconds,ids,false,{effect,#featureindex[effect]},true)
				end
			end
		end
		
		if (effect == "all") then
			if (verb ~= "is") then 
				for i,mat in pairs(objectlist) do
					if (i ~= "empty") and (i ~= "all") and (i ~= "level") and (i ~= "group") and (i ~= "text") and (i ~= "any") then
						local rule = {target,verb,i}
						local newconds = {}
						for a,b in ipairs(conds) do
							table.insert(newconds, b)
						end
						addoption(rule,newconds,ids,false,nil,true)
					end
				end
			end
		end

		if (target == "all") then
			for i,mat in pairs(objectlist) do
				if (i ~= "empty") and (i ~= "all") and (i ~= "level") and (i ~= "group") and (i ~= "text") and (i ~= "any") then
					local rule = {i,verb,effect}
					local newconds = {}
					for a,b in ipairs(conds) do
						table.insert(newconds, b)
					end
					addoption(rule,newconds,ids,false,nil,true)
				end
			end
		end

		if (target == "any" or targetnot_ == "any") or (effect == "any" or effectnot_ == "any") then
			local newtarget = nil
			local neweffect = nil
			if chosenany then
				for _,v in ipairs(chosenany) do
					local lastids = v[3]
					if #lastids == #ids then
						local match = true
						for i,id in ipairs(lastids) do
							if ids[i][1] ~= id[1] then
								match = false
							end
						end
						if match then
							newtarget = v[1]
							neweffect = v[2]
							break
						end
					end
				end
			end
			if newtarget == nil or neweffect == nil then
				local options = {}
				for d,mat in pairs(objectlist) do
					if (d ~= "group") and (d ~= "all") and (d ~= "any") and (d ~= "text") then
						if unitlists[d] and #unitlists[d] > 0 then 
							table.insert(options, d)
						end
					end
				end
				--[[if not objectlist["text"] then
					table.insert(options, "text")
				end]]
				if #options > 0 then
					if newtarget == nil and (target == "any" or targetnot_ == "any") then
						newtarget = options[math.random(1,#options)]
					end
					if neweffect == nil and (effect == "any" or effectnot_ == "any") then
						neweffect = options[math.random(1,#options)]
					end
				end
			end
			if newtarget or neweffect then
				table.insert(chosenany,{newtarget,neweffect,ids})
				if not newtarget then
					newtarget = target
				end
				if not neweffect then
					neweffect = effect
				end
				if targetnot == "not" then
					newtarget = "not " .. newtarget
				end
				if effectnot == "not" then
					neweffect = "not " .. neweffect
				end
				local rule = {newtarget,verb,neweffect}
				local newconds = {}
				for a,b in ipairs(conds) do
					table.insert(newconds, b)
				end
				addoption(rule,newconds,ids,false,nil,true)
			end
			hasany = true
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
									isactive[b] = true
								end
								newruleids[b] = 1
								
								if (ruleids[b] == nil) and ((#undobuffer > 1) or autoturn) then
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

-- MEANS START
function meansrules()
	local result = {}
	local notresult = {}
	local identifier = ""
	local firstmeans = {}
	for _,unitid in ipairs(codeunits) do
		local unit = mmf.newObject(unitid)
		local type = unit.values[TYPE]

		if type == 8 then
			local x,y = unit.values[XPOS],unit.values[YPOS]
			local ox,oy,nox,noy = 0,0
			local tileid = x + y * roomsizex

			setcolour(unit.fixed)
			
			for i=1,2 do
				local drs = dirs[i+2]
				local ndrs = dirs[i]
				ox = drs[1]
				oy = drs[2]
				nox = ndrs[1]
				noy = ndrs[2]
				
				local hm = codecheck(unitid,ox,oy)
				local hm2 = codecheck(unitid,nox,noy)
				
				if (#hm > 0) and (#hm2 > 0) then
					table.insert(firstmeans, {unitid, drs, ndrs})
				end
			end
		end
	end
	local finals = {}
	local notmeans = {}
	local protects = {}
	for _,v in ipairs(firstmeans) do
		local unitid = v[1]
		local allids = {}
		local targets,targetids,isnot = buildmeanssentence(unitid, v[2], true)
		local effects,effectids = buildmeanssentence(unitid, v[3], false)

		if #targets > 0 and #effects > 0 then
			for _,id in ipairs(targetids) do
				table.insert(allids, {id})
			end

			for _,id in ipairs(effectids) do
				table.insert(allids, {id})
			end

			table.insert(allids, {unitid})

			for _,target in ipairs(targets) do
				for _,effect in ipairs(effects) do
					if isnot then
						table.insert(notmeans, {target, effect})
						table.insert(finals, {{target,"not means",effect},{},allids})
					else
						table.insert(finals, {{target,"means",effect},{},allids})
						if target == effect and #effects == 1 then
							table.insert(protects, #finals)
						end
					end
				end
			end
		end
	end
	for _,v in ipairs(notmeans) do
		local target = v[1]
		local effect = v[2]

		local nottarget = false
		if (string.sub(target, 1, 3) == "not") then
			target = string.sub(target, 5)
			nottarget = true
		end

		for a,b in ipairs(finals) do
			local rule = b[1]
			local conds = b[2]
			if rule[2] ~= "not means" and rule[3] == effect then
				local target2 = rule[1]

				local nottarget2 = false
				if (string.sub(target2, 1, 3) == "not") then
					target2 = string.sub(target2, 5)
					nottarget2 = true
				end

				if (not nottarget and target == rule[1]) or (nottarget and ((not nottarget2 and target ~= target2) or (nottarget2 and target == target2))) then
					conds = {{"never",{}}}
					finals[a][2] = conds
				end
			end
		end
	end
	for _,v in ipairs(protects) do
		local prule = finals[v][1]
		local pconds = finals[v][2]
		local ptarget = prule[1]
		local peffect = prule[3]

		if #pconds == 0 or (#pconds > 0 and pconds[1][1] ~= "never") then
			for a,b in ipairs(finals) do
				local rule = b[1]
				local conds = b[2]
				if rule[2] ~= "not means" and rule[1] == ptarget and rule[3] ~= peffect then
					conds = {{"never",{}}}
					finals[a][2] = conds
				end
			end
		end
	end
	for i,v in ipairs(finals) do
		local visual = true
		if #v[2] == 0 or (#v[2] > 0 and v[2][1][1] ~= "never") then
			for _,ids in ipairs(v[1]) do
				identifier = identifier .. ids
			end
			if v[1][2] == "means" then
				table.insert(result,v[1])
			else
				table.insert(notresult,v[1])
			end
		else
			visual = false
		end
		addoption(v[1],v[2],v[3],visual,nil,true)
	end
	return result,notresult,identifier
end

function buildmeanssentence(unitid,drs,prefix)
	local result = {}
	local unitids = {}
	local idqueue = {}
	local isnot = false

	local i = 1
	local code = codecheck(unitid,drs[1],drs[2])
	local prevsentences = {}
	local prevtype = 8 -- 8 = means
	local valid = true

	while valid and #code > 0 do
		local thistype = -1
		local alreadyfoundsentence = {}
		local newsentences = {}
		for _,v in ipairs(code) do
			local unit = mmf.newObject(v)
			local unitname = unit.strings[NAME]
			local tiletype = unit.values[TYPE]

			table.insert(idqueue, v)

			if thistype == -1 then
				thistype = tiletype
			end

			if prefix then -- ====== PREFIX CODE ======
				local foundrepeat = false
				if sentencemap[v] ~= nil then
					for _,sid in ipairs(sentencemap[v]) do
						for _,psid in ipairs(prevsentences) do
							if sid == psid then
								foundrepeat = true
								break
							end
						end
						if not alreadyfoundsentence[sid] then
							table.insert(newsentences, sid)
							alreadyfoundsentence[sid] = true
						end
					end
				end

				if foundrepeat then
					valid = false
				-- check NOT
				elseif tiletype == 4 then -- 4 = not
					if (prevtype == 0 or prevtype == 2 or prevtype == 4) and #result > 0 then -- 0 = noun, 2 = adjective, 4 = not
						for _,id in ipairs(idqueue) do
							table.insert(unitids, id)
						end
						local name = result[1]
						if string.sub(name, 1, 4) == "not " then
							name = string.sub(name, 5)
						else
							name = "not " .. name
						end
						result[1] = name
					elseif (prevtype == 4 or prevtype == 8) and #result == 0 then -- 4 = not, 8 = means
						isnot = not isnot
					else
						valid = false
					end
				-- check AND
				elseif tiletype == 6 then -- 6 = and
					if prevtype ~= 0 and prevtype ~= 2 and (prevtype ~= 4 or (prevtype == 4 and #result == 0)) then -- 0 = noun, 2 = adjective, 4 = not
						valid = false
					end
				-- check NOUN/ADJ
				elseif tiletype == 0 or tiletype == 2 then -- 0 = noun, 2 = adjective
					if prevtype == 4 or prevtype == 6 or prevtype == 8 then -- 4 = not, 6 = and, 8 = means
						for _,id in ipairs(idqueue) do
							table.insert(unitids, id)
						end
						table.insert(result, unitname)
					else
						valid = false
					end
				else
					valid = false
				end
			else -- ====== SUFFIX CODE ======
				-- check NOT
				if tiletype == 4 then
					if prevtype == 4 or prevtype == 6 or prevtype == 8 then -- 4 = not, 6 = and, 8 = means
						isnot = not isnot
					else
						valid = false
					end
				-- check AND
				elseif tiletype == 6 then -- 6 = and
					if prevtype ~= 0 and prevtype ~= 2 then -- 0 = noun, 2 = adjective
						valid = false
					end
				-- check NOUN/ADJ
				elseif tiletype == 0 or tiletype == 2 then -- 0 = noun, 2 = adjective
					if prevtype == 4 or prevtype == 6 or prevtype == 8 then -- 4 = not, 6 = and, 8 = means
						for _,id in ipairs(idqueue) do
							table.insert(unitids, id)
						end
						local name = unitname
						if isnot then
							name = "not " .. unitname
						end
						table.insert(result, name)
						isnot = false
					end
				else
					valid = false
				end
			end
		end
		i = i + 1
		prevtype = thistype
		prevsentences = newsentences
		code = codecheck(unitid,drs[1]*i,drs[2]*i)
	end
	if prefix then
		return result,unitids,isnot
	else
		return result,unitids
	end
end

--[[function findaltfeatures()
	local result = {}
	local alreadydone = {}

	local identifier = ""
	
	if (featureindex["means"] ~= nil) then
		for i,v in ipairs(featureindex["means"]) do
			local rule = v[1]
			local conds = v[2]
			local ids = v[3]
			
			local name = rule[1]
			local effect = rule[3]

			if alreadydone[name] == nil then
				alreadydone[name] = {}
				alreadydone[name][effect] = false
			end

			if not alreadydone[name][effect] then
				alreadydone[name][effect] = true

				local cleanname = name

				if (string.sub(name, 1, 3) == "not") then
					cleanname = string.sub(name, 5)
					nottarget = true
				end

				local never = false
				if conds ~= nil and (conds[1] or {})[1] == "never" then
					never = true
				end

				if not never then
					local realname = unitreference["text_" .. cleanname]
					local tile = tileslist[realname]

					table.insert(result, {name, tile.type, effect})

					identifier = identifier .. name .. "=" .. effect .. ","
				end
			end
		end
	end

	return result,identifier
end]]

function getaltfeatures(target)
	local result = {}
	local first = {}
	local hasmeans = false
	for i,v in ipairs(altfeatures) do
		local name = v[1]
		local effect = v[3]

		local notcount = 0

		local nname = name
		local notname = false
		if (string.sub(nname, 1, 3) == "not") then
			nname = string.sub(nname, 5)
			notname = true
			notcount = notcount + 1
		end

		local neffect = effect
		if (string.sub(neffect, 1, 3) == "not") then
			neffect = string.sub(effect, 5)
			notcount = notcount + 1
		end

		local ntarget = target
		if (string.sub(ntarget, 1, 3) == "not") then
			ntarget = string.sub(ntarget, 5)
			notcount = notcount + 1
		end

		if (notname and name == target) or (not notname and nname == ntarget) then
			local prefix = ""
			for a=1,notcount do
				if prefix == "" then
					prefix = "not "
				else
					prefix = ""
				end
			end
			table.insert(first, prefix .. neffect)
			hasmeans = true
		end
	end
	if not hasmeans then
		first = {target}
	end
	for _,teffect in ipairs(first) do
		local exclude = false

		local nteffect = teffect
		if (string.sub(nteffect, 1, 3) == "not") then
			nteffect = string.sub(nteffect, 5)
		end

		for i,v in ipairs(notaltfeatures) do
			local name = v[1]
			local effect = v[3]

			local nname = name
			local notname = false
			if (string.sub(nname, 1, 3) == "not") then
				nname = string.sub(nname, 5)
				notname = true
			end

			local neffect = effect
			local noteffect = false
			if (string.sub(neffect, 1, 3) == "not") then
				neffect = string.sub(neffect, 5)
				noteffect = true
			end

			local ntarget = target
			if (string.sub(ntarget, 1, 3) == "not") then
				ntarget = string.sub(ntarget, 5)
			end

			if (notname and target == name and effect == teffect) or (not notname and not noteffect and ntarget == nname and neffect == nteffect) then
				exclude = true
				hasmeans = true
				break
			end
		end
		if not exclude then
			table.insert(result, teffect)
		end
	end
	return result,hasmeans
end
-- MEANS END

function dobeams(loop_)
	local loop = loop_ or 0

	if loop > 20 then
		return
	end

	local beamdict = {}
	if (featureindex["beam"] ~= nil) then
		for i,v in ipairs(featureindex["beam"]) do
			local usable = false
			local rule = v[1]
			local conds = v[2]

			if conds[1] ~= "never" then
				local name = rule[1]

				if rule[2] == "beam" and getmat(name) then
					local targets = findall({name,conds})

					for _,a in ipairs(targets) do
						if not gettag(a,"beamer") then
							if not beamdict[a] then
								beamdict[a] = {}
							end
							table.insert(beamdict[a], rule[3])
						end
					end
				end
			end
		end
	end
	local beams = {}
	for unitid,effects in pairs(beamdict) do
		local unit = mmf.newObject(unitid)
		local name = getname(unit)

		if hasfeature(name,"is","cross",unitid) then
			for i=1,4 do
				table.insert(beams,{unitid,effects,i-1})
			end
		elseif hasfeature(name,"is","split",unitid) then
			local splitdir = (unit.values[DIR] + 1) % 4
			table.insert(beams,{unitid,effects,splitdir})
			table.insert(beams,{unitid,effects,rotate(splitdir)})
		else
			table.insert(beams,{unitid,effects})
		end
	end

	local alreadybeamed = {}
	local hasbeamed = {}
	local needsloop = false

	for _,data in pairs(beams) do
		local unitid = data[1]
		local effects = data[2]
		settag(unitid,"beamer",true)

		local unit = mmf.newObject(unitid)
		local name = getname(unit)

		local beamdir = data[3] or unit.values[DIR]
		local x,y = unit.values[XPOS],unit.values[YPOS]

		local offset = activemod.beam_offset
		if data[4] then
			if not activemod.beam_on_reflect then
				offset = 1
			else
				offset = 0
			end
		end

		local ndrs = ndirs[beamdir + 1]
		local ox,oy = ndrs[1]*offset, ndrs[2]*offset

		local firstbeam = true
		local stopped = false
		while not stopped do
			local tileid = (x+ox) + (y+oy) * roomsizex
			if alreadybeamed[tileid] and alreadybeamed[tileid][unitid] then
				if alreadybeamed[tileid][unitid][beamdir] then
					stopped = true
					break
				end
			else
				if not alreadybeamed[tileid] then
					alreadybeamed[tileid] = {}
				end
				if not alreadybeamed[tileid][unitid] then
					alreadybeamed[tileid][unitid] = {}
				end
			end
			alreadybeamed[tileid][unitid][beamdir] = true

			local hits = {}
			local alreadyhit = {}

			local objects = {}
			local reflected = false

			local obs = findobstacle(x+ox,y+oy)
			for i,ob in ipairs(obs) do
				if ob == -1 then
					stopped = true
				else
					local obsunit = mmf.newObject(ob)
					local obsname = getname(obsunit)

					local ispush = hasfeature(obsname,"is","push",ob)
					local ispull = hasfeature(obsname,"is","pull",ob)
					local isstop = hasfeature(obsname,"is","stop",ob)

					local isreflect = hasfeature(obsname,"is","reflect",ob)
					local issplit = hasfeature(obsname,"is","split",ob)
					local iscross = hasfeature(obsname,"is","cross",ob)

					local split = false

					if not (gettag(ob,"tempbeam") or gettag(ob,"new tempbeam")) then
						if ispush or ispull or isstop then
							stopped = true
						end

						local newdir
						if isreflect then
							newdir = obsunit.values[DIR]
						end
						if not data[3] or (data[3] and (not firstbeam or ob ~= unitid)) then
							if iscross then
								for i=1,4 do
									if i-1 ~= rotate(beamdir) or activemod.beam_cross_back then
										table.insert(beams, {ob, shallowcopy(effects), i-1, true})
									end
								end
								split = true
								if newdir ~= rotate(beamdir) or activemod.beam_cross_back then
									stopped = true
								end
							elseif issplit then
								local nextdir = (beamdir + 1) % 4
								local oppositedir = rotate(nextdir)
								table.insert(beams, {ob, shallowcopy(effects), nextdir, true})
								table.insert(beams, {ob, shallowcopy(effects), oppositedir, true})
								split = true
								if not newdir then
									stopped = true
								end
							end
						end

						if newdir ~= nil then
							reflected = true
							beamdir = newdir
							ndrs = ndirs[beamdir + 1]
						end
					end

					if (not firstbeam or ob ~= unitid) and (not reflected or activemod.beam_on_reflect) and not split then
						hasbeamed[ob] = true

						if not (gettag(ob,"tempbeam") or gettag(ob,"new tempbeam")) then
							local newbeamed = {}
							if gettag(ob,"new beamed") then
								for _,v in ipairs(gettag(ob,"new beamed")) do
									table.insert(newbeamed, v)
								end
							end
							table.insert(newbeamed, unit.values[ID])

							settag(ob,"new beamed",newbeamed)
						end

						table.insert(hits, {ob, obsname})
					end
				end
			end

			for _,effect in ipairs(effects) do
				local effname = unitreference["text_" .. effect]
				local efftype = -1

				if effname ~= nil then
					if tileslist[effname] then
						efftype = tileslist[effname].type or efftype
					end
					if changes[effname] then
						efftype = changes[effname].type or efftype
					end
				end

				local duplicates = {}
				local hasduplicate = false
				for _,hit in ipairs(hits) do
					local hitunit = mmf.newObject(hit[1])
					local hitbeam = gettag(hit[1],"tempbeam") or gettag(hit[1],"new tempbeam")
					if hit[2] == effect and hitunit.values[DIR] == beamdir and hitbeam then
						duplicates[hit[1]] = true
						hasduplicate = true
						settag(hit[1],"new tempbeam",true)

						local hitbeamed = gettag(hit[1],"new beamed")
						if hitbeamed then
							local newhitbeamed = {}
							for _,v in ipairs(hitbeamed) do
								if v ~= unit.values[ID] then
									table.insert(newhitbeamed, v)
								end
							end
							settag(hit[1],"new beamed",newhitbeamed)
						end
					end
				end

				if efftype == 2 then
					for _,hit in ipairs(hits) do
						if not alreadyhit[hit[2]] then
							addoption({hit[2],"is",effect},{{"beamed",{unit.values[ID]}}},{},false,nil,true)
							alreadyhit[hit[2]] = true
						end
					end
				elseif efftype == 0 then
					if not hasduplicate then
						table.insert(objects, effect)
					end
				end
			end

			local created = {}
			if not stopped and (not reflected or activemod.beam_on_reflect) then
				for _,object in ipairs(objects) do
					if (object ~= "text") then
						for a,mat in pairs(objectlist) do
							if (a == object) and (object ~= "empty") and (object ~= "group") then
								if (object ~= "all") then
									table.insert(created, create(object,x+ox,y+oy,beamdir))
								else
									local all = createall({object,{}},x+ox,y+oy,beamdir)
									for _,v in ipairs(all) do
										table.insert(created, v)
									end
								end
							end
						end
					else
						table.insert(created, create("text_" .. name,x+ox,y+oy,beamdir))
						updatecode = 1
					end
				end
			end
			for _,v in ipairs(created) do
				needsloop = true
				updateundo = true
				settag(v,"new tempbeam",true)
			end

			ox = ox + ndrs[1]
			oy = oy + ndrs[2]
			firstbeam = false
		end
	end

	if needsloop then
		dobeams(loop + 1)
	else
		local delunits = {}
		for _,unit in ipairs(units) do
			settag(unit.fixed,"beamed",gettag(unit.fixed,"new beamed"),true)
			if gettag(unit.fixed,"beamer") then
				settag(unit.fixed,"beamer",nil)
			end
			if gettag(unit.fixed,"tempbeam") and not gettag(unit.fixed,"new tempbeam") then
				table.insert(delunits,unit.fixed)
				updateundo = true
			else
				settag(unit.fixed,"tempbeam",gettag(unit.fixed,"new tempbeam"),true)
			end

			settag(unit.fixed,"new beamed",nil)
			settag(unit.fixed,"new tempbeam",nil)
		end
		for _,unitid in ipairs(delunits) do
			local unit = mmf.newObject(unitid)
			if unit.strings[UNITTYPE] == "text" then
				updatecode = 1
			end
			delete(unitid)
		end
	end

	print("update code: " .. updatecode)
end