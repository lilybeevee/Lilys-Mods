function ending(enddataid)
	local enddata = mmf.newObject(enddataid)
	
	enddata.values[ENDTIMER] = enddata.values[ENDTIMER] + 1
	local phase = enddata.values[ENDPHASE]
	local timer = enddata.values[ENDTIMER]
	local ender = enddata.values[4]
	local ended = enddata.values[3]
	
	if (phase == 1) then
		if (timer == 1) and (1 == 0) then
			clearunits()
			MF_loop("clear",1)
			enddata.values[ENDPHASE] = 4
			enddata.values[ENDTIMER] = -150
			generaldata.values[IGNORE] = 1
			MF_playmusic("ending",0,1,1)
		end
		
		if (timer == 2) then
			local unit = mmf.newObject(ended)
			local c1,c2 = getcolour(ended)
			MF_particles("smoke",unit.values[XPOS],unit.values[YPOS],20,c1,c2,1,1)
			
			unit.visible = false
			generaldata2.values[ENDINGGOING] = 1
			
			for i,v in ipairs(features) do
				local rule = v[1]
				
				if (rule[1] == "text") and (rule[2] == "is") and (rule[3] == "push") then
					v[2] = {{"never",{}}}
				end
			end
			
			featureindex["text"] = {}
			
			if (featureindex["push"] ~= nil) then
					for i,v in ipairs(featureindex["push"]) do
					local rule = v[1]
					
					if (rule[1] == "text") and (rule[2] == "is") and (rule[3] == "push") then
						v[2] = {{"never",{}}}
					end
				end
			end
		end
		
		if (timer == 13) then
			MF_playsound_musicvolume("ending_reverse_baba_loop_start", 4)
		end
			
		if (timer == 52) then
			local unit = mmf.newObject(ended)
			local flowerid = MF_specialcreate("Flower_center")
			local flower = mmf.newObject(flowerid)
			
			flower.strings[2] = "you"
			flower.values[10] = 1
			flower.values[8] = 15
			flower.x = tilesize * unit.values[XPOS] * spritedata.values[TILEMULT] + tilesize * 1.0 * spritedata.values[TILEMULT]
			flower.y = tilesize * unit.values[YPOS] * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
		end
		
		if (timer > 0) then
			for i,unit in ipairs(units) do
				if (unit.strings[UNITTYPE] == "text") then
					unit.x = unit.x + math.random(-1,1)
					unit.y = unit.y + math.random(-1,1)
					unit.values[POSITIONING] = 0
				end
			end
		end
		
		if (timer == 220) then
			local textconverts = {}
			--MF_playsound_channel("confirm",5)
			
			for i,unit in ipairs(units) do
				if (unit.strings[UNITTYPE] == "text") then
					table.insert(textconverts, unit)
				end
			end
			
			for i,unit in pairs(textconverts) do
				doconvert({unit.fixed,"convert","blossom",unit.values[ID],unit.values[ID]})
				updatecode = 0
			end
		end
		
		if (timer > 220) then
			local eunit = mmf.newObject(ender)
			local changethese = {}
			local deletethese = {}
			local blossoms = {}
			
			for i,unit in ipairs(units) do
				if (unit.strings[UNITNAME] == "blossom") then
					if (unit.values[FLOAT] == 3) then
						if (unit.values[XPOS] == eunit.values[XPOS]) and (unit.values[YPOS] == eunit.values[YPOS]) then
							table.insert(changethese, unit)
						end
					elseif (unit.values[FLOAT] == 0) and (timer > 230) then
						local edunit = mmf.newObject(ended)
						
						unit.values[XPOS] = unit.values[XPOS] + (edunit.values[XPOS] - unit.values[XPOS]) * 0.2
						unit.values[YPOS] = unit.values[YPOS] + (edunit.values[YPOS] - unit.values[YPOS]) * 0.2
						unit.values[POSITIONING] = 0
						
						local dist = math.abs(edunit.values[XPOS] - unit.values[XPOS]) + math.abs(edunit.values[YPOS] - unit.values[YPOS])
						
						if (dist < 0.5) then
							table.insert(deletethese, unit)
						end
					end
					table.insert(blossoms, 1)
				end
			end
			
			if (#changethese > 0) then
				MF_playsound("intro_flower_" .. tostring(math.random(1,7)))
			end
			
			for i,unit in ipairs(deletethese) do
				MF_particles("bling",unit.values[XPOS],unit.values[YPOS],10,0,3,1,1)
				delete(unit.fixed)
				updatecode = 0
			end
			
			for i,unit in ipairs(changethese) do
				MF_particles("bling",unit.values[XPOS],unit.values[YPOS],10,0,3,1,1)
				unit.values[FLOAT] = 0
			end
			
			if (#blossoms == 0) then
				generaldata.values[ONLYARROWS] = 1
				enddata.values[ENDPHASE] = 2
				enddata.values[ENDTIMER] = 0
			end
		end
	end
		
	if (phase == 2) then
		if (timer == 30) then
			local allis = MF_findspecial("you")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 3
			end
		end
		
		if (timer == 250) then
			local allis = MF_findspecial("you")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 1
			end
			
			MF_playsound_musicvolume("ending_reverse_baba_loop_end", 4)
		end
		
		if (timer == 430) then
			generaldata.values[TRANSITIONREASON] = 0
			dotransition()
		elseif (timer > 430) and (generaldata.values[TRANSITIONED] == 1) then
			clearunits()
			MF_loop("clear",1)
			generaldata.values[MODE] = 3
			
			enddata.values[ENDPHASE] = 3
			enddata.values[ENDTIMER] = 0
			generaldata.values[ONLYARROWS] = 0
			generaldata.values[IGNORE] = 1
			generaldata.values[TRANSITIONED] = 0
			generaldata.values[TRANSITIONREASON] = 0
			
			local xoffset = (screenw - roomsizex * tilesize * spritedata.values[TILEMULT]) * 0.5
			local yoffset = (screenh - roomsizey * tilesize * spritedata.values[TILEMULT]) * 0.5
			
			MF_setroomoffset(xoffset,yoffset)
			MF_loadbackimage("island,island_decor")
			levelborder()
			
			local flowerid = MF_specialcreate("Flower_center")
			local flower = mmf.newObject(flowerid)
			
			flower.strings[2] = "endingflower"
			flower.values[10] = 1
			flower.values[8] = 2
			flower.values[6] = 1
			flower.x = tilesize * 16 * spritedata.values[TILEMULT]
			flower.y = tilesize * 14 * spritedata.values[TILEMULT]
			
			local otherareas =
			{
				{
					name = "mountain",
					xpos = 10,
					ypos = 3,
					colour = {1,4},
					level = "232level",
				},
				{
					name = "cave",
					xpos = 11,
					ypos = 5,
					colour = {2,2},
					level = "179level",
				},
				{
					name = "garden",
					xpos = 13,
					ypos = 8,
					colour = {4,1},
					level = "180level",
				},
				{
					name = "ruins",
					xpos = 18,
					ypos = 6,
					colour = {2,4},
					level = "206level",
				},
				{
					name = "space",
					xpos = 20,
					ypos = 4,
					colour = {3,2},
					level = "87level",
				},
				{
					name = "forest",
					xpos = 21,
					ypos = 6,
					colour = {5,2},
					level = "169level",
				},
				{
					name = "island",
					xpos = 18,
					ypos = 9,
					colour = {5,3},
					level = "207level",
				},
				{
					name = "lake",
					xpos = 16,
					ypos = 10,
					colour = {1,4},
					level = "177level",
				},
				{
					name = "fall",
					xpos = 21,
					ypos = 13,
					colour = {2,3},
					level = "16level",
				},
				{
					name = "abstract",
					xpos = 24,
					ypos = 10,
					colour = {0,2},
					level = "182level",
				},
			}
			
			for i,v in ipairs(otherareas) do
				local status = tonumber(MF_read("save",generaldata.strings[WORLD] .. "_complete",v.level))
				
				if (status == 1) then
					local flowerid = MF_specialcreate("Flower_center")
					local flower = mmf.newObject(flowerid)
					
					flower.strings[1] = tostring(v.colour[1]) .. "," .. tostring(v.colour[2])
					flower.strings[2] = "otherarea"
					flower.values[10] = 2
					flower.values[8] = 1
					flower.values[6] = 1
					flower.x = Xoffset + (v.xpos * tilesize + tilesize * 0.5) * spritedata.values[TILEMULT]
					flower.y = Yoffset + (v.ypos * tilesize + tilesize * 0.5) * spritedata.values[TILEMULT]
				end
			end
		end
	end
	
	if (phase == 3) then
		if (timer == 30) then
			MF_playsound("dididi")
		end
		
		if (timer == 700) then
			local mx = screenw * 0.5
			local my = screenh * 0.5
			
			local letid1 = MF_effectcreate("Ending_theend")
			local letid2 = MF_effectcreate("Ending_theend")
			local let1 = mmf.newObject(letid1)
			local let2 = mmf.newObject(letid2)
			
			let1.x = mx
			let1.y = my + 4 - tilesize * 0.5
			let1.layer = 2
			MF_setcolour(letid1,1,2)
			
			let2.x = mx
			let2.y = my - tilesize * 0.5
			let2.layer = 2
		elseif (timer == 750) then
			local mx = screenw * 0.5
			local my = screenh * 0.5
			
			local letid3 = MF_effectcreate("Ending_theend_back")
			local let3 = mmf.newObject(letid3)
			let3.x = mx
			let3.y = my + 8 - tilesize * 0.5
			let3.layer = 2
			
			MF_playsound("themetune")
		elseif (timer == 1150) then
			dotransition()
		elseif (timer > 1150) and (generaldata.values[TRANSITIONED] == 1) then
			clearunits()
			MF_loop("clear",1)
			generaldata.values[MODE] = 3
			enddata.values[ENDPHASE] = 4
			enddata.values[ENDTIMER] = -100
			MF_playmusic("ending",0,1,1)
			MF_channelvolume(1,0)
			MF_channelvolume(2,0)
		end
	end
	
	if (phase == 4) then
		local tiles =
		{
			baba = {
				dir = 0,
				colour = {4,1},
			},
			is = {
				dir = 1,
				colour = {0,3},
			},
			you = {
				dir = 2,
				colour = {4,1},
			},
			made = {
				dir = 10,
				colour = {1,3},
			},
			by = {
				dir = 3,
				colour = {1,3},
			},
			arvi = {
				dir = 4,
				colour = {0,3},
			},
			teikari = {
				dir = 5,
				colour = {0,3},
			},
			port = {
				dir = 6,
				colour = {1,3},
			},
			mp2_logo = {
				dir = 7,
				colour = {4,1},
			},
			mp2 = {
				dir = 8,
				colour = {0,3},
			},
			games = {
				dir = 9,
				colour = {0,3},
			},
			with = {
				dir = 11,
				colour = {1,3},
			},
			mmf2 = {
				dir = 12,
				colour = {5,3},
			},
			click = {
				dir = 13,
				colour = {5,3},
			},
			team = {
				dir = 14,
				colour = {5,3},
			},
			baba_obj = {
				dir = 15,
				colour = {0,3},
			},
		}
		
		local time1 = 80
		
		if (timer == time1) then
			ending_load(tiles,"baba",-1,0)
		elseif (timer == time1 + 40) then
			ending_load(tiles,"is",0,0)
		elseif (timer == time1 + 70) then
			ending_load(tiles,"you",1,0)
		end
		
		if (timer == 190) then
			ending_load(tiles,"baba_obj",-2.5,2)
		end
		
		time1 = 310
		
		if (timer == time1) then
			MF_hack_removecredit("baba")
		elseif (timer == time1 + 20) then
			MF_hack_removecredit("is")
		elseif (timer == time1 + 40) then
			MF_hack_removecredit("you")
		end
		
		time1 = 290
		
		if (timer == time1 + 55) then
			ending_load(tiles,"made",-1.5,0)
		elseif (timer == time1 + 85) then
			ending_load(tiles,"by",-0.5,0)
		elseif (timer == time1 + 136) then
			ending_load(tiles,"arvi",0.5,0)
		elseif (timer == time1 + 175) then
			ending_load(tiles,"teikari",1.5,0)
		end
		
		time1 = 490
		
		if (timer == time1) then
			MF_hack_movecredit("baba_obj","1","0",22)
		elseif (timer == time1 + 10) then
			MF_hack_movecredit("baba_obj","1","0",19)
		elseif (timer == time1 + 20) then
			MF_hack_movecredit("baba_obj","1","0",22)
		elseif (timer == time1 + 40) then
			MF_hack_movecredit("baba_obj","0","-1",16)
		elseif (timer == time1 + 50) then
			MF_hack_movecredit("baba_obj","0","-1",16)
			MF_hack_movecredit("arvi","0","-1",-1)
			
			local stuff = MF_findspecial("arvi")
			local stuff2 = MF_findspecial("teikari")
			
			for a,b in ipairs(stuff) do
				MF_setcolour(b,0,1)
			end
			
			for a,b in ipairs(stuff2) do
				MF_setcolour(b,0,1)
			end
		end
		
		time1 = 605
		
		if (timer == time1) then
			MF_hack_removecredit("made")
		elseif (timer == time1 + 10) then
			ending_load(tiles,"port",-2,0)
		elseif (timer == time1 + 20) then
			MF_hack_movecredit("by","-0.5","0",-1)
			MF_hack_movecredit("baba_obj","-0.5","0",23)
		elseif (timer == time1 + 40) then
			MF_hack_movecredit("baba_obj","0","-1",16)
			MF_hack_removecredit("arvi")
		elseif (timer == time1 + 60) then
			MF_hack_movecredit("baba_obj","-1","0",23)
			MF_hack_removecredit("teikari")
		elseif (timer == time1 + 68) then
			ending_load(tiles,"mp2_logo",0,0)
		elseif (timer == time1 + 90) then
			ending_load(tiles,"mp2",1,0)
		elseif (timer == time1 + 120) then
			ending_load(tiles,"games",2,0)
		end
		
		time1 = 816
			
		if (timer == time1) then
			MF_hack_removecredit("port")
			MF_hack_movecredit("baba_obj","0","1",18)
			MF_hack_movecredit("by","0","1",-1)
		elseif (timer == time1 + 10) then
			ending_load(tiles,"made",-1,-1)
		elseif (timer == time1 + 24) then
			MF_hack_removecredit("mp2_logo")
			ending_load(tiles,"with",0,-1)
		elseif (timer == time1 + 38) then
			ending_load(tiles,"mmf2",1.2,-1)
			MF_hack_removecredit("mp2")
		elseif (timer == time1 + 60) then
			MF_hack_removecredit("games")
		elseif (timer == time1 + 65) then
			ending_load(tiles,"click",0.2,1)
		elseif (timer == time1 + 110) then
			ending_load(tiles,"team",1.2,1)
		end
		
		time1 = 836
		
		if (timer == time1) then
			MF_hack_movecredit("baba_obj","-1","0",23)
		elseif (timer == time1 + 10) then
			MF_hack_movecredit("baba_obj","-1","0",17)
		elseif (timer == time1 + 20) then
			MF_hack_movecredit("baba_obj","-1","0",20)
		elseif (timer == time1 + 30) then
			MF_hack_movecredit("baba_obj","-1","0",17)
		elseif (timer == time1 + 40) then
			MF_hack_movecredit("baba_obj","-1","0",23)
		elseif (timer == time1 + 70) then
			MF_hack_removecredit("baba_obj")
		end
		
		time1 = 1040
		
		if (timer == time1) then
			MF_hack_removecredit("made")
		elseif (timer == time1 + 10) then
			MF_hack_removecredit("with")
		elseif (timer == time1 + 20) then
			MF_hack_removecredit("mmf2")
		elseif (timer == time1 + 30) then
			MF_hack_removecredit("by")
		elseif (timer == time1 + 40) then
			MF_hack_removecredit("click")
		elseif (timer == time1 + 50) then
			MF_hack_removecredit("team")
		end
		
		if (timer == 1100) then
			generaldata.values[MODE] = 2
			enddata.values[ENDPHASE] = 5
			enddata.values[ENDTIMER] = 0
			enddata.values[ENDCREDITS] = 1
		end
	elseif (phase == 5) then
		local tiles =
		{
			keke = {
				dir = 24,
				colour = {2,2},
			},
			skull = {
				dir = 25,
				colour = {2,1},
			},
			flag = {
				dir = 26,
				colour = {2,4},
			},
			key = {
				dir = 27,
				colour = {2,4},
			},
			rocket = {
				dir = 28,
				colour = {1,1},
			},
		}
		
		if (timer == 100) then
			ending_load(tiles,"keke",-3.5,13.5)
			ending_load(tiles,"skull",3.5,19.8)
			ending_load(tiles,"flag",-3.5,25.5)
			ending_load(tiles,"key",3.5,34)
			ending_load(tiles,"rocket",-3.5,52.1)
		end
	elseif (phase == 6) then
		if (timer == 2) then
			local tiles =
			{
				baba = {
					dir = 21,
					colour = {0,3},
				},
			}
			
			ending_load(tiles,"baba",0,0.3)
		elseif (timer == 60) then
			writetext(langtext("ending"),0,screenw * 0.5,screenh * 0.5 - 96 * 1.6,0,true,2,nil,nil,2)
		end
	end
end

function ending_load(database,name,x,y)
	local data = database[name]
	local unitid = MF_specialcreate("Ending_credits")
	local unit = mmf.newObject(unitid)
	
	unit.x = -96
	unit.y = -96
	
	unit.values[ONLINE] = 1
	unit.values[XPOS] = screenw * 0.5 + x * 96
	unit.values[YPOS] = screenh * 0.5 + y * 96
	unit.direction = data.dir
	unit.strings[2] = name
	
	MF_setcolour(unitid,data.colour[1],data.colour[2])
	
	return unitid
end

function allisdone(enddataid)
	local enddata = mmf.newObject(enddataid)
	
	enddata.values[ENDTIMER] = enddata.values[ENDTIMER] + 1
	local phase = enddata.values[ALLISDONE]
	local timer = enddata.values[ENDTIMER]
	
	if (phase == 1) then
		if (timer == 350) then
			generaldata.values[IGNORE] = 1
			enddata.values[ALLISDONE] = 2
			enddata.values[ENDTIMER] = 0
			
			local xoffset = (screenw - roomsizex * tilesize * spritedata.values[TILEMULT]) * 0.5
			local yoffset = (screenh - roomsizey * tilesize * spritedata.values[TILEMULT]) * 0.5
			
			MF_setroomoffset(xoffset,yoffset+1024)
			MF_loadbackimage("island_full")
			MF_movebackimage(0-24,0-24-480)
		end
	elseif (phase == 2) then
		local xoffset = (screenw - roomsizex * tilesize * spritedata.values[TILEMULT]) * 0.5
		local yoffset = (screenh - roomsizey * tilesize * spritedata.values[TILEMULT]) * 0.5 - 480
		
		if (timer < 120) then
			MF_scrollroom(0,(yoffset-56 - Yoffset) * 0.03)
		elseif (timer == 120) then
			MF_setroomoffset(xoffset,yoffset)
		end
		
		if (timer == 10) then
			MF_playsound("whoooooosh")
		end
		
		if (timer == 200) then
			MF_playsound("burn3_short")
			particles("smoke",16,3+20,10,{0,3},2,1)
		end
		
		if (timer > 220) and (timer < 420) then
			particles("smoke",16,3+20,2,{0,4},2,1)
		end
		
		if (timer == 400) then
			MF_playsound("ending_rumble_quiet")
			local blobid = MF_effectcreate("Ending_done_blob")
			local blob = mmf.newObject(blobid)
			
			blob.x = 372 + Xoffset + 24
			blob.y = 62 + Yoffset + 24 + 480
			blob.scaleX = 0.01
			blob.scaleY = 0.01
			blob.values[EFFECT] = 1
			MF_setcolour(blobid,0,4)
			-- The actual effect is implemented via MMF2
		end
		
		if (timer == 1140) then
			MF_loop("clear",1)
			
			enddata.values[ALLISDONE] = 3
			enddata.values[ENDTIMER] = 0
			enddata.values[ENDCREDITS] = 1
			MF_setroomoffset(0,0)
			
			local customid = MF_specialcreate("customsprite")
			
			MF_loadsprite(customid,"baba_0",0,0)
			MF_loadsprite(customid,"keke_16",1,0)
			MF_loadsprite(customid,"wall_0",2,0)
			MF_loadsprite(customid,"flag_0",3,0)
			MF_loadsprite(customid,"skull_24",4,0)
			MF_loadsprite(customid,"jelly_0",5,1)
			MF_loadsprite(customid,"cog_0",6,1)
			MF_loadsprite(customid,"leaf_0",7,1)
			MF_loadsprite(customid,"statue_24",8,0)
			MF_loadsprite(customid,"tree_0",9,0)
			MF_loadsprite(customid,"rocket_8",10,1)
			MF_loadsprite(customid,"text_baba_0",11,0)
			MF_loadsprite(customid,"text_is_0",12,0)
			MF_loadsprite(customid,"text_you_0",13,0)
			MF_loadsprite(customid,"fruit_0",14,0)
			MF_loadsprite(customid,"fire_0",15,1)
			MF_loadsprite(customid,"bird_16",16,1)
			
			MF_cleanspecialremove(customid)
		end
	elseif (phase == 3) then
		if (timer == 350) then
			generaldata.values[MODE] = 2
			changemenu("endcredits")
		end
	end
end

function dointro(introdataid)
	local flowers =
	{	
		baba =
		{
			start = 160,
			wait_until_open = 70,
			wait_until_reveal = 130,
			what_to_reveal = "text_baba",
			
			position = true,
			shake = {"baba", 130, 200},
			wait_until_position = 70,
			what_to_position = "baba",
			
			disregard_after = 205,
			
			particles = true,
			
			appear_sound = "intro_reveal_1f",
			--open_sound = "intro_open_1b",
			disappear_sound = "intro_disappear_1",
		},
		
		wall =
		{
			start = 530,
			wait_until_open = 70,
			wait_until_reveal = 130,
			what_to_reveal = "text_wall",
			
			position = true,
			shake = {"wall", 130, 200},
			wait_until_position = 70,
			what_to_position = "wall",
			
			disregard_after = 205,
			
			particles = true,
			
			appear_sound = "intro_reveal_2f",
			disappear_sound = "intro_disappear_2",
		},
		
		rock =
		{
			start = 900,
			wait_until_open = 70,
			wait_until_reveal = 130,
			what_to_reveal = "text_rock",
			
			position = true,
			shake = {"rock", 130, 200},
			wait_until_position = 70,
			what_to_position = "rock",
			
			disregard_after = 205,
			
			particles = true,
			
			appear_sound = "intro_reveal_3f",
			disappear_sound = "intro_disappear_3",
		},
		
		flag =
		{
			start = 1220,
			wait_until_open = 70,
			wait_until_reveal = 130,
			what_to_reveal = "text_flag",
			
			position = true,
			shake = {"flag", 130, 200},
			wait_until_position = 70,
			what_to_position = "flag",
			
			disregard_after = 205,
			
			particles = true,
			
			appear_sound = "intro_reveal_4f",
			disappear_sound = "intro_disappear_4",
		},
	}
	local introdata = mmf.newObject(introdataid)
	
	local timer = introdata.values[INTROTIMER]
	local phase = introdata.values[INTROPHASE]
	
	timer = timer + 1
	introdata.values[INTROTIMER] = timer
	
	if (phase == 2) then
		for a,b in pairs(flowers) do
			if (b.start <= timer) and (b.start + b.wait_until_open + b.wait_until_reveal + b.disregard_after >= timer) then
				if (timer == b.start) then
					for i,unit in ipairs(units) do
						if (unit.strings[UNITNAME] == b.what_to_reveal) then
							local flowerid = MF_specialcreate("Flower_center")
							local flower = mmf.newObject(flowerid)
							
							flower.strings[2] = a
							flower.x = unit.x
							flower.y = unit.y
						end
					end
					
					if (b.appear_sound ~= nil) then
						MF_playsound(b.appear_sound)
					end
				elseif (timer == b.start + b.wait_until_open) then
					local flowerids = MF_findspecial(a)
			
					if (#flowerids > 0) then
						for i,flowerid in ipairs(flowerids) do
							local flower = mmf.newObject(flowerid)
							
							flower.values[6] = 1
						end
					end
					
					if (b.open_sound ~= nil) then
						MF_playsound(b.open_sound)
					end
				elseif (timer == b.start + b.wait_until_open + b.wait_until_reveal) then
					local flowerids = MF_findspecial(a)
			
					if (#flowerids > 0) then
						for i,flowerid in ipairs(flowerids) do
							local flower = mmf.newObject(flowerid)
							
							flower.values[6] = 2
						end
					end
					
					for i,unit in ipairs(units) do
						if (unit.strings[UNITNAME] == b.what_to_reveal) then
							unit.visible = true
						end
					end
					
					if (b.disappear_sound ~= nil) then
						MF_playsound(b.disappear_sound)
					end
				elseif (timer == b.start + b.wait_until_open + b.wait_until_reveal + b.wait_until_position) and b.position then
					for i,unit in ipairs(units) do
						if (unit.strings[UNITNAME] == b.what_to_position) then
							unit.values[FLOAT] = 0
							unit.values[POSITIONING] = -10
							
							local unitref = unitreference[unit.strings[UNITNAME]]
							local thisdata = tileslist[unitref]
							local changedata = changes[unitref] or {}
							
							local c = changedata.colour or thisdata.colour
							MF_setcolour(unit.fixed, c[1], c[2])
							unit.values[ZLAYER] = thisdata.layer
						end
					end
					
					if (b.what_to_position == "flag") then
						introdata.values[INTROPHASE] = 3
						introdata.values[INTROTIMER] = 0
					end
					
					local freq = 44000 + math.random(-9000,9000)
					MF_playsound_full("whoooooosh_loud",0,0,freq)
				end
				
				if (b.shake ~= nil) then
					local shakedata = b.shake
					
					if (timer > b.start + b.wait_until_open + shakedata[2]) and (timer < b.start + b.wait_until_open + shakedata[3]) then
						for i,unit in ipairs(units) do
							if (unit.strings[UNITNAME] == shakedata[1]) then
								unit.x = unit.x + math.random(-2, 2)
								unit.y = unit.y + math.random(-2, 2)
								
								if b.particles and (timer % 3 == 0) then
									local tx = (unit.x - Xoffset) / tilesize
									local ty = (unit.y - Yoffset) / tilesize
									particles("bling",tx,ty,1,{1, 1},0)
								end
							end
						end
					end
				end
			end
		end
	elseif (phase == 3) then
		local curris = math.floor(timer / 20) - 7
		local allis = {}
		
		if (curris > 7) then
			curris = curris - 3
		elseif (curris >= 5) and (curris <= 7) then
			curris = -1
		end
		
		for i,unit in ipairs(units) do
			local unitname = unit.strings[UNITNAME]
			
			if (unitname == "text_is") then
				table.insert(allis, unit)
			elseif (unitname == "text_stop") or (unitname == "text_push") or (unitname == "text_win") then
				table.insert(allis, unit)
			end
		end
		
		if (curris > 0) and (curris < 8) then
			if (timer % 20 == 0) then
				local flowerid = MF_specialcreate("Flower_center")
				local flower = mmf.newObject(flowerid)
				
				local unit = allis[curris]
				
				flower.strings[2] = "is"
				flower.values[10] = 2
				flower.x = unit.x
				flower.y = unit.y
				
				MF_playsound("intro_flower_" .. tostring(curris))
				
				if (curris == 7) then
					introdata.values[INTROPHASE] = 4
					introdata.values[INTROTIMER] = 0
				end
			end
		end
	elseif (phase == 4) then
		local curris = math.floor(timer / 20) - 1
		local allis = MF_findspecial("is")
		
		if (curris > 0) and (curris < 8) then
			if (timer % 20 == 0) then
				local flowerid = allis[curris]
				
				local flower = mmf.newObject(flowerid)
				
				flower.values[6] = 1
				
				if (curris == 7) then
					introdata.values[INTROPHASE] = 5
					introdata.values[INTROTIMER] = 0
				end
			end
		end
	elseif (phase == 5) then
		if (timer == 100) then
			local allis = MF_findspecial("is")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 2
			end
			
			for i,unit in ipairs(units) do
				local unitname = unit.strings[UNITNAME]
				
				if (unitname == "text_is") or (unitname == "text_win") or (unitname == "text_stop") or (unitname == "text_push") then
					unit.visible = true
				end
			end
			
			MF_playsound("intro_disappear_1")
			introdata.values[INTROPHASE] = 6
			introdata.values[INTROTIMER] = 0
		end
	elseif (phase == 6) then
		if (timer == 80) then
			MF_playsound("intro_reverse_baba")
		end
		
		if (timer == 110) then
			
			for i,unit in ipairs(units) do
				if (unit.strings[UNITNAME] == "text_you") then
					local flowerid = MF_specialcreate("Flower_center")
					local flower = mmf.newObject(flowerid)
					
					flower.strings[2] = "you"
					flower.values[10] = 1
					flower.values[8] = 3
					flower.x = unit.x
					flower.y = unit.y
				end
			end
		elseif (timer == 280) then
			local allis = MF_findspecial("you")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 1
			end
		end
		
		--[[
		if (timer == 135) then
			MF_playsound("intro_reverse_baba_short")
		end
		]]--
		
		if (timer > 380) then
			for i,unit in ipairs(units) do
				if (unit.strings[UNITNAME] == "tile") then
					unit.x = unit.x + math.random(-2, 2)
					unit.y = unit.y + math.random(-2, 2)
					
					if (timer % 5 == 0) then
						local tx = (unit.x - Xoffset) / tilesize
						local ty = (unit.y - Yoffset) / tilesize
						particles("bling",tx,ty,1,{1, 1},0)
					end
				end
			end
		end
		
		if (timer == 620) then
			local allis = MF_findspecial("you")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 2
			end
			
			for i,unit in ipairs(units) do
				if (unit.strings[UNITNAME] == "tile") then
					unit.values[FLOAT] = 0
					unit.values[POSITIONING] = -10
					
					local unitref = unitreference[unit.strings[UNITNAME]]
					local thisdata = tileslist[unitref]
					local changedata = changes[unitref] or {}
					
					local c = changedata.colour or thisdata.colour
					MF_setcolour(unit.fixed, c[1], c[2])
					unit.values[ZLAYER] = thisdata.layer
				end
			end
			
			for i,unit in ipairs(units) do
				local unitname = unit.strings[UNITNAME]
				
				if (unitname == "text_you") then
					unit.visible = true
				end
				
				unit.values[A] = 0
				unit.values[VISUALDIR] = 0
			end
			
			introdata.values[INTROPHASE] = 7
			introdata.values[INTROTIMER] = 0
			generaldata.values[IGNORE] = 0
			
			MF_setfile("save","ba.ba")
			MF_store("save","baba","firsttime",tostring(1))
			
			MF_setfile("save",tostring(generaldata2.values[SAVESLOT]) .. "ba.ba")
			
			MF_store("save","baba","intro",tostring(1))
			MF_store("save","baba","firsttime",tostring(1))
			MF_store("save","baba","0level_intro",tostring(1))
			
			introdata.values[VERYFIRSTTIME] = 0
		end
	elseif (phase == 7) then
		if (timer == 141) then
			introdata.values[INTROPHASE] = 0
			introdata.values[INTROTIMER] = 0
		end
	end
end

-- OLD ENDING CODE
--[[
function ending(enddataid)
	local enddata = mmf.newObject(enddataid)
	
	enddata.values[ENDTIMER] = enddata.values[ENDTIMER] + 1
	local phase = enddata.values[ENDPHASE]
	local timer = enddata.values[ENDTIMER]
	local ender = enddata.values[4]
	local ended = enddata.values[3]
	
	if (phase == 1) then
		if (timer == 2) then
			local unit = mmf.newObject(ended)
			local c1,c2 = getcolour(ended)
			MF_particles("smoke",unit.values[XPOS],unit.values[YPOS],20,c1,c2,1,1)
			
			unit.visible = false
			MF_playsound("drumroll")
			
			for i,unit in ipairs(units) do
				if (unit.strings[UNITTYPE] == "text") then
					unit.values[A] = math.random(0,200) * 0.0005
				end
			end
		end
		
		if (timer > 0) then
			for i,unit in ipairs(units) do
				if (unit.strings[UNITTYPE] == "text") then
					unit.x = unit.x + math.random(-1,1)
					unit.y = unit.y + math.random(-1,1)
					unit.values[POSITIONING] = 0
				end
			end
		end
		
		if (timer > 100) and (timer < 250) then
			local eunit = mmf.newObject(ended)
			local ex,ey = eunit.values[XPOS],eunit.values[YPOS]
			local texts = {}
			
			for i,unit in ipairs(units) do
				if (unit.strings[UNITTYPE] == "text") then
					table.insert(texts, unit.fixed)
				end
			end
			
			for i,unitid in ipairs(texts) do
				local unit = mmf.newObject(unitid)
				local x,y = unit.values[XPOS],unit.values[YPOS]
				
				unit.values[FLOAT] = 1
				
				local dir = 0 - math.atan2(ey - y, ex - x)
				local dist = math.abs(ey - y) + math.abs(ex - x)
				unit.values[A] = unit.values[A] + 0.002
				
				unit.values[XPOS] = x + math.cos(dir) * math.min(unit.values[A], dist)
				unit.values[YPOS] = y - math.sin(dir) * math.min(unit.values[A], dist)
				
				if (math.abs(ex - x) < 0.1) and (math.abs(ey - y) < 0.1) then
					local c1,c2 = 4,1
					local tdata = tileslist[unit.className]
					local tc = tdata.active
					c1 = tc[1]
					c2 = tc[2]
					
					MF_particles("bling",ex,ey,10,c1,c2,1,1)
					delete(unitid)
					updatecode = 0
				end
			end
			
			if (#texts == 0) then
				enddata.values[ENDPHASE] = 2
				enddata.values[ENDTIMER] = 0
				generaldata.values[SHAKE] = 4
				MF_stopsound("drumroll")
				MF_playsound("boom")
				
				local flowerid = MF_specialcreate("Flower_center")
				local flower = mmf.newObject(flowerid)
				
				flower.strings[1] = "you"
				flower.values[10] = 1
				flower.values[8] = 15
				flower.values[26] = 1
				flower.x = eunit.x
				flower.y = eunit.y
				
				MF_playsound("ending_reverse_baba2")
			end
		end
	end
		
	if (phase == 2) then
		if (timer == 120) then
			local allis = MF_findspecial("you")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 3
			end
		end
		
		if (timer == 310) then
			local allis = MF_findspecial("you")
			
			for i,flowerid in ipairs(allis) do
				local flower = mmf.newObject(flowerid)
				flower.values[6] = 1
			end
		end
		
		if (timer == 570) then
			dotransition()
		elseif (timer > 570) and (generaldata.values[TRANSITIONED] == 1) then
			clearunits()
			MF_loop("clear",1)
			
			enddata.values[ENDPHASE] = 3
			enddata.values[ENDTIMER] = 0
			generaldata.values[ONLYARROWS] = 0
			--generaldata.values[IGNORE] = 1
			generaldata.values[TRANSITIONED] = 0
			
			local xoffset = (screenw - roomsizex * tilesize * spritedata.values[TILEMULT]) * 0.5
			local yoffset = (screenh - roomsizey * tilesize * spritedata.values[TILEMULT]) * 0.5
			
			MF_setroomoffset(xoffset,yoffset)
			MF_loadbackimage("island,island_decor")
			levelborder()
			
			local flowerid = MF_specialcreate("Flower_center")
			local flower = mmf.newObject(flowerid)
			
			flower.strings[1] = "you"
			flower.values[10] = 1
			flower.values[8] = 1
			flower.values[6] = 1
			flower.x = tilesize * 16 * spritedata.values[TILEMULT]
			flower.y = tilesize * 14 * spritedata.values[TILEMULT]
		end
	end
	
	if (phase == 3) then
		if (timer == 150) then
			dotransition()
		elseif (timer > 150) and (generaldata.values[TRANSITIONED] == 1) then
			clearunits()
			MF_loop("clear",1)
			generaldata.values[MODE] = 2
			enddata.values[ENDPHASE] = 0
			enddata.values[ENDTIMER] = 0
		end
	end
end
]]--