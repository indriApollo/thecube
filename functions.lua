
--helper functions

thecube.round = function(x) -- rounds up (default floor rounds down)
	x = math.floor(x+0.5)
	return x
end

thecube.copy_table = function(t)
	local nt = {}
	for k, v in pairs(t) do
		nt[k] = v
	end
	return nt
end 
