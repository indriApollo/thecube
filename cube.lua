
-- We want the cube to be front-right of the caster
-- x: left(--), right(++)
-- y: front(++), back(--)
-- z: top(++),bottom(--)

--            z facedir 0
--                 ^
--                 |
--                 |
-- facedir 3  -----------> x facedir 1
--                 |
--                 |
--                 facedir 2
--
--          ___________ pos2
--         |           |
--         |           |
--         |           |
--         |           |
--         |___________|
--     pos1


thecube.placeCube = function(playerpos,facedir,cube_size,nrandom,nodename,goldenSnitchBool)
	cube_size = cube_size - 1 -- decrease by 1 to match caster's expectation
	local pos1 = {} -- pos1 is adjusted to always be the lower left corner (see top comments)
	local pos2 = {}
	if facedir == 0 then
		pos1 = {x=playerpos.x, y=playerpos.y, z=playerpos.z+1}
	elseif facedir == 1 then
		pos1 = {x=playerpos.x+1, y=playerpos.y, z=playerpos.z-cube_size}
	elseif facedir == 2 then
		pos1 = {x=playerpos.x-cube_size, y=playerpos.y, z=playerpos.z-cube_size-1}
	elseif facedir == 3 then
		pos1 = {x=playerpos.x-cube_size-1, y=playerpos.y, z=playerpos.z}
	end
	pos1 = vector.round(pos1)
	pos2 = vector.add(pos1,cube_size) -- pos2 is the top right corner
	local volume = math.pow(cube_size+1,3)

	local manip = minetest.get_voxel_manip()
	local emerged_pos1, emerged_pos2 = manip:read_from_map(pos1, pos2)
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
	local nodes = manip:get_data()

	thecube.saveNodesToFile(nodes,pos1,pos2,"thecube_save") -- the old nodes are saved

	local id = minetest.get_content_id("thecube:"..nodename)
	local nrandom_id = minetest.get_content_id("thecube:bronzeblock")
	local goldensnitch_id = minetest.get_content_id("thecube:goldensnitch")
	local interval = thecube.round(volume / nrandom) -- volume/nr wanted ores
	local maxrandom = interval
	local minrandom = 1

	math.randomseed(os.time())
	local tablerandom = {}
	for i=1, nrandom do -- we create a table with the random indexes
		tablerandom[i] = math.random(minrandom,maxrandom)
		minetest.log("info","random interval :"..minrandom.."->"..maxrandom)
		minrandom = minrandom + interval
		maxrandom = maxrandom + interval
		minetest.log("info","random :"..tablerandom[i])
	end
	local tablec,areaindex = 1,1
	for i in area:iterp(pos1, pos2) do
		if tablerandom[tablec] == areaindex then
			-- if the actual nodes table index matches our random indexes, we put a different node in the table
			nodes[i] = nrandom_id
			tablec = tablec + 1
		else
			nodes[i] = id
		end
		areaindex = areaindex + 1
	end
	if goldenSnitchBool == 1 then -- add the golden snitch in the nodes table
		local gx = thecube.round(math.random(pos1.x+1,pos2.x-1)) -- a random pos between pos1 & pos2
		local gy = thecube.round(math.random(pos1.y+1,pos2.y-1)) -- at least 1 block away from the border
		local gz = thecube.round(math.random(pos1.z+1,pos2.z-1)) -- not visible from the outside (unless glass duh)
		minetest.log("info","GoldenSnitch pos "..gx..":"..gy..":"..gz)
		nodes[area:index(gx,gy,gz)] = goldensnitch_id
	end
	-- write changes to map
	manip:set_data(nodes)
	manip:write_to_map()
	manip:update_map()

end
