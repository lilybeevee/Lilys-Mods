function findfeature(rule1,rule2,rule3)
	local options = {}
	local result = {}
	local rule = ""
	
	if (rule1 ~= nil) then
		rule = rule1 .. " "
	end
	
	if (rule2 ~= nil) then
		rule = rule .. rule2 .. " "
	end
	
	if (rule3 ~= nil) then
		rule = rule .. rule3
	end
	
	if (featureindex[rule1] ~= nil) then
		for i,rules in ipairs(featureindex[rule1]) do
			local rule = rules[1]
			local conds = rules[2]
			
			if (conds[1] ~= "never") then
				if (rule[1] == rule1) and (rule[2] == rule2) then
					local baserule = {rule[1],rule[2],rule[3]}
					table.insert(options, {baserule,conds})
				end
			end
		end
	end
	
	if (featureindex[rule3] ~= nil) then
		for i,rules in ipairs(featureindex[rule3]) do
			local rule = rules[1]
			local conds = rules[2]
			
			if (conds[1] ~= "never") then
				if (rule[3] == rule3) and (rule[2] == rule2) then
					local baserule = {rule[1],rule[2],rule[3]}
					table.insert(options, {baserule,conds})
				end
			end
		end
	end
	
	if (rule1 == nil) and (rule3 == nil) and (rule2 ~= nil) then
		if (featureindex[rule2] ~= nil) then 
			for i,rules in ipairs(featureindex[rule2]) do
				local usable = false
				local rule = rules[1]
				local conds = rules[2]

				if (conds[1] ~= "never") then
					for a,mat in pairs(objectlist) do
						if (a == rule[3]) then
							usable = true
						end
					end
					
					if (rule[2] == rule2) and usable then
						local baserule = {rule[1],rule[2],rule[3]}
						table.insert(options, {baserule,conds})
					end
				end
			end
		end
	end
	
	for i,rules in ipairs(options) do
		local words = {}
		local baserule = rules[1]
		
		for a,b in ipairs(baserule) do
			table.insert(words, b)
		end
		
		if (#words >= 3) then
			local one = words[3]
			local two = words[2] .. " " .. words[3]
			local three = words[1] .. " " .. words[2] .. " " .. words[3]

			if (one == rule) or (two == rule) or (three == rule) or ((rule2 == words[2]) and (rule1 == nil) and (rule3 == nil)) then				
				table.insert(result, {baserule[1], rules[2]})
			end
		end
	end
	
	if (#result > 0) then
		return result
	else
		return nil
	end
end

function findfeatureat(rule1,rule2,rule3,x,y)
	local result = {}
	local targets = findfeature(rule1,rule2,rule3)
	
	if (targets ~= nil) then
		for i,v in ipairs(targets) do
			local name = v[1]
			for a,unit in ipairs(units) do
				local unitx,unity = unit.values[XPOS],unit.values[YPOS]
				if (unit.values[XPOS] == x) and (unit.values[YPOS] == y) then
					if (unit.strings[UNITNAME] == name) or ((unit.strings[UNITTYPE] == "text") and (name == "text")) then
						local conds = v[2]
						if testcond(conds,unit.fixed) then
							table.insert(result, unit.fixed)
						end
					end
				end
			end
		end
	end
	
	if (#result > 0) then
		return result
	else
		return nil
	end
end

function hasfeature(rule1,rule2,rule3,unitid,x,y)
	if (featureindex[rule1] ~= nil) and (rule2 ~= nil) and (rule3 ~= nil) then
		for i,rules in ipairs(featureindex[rule1]) do
			local rule = rules[1]
			local conds = rules[2]
			
			if (conds[1] ~= "never") then
				if (rule[1] == rule1) and (rule[2] == rule2) and (rule[3] == rule3) then
					if testcond(conds,unitid,x,y) then
						return true
					end
				end
			end
		end
	end
	
	if (featureindex[rule3] ~= nil) and (rule2 ~= nil) and (rule1 ~= nil) then
		for i,rules in ipairs(featureindex[rule3]) do
			local rule = rules[1]
			local conds = rules[2]
			
			if (conds[1] ~= "never") then
				if (rule[1] == rule1) and (rule[2] == rule2) and (rule[3] == rule3) then
					if testcond(conds,unitid,x,y) then
						return true
					end
				end
			end
		end
	end
	
	if (featureindex[rule2] ~= nil) and (rule1 ~= nil) and (rule3 == nil) then
		local usable = false
		
		if (featureindex[rule1] ~= nil) then
			for i,rules in ipairs(featureindex[rule1]) do
				local rule = rules[1]
				local conds = rules[2]
				
				if (conds[1] ~= "never") then
					for a,mat in pairs(objectlist) do
						if (a == rule[1]) then
							usable = true
						end
					end
					
					if (rule[1] == rule1) and (rule[2] == rule2) and usable then
						if testcond(conds,unitid,x,y) then
							return true
						end
					end
				end
			end
		end
	end
	
	return nil
end

function findallfeature(rule1,rule2,rule3,ignore_empty_)
	local group = findfeature(rule1,rule2,rule3)
	local ignore_empty = ignore_empty_ or false
	
	local result = {}
	local empty = {}
	
	if (group ~= nil) then
		for i,v in ipairs(group) do
			if (v[1] ~= "empty") then
				local groupmembers = findall(v)
				
				for a,b in ipairs(groupmembers) do
					table.insert(result, b)
					table.insert(empty, {})
				end
			else
				if (ignore_empty == false) then
					local conds = v[2]
					local needstest = false
					local valid = true
					
					if (#conds > 0) and ((conds[1] ~= nil) and (conds[1][1] ~= "never")) then
						needstest = true
					elseif (#conds > 0) and ((conds[1] ~= nil) and (conds[1][1] == "never")) then
						valid = false
					end
					
					if valid then
						table.insert(result, 2)
						table.insert(empty, {})
						
						local thisempty = empty[#empty]
						
						for a=1,roomsizex-2 do
							for b=1,roomsizey-2 do
								local tileid = a + b * roomsizex
								
								if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then
									if (needstest == false) then
										thisempty[tileid] = 0
									else
										if testcond(conds,2,a,b) then
											thisempty[tileid] = 0
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
	
	return result,empty
end

function getunitswitheffect(rule3,delthese_)
	local group = {}
	local result = {}
	local delthese = delthese_ or {}
	
	if (featureindex[rule3] ~= nil) then
		for i,v in ipairs(featureindex[rule3]) do
			local rule = v[1]
			local conds = v[2]
			
			if (rule[2] == "is") and (conds[1] ~= "never") and (rule[1] ~= "all") and (rule[1] ~= "group") then
				table.insert(group, {rule[1], conds})
			end
		end
		
		for i,v in ipairs(group) do
			if (v[1] ~= "empty") then
				local name = v[1]
				local groupmembers = unitlists[name]
				
				if (groupmembers ~= nil) then
					for a,b in ipairs(groupmembers) do
						if testcond(v[2], b) then
							local unit = mmf.newObject(b)
							
							if (unit.flags[DEAD] == false) then
								table.insert(result, unit)
							end
						end
					end
				end
			else
				--table.insert(result, {2, v[2]})
			end
		end
	end
	
	return result
end

function getunitswithverb(rule2,delthese_)
	local group = {}
	local result = {}
	local delthese = delthese_ or {}
	
	if (featureindex[rule2] ~= nil) then
		for i,v in ipairs(featureindex[rule2]) do
			local rule = v[1]
			local conds = v[2]
			
			local name = rule[1]
			
			if (rule[2] == rule2) and (conds[1] ~= "never") and (rule[1] ~= "all") and (rule[1] ~= "group") then
				if (group[name] == nil) then
					group[name] = {}
				end
				
				table.insert(group[name], {rule[3], conds})
			end
		end
		
		for i,v in pairs(group) do
			if (i ~= "empty") then
				local name = i
				local groupmembers = unitlists[name]
				
				for c,d in ipairs(v) do
					table.insert(result, {d[1], {}})
					local thisthisresult = result[#result][2]
					
					for a,b in ipairs(groupmembers) do
						if testcond(d[2], b) then
							local unit = mmf.newObject(b)
							
							if (unit.flags[DEAD] == false) then
								table.insert(result[#result][2], unit)
							end
						end
					end
				end
			else
				--table.insert(result, {2, v[2]})
			end
		end
	end
	
	return result
end