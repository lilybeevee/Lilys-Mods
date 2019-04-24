local byte = string.byte

function utf8_dec(buf, pos)
    pos = pos or 1
    local n, mask
    local bv = byte(buf, pos)
    if bv <= 0x7F then
        return pos+1, bv
    elseif bv <= 0xDF then
        n = 1
        mask = 0xC0
    elseif bv <= 0xEF then
        n = 2
        mask = 0xE0
    elseif bv <= 0xF7 then
        n = 3
        mask = 0xF0
    else
        return nil, "invalid utf-8"
    end

    local cp = bv - mask

    if pos + n > #buf then
        return nil, "incomplete utf-8 seq"
    end
    for i = 1, n do
        bv = byte(buf, pos + i)
        if bv < 0x80 or bv > 0xBF then
            return nil, "invalid utf-8 seq"
        end
        -- cp = (cp << 6) + (bv & 0x3F)
        cp = (cp * 64) + (bv % 64)
    end

    return pos + 1 + n, cp
end

local chr_to_anim = {}
for i, v in ipairs(lookup_table) do
    chr_to_anim[v] = i-1
end

function decode(buf)
	--MF_alert("Decoding " .. buf .. "...")
	
    local cp = {}
    local pos = 1
	local pos_ = 1
    local val = 1
    while pos <= #buf do
		--MF_alert(tostring(pos) .. ", " .. string.sub(buf, pos, pos))
		
		pos_ = pos
        pos, val = utf8_dec(buf, pos)
		
		if (pos == nil) then
			MF_alert(val)
			pos = pos_ + 1
		end
		
        val = chr_to_anim[val]
        if val ~= nil then
            cp[#cp+1] = val
        else
			cp[#cp+1] = 1
		end
    end
	
	--[[
	local hm = ""
	for i,v in ipairs(cp) do
		hm = hm .. tostring(v) .. ", "
	end
	MF_alert(buf)
	MF_alert(" --- " .. hm)
	]]--
	
    return cp
end

function decode_mmf2(text)
	local data = decode(text)
	local result = ""
	
	for i,v in ipairs(data) do
		result = result .. tostring(v)
		
		if (i < #data) then
			result = result .. ","
		end
	end
	
	return result
end

function testdecode(buf)
    local val = table.concat(decode(buf), ",")
    return "[" .. val .. "]"
end

-- let's add a cool japanese character (地)
-- lookup_table[#lookup_table+1] = 22320