function addaction(unitid,data)
	local unit = nil
	
	if (unitid ~= nil) and (unitid > 0) and (unitid ~= 2) then
		unit = mmf.newObject(unitid)
	end
	
	local invalid = false
	
	if (unit ~= nil) then
		invalid = unit.flags[15]
	end
	
	local action = {}
	
	if (unitid == 2) then
		invalid = false
	end
	
	if (invalid == false) then
		table.insert(action, unitid)
		
		for i,v in ipairs(data) do
			table.insert(action, v)
		end

		table.insert(updatelist, action)
	end
end

function doupdate()
	if (#updatelist > 0) then
		for i,data in pairs(updatelist) do
			if (#wordunits > 0) then
				for a,b in ipairs(wordunits) do
					if (b[1] == data[1]) then
						updatecode = 1
					end
				end
			end
			
			if (data[2] == "update") then
				if (data[3] ~= nil) and (data[4] ~= nil) then
					update(data[1],data[3],data[4],data[5])
				else
					print("No meaningful update data for object " .. tostring(data[1]) .. ", " .. data[2])
				end
			elseif (data[2] == "updatedir") then
				if (data[3] ~= nil) then
					updatedir(data[1],data[3])
				else
					print("No meaningful update data for object " .. tostring(data[1]) .. ", " .. data[2])
				end
			elseif (data[2] == "convert") or (data[2] == "emptyconvert") then
				if (data[3] ~= nil) and (data[4] ~= nil) then
					doconvert(data)
				else
					print("No meaningful update data for object " .. tostring(data[1]) .. ", " .. data[2])
				end
			elseif (data[2] == "createall") then
				if (data[3] ~= nil) then
					local dolevels = data[4] or false
					createall(data[3],nil,nil,nil,dolevels)
				else
					print("No meaningful update data for object " .. tostring(data[1]) .. ", " .. data[2])
				end
			end
		end
	end
	
	updatelist = {}
end

function findupdate(unitid,updatename)
	local result = {}
	
	if (#updatelist > 0) then
		for i,data in ipairs(updatelist) do
			if (data[1] == unitid) then
				if (data[2] == updatename) then
					table.insert(result, data)
				end
			end
		end
	end
	
	return result
end