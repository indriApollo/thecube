
-- nodes

local dirtNode = minetest.registered_nodes["default:dirt"]
dirtNode.description = "cube dirt"
dirtNode.is_ground_content = false -- to avoid caves and trees
minetest.register_node("thecube:dirt",dirtNode)

local stoneNode = minetest.registered_nodes["default:stone"]
stoneNode.description = "cube stone"
stoneNode.is_ground_content = false -- to avoid caves and trees
minetest.register_node("thecube:stone",stoneNode)

local sandNode = minetest.registered_nodes["default:sand"]
sandNode.description = "cube sand"
sandNode.is_ground_content = false -- to avoid caves and trees
minetest.register_node("thecube:sand",sandNode)

local glassNode = minetest.registered_nodes["default:glass"]
glassNode.description = "cube glass"
minetest.register_node("thecube:glass",glassNode)

local bronzeNode = minetest.registered_nodes["default:bronzeblock"]
bronzeNode.description = "cube bronze"
bronzeNode.is_ground_content = false -- to avoid caves and trees
minetest.register_node("thecube:bronzeblock",bronzeNode)

local goldblockNode = thecube.copy_table(minetest.registered_nodes["default:goldblock"]) -- copy table to add stuff
goldblockNode.description = "* Golden Snitch *"
goldblockNode.is_ground_content = false -- to avoid caves and trees
goldblockNode.after_dig_node = function(pos, oldnode, oldmetadata, digger)
minetest.chat_send_all(digger:get_player_name().. " has dug the Golden Snitch ! Hourra !")
end
minetest.register_node("thecube:goldensnitch",goldblockNode)

-- chatcommands

minetest.register_privilege("thecube", "Player can place treasure cubes")

minetest.register_chatcommand("cube", {
	params = "undo | do <size> <ntreasures> <dirt|stone|sand|glass> [1] (enable Golden Snitch)",
	description = "Create a cube with given size,node and treasures. Use undo to restore terrain after a cube generation.",
	privs = {thecube = true},
	func = function(name,params)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local facedir = minetest.dir_to_facedir(player:get_look_dir())
		local playerpos = player:getpos()

		params = string.split(params," ") -- parameters are split to a table

		if not params[1] then -- undo | do
			minetest.log("info","[thecube] Missing parameter undo | do !")
			return false, "[thecube] Missing parameter undo | do !"
		elseif params[1] == "undo" then
			local retval ,errmsg = thecube.restoreTerrain()
			return retval, errmsg
			-- exit function after undo
		elseif params[1] ~= "do" then
			minetest.log("info","[thecube] Invalid parameter undo | do !")
			return false, "[thecube] Invalid parameter undo | do !"
		end

		local cube_size = tonumber(params[2]) -- <size>
		if not params[2] then
			minetest.log("info","[thecube] Missing parameter <size> !")
			return false, "[thecube] Missing parameter <size> !"
		elseif not cube_size or cube_size < 3 then -- cube must be at least 3x3x3 to avoid complications
			minetest.log("info","[thecube] Invalid parameter <size> !")
			return false, "[thecube] Invalid parameter <size> !"
		end

		local nrandom = tonumber(params[3]) -- <ntreasures>
		if not params[3] then
			minetest.log("info","[thecube] Missing parameter <ntreasures> !")
			return false, "[thecube] Missing parameter <ntreasures> !"
		elseif not nrandom or nrandom <= 0 or nrandom > math.pow(cube_size,3) then
			minetest.log("info","[thecube] Invalid parameter <ntreasures> !")
			return false, "[thecube] Invalid parameter <ntreasures> !"
		end

		local nodename = params[4] -- <dirt|stone|sand|glass>
		if not params[4] then
			minetest.log("info","[thecube] Missing parameter <dirt|stone|sand|glass> !")
			return false, "[thecube] Missing parameter <dirt|stone|sand|glass> !"
		elseif nodename ~= "dirt" and nodename ~= "stone" and nodename ~= "sand" and nodename ~= "glass" then
			minetest.log("info","[thecube] Invalid parameter <dirt|stone|sand|glass> !")
			return false, "[thecube] Invalid parameter <dirt|stone|sand|glass> !"
		end

		local goldenSnitchBool = tonumber(params[5]) -- [1] (enable Golden Snitch)
		if params[5] and not goldenSnitchBool then
			minetest.log("info","[thecube] Invalid Golden Snitch parameter, must be 1 or nothing !")
			return false, "[thecube] Invalid Golden Snitch parameter, must be 1 or nothing !"
		end

		thecube.placeCube(playerpos,facedir,cube_size,nrandom,nodename,goldenSnitchBool)

		minetest.log("action","[thecube] Done!") -- everything went fine :D
		return true, "[thecube] Done."
	end,
})
