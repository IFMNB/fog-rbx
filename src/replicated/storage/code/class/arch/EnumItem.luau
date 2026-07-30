--!strict

const object = require("../../object")
const declare = require("../../static/declare")
const empty = require("../../static/empty")
const namefield = require("../../static/namefield")
const project = require("../../static/project")

const class : declare.enumitem = object:new({
    type = namefield.enumitem,
    hashlink = 0,
    name = "",
})

class:toggle_host(function(new: declare.enumitem)
	local hval = 0x811c9dc5
    
	for i = 1, #new.name do
		hval = bit32.bxor(hval, string.byte(new.name, i))
		hval *= 0x01000193
		hval = bit32.band(hval, 0xFFFFFFFF)
	end

	if project.debug then
		if #new.name == 0 then
			project.console_out_error("enumitem.hashlink == 0", new.name)
		end
	end

    (new :: any).hashlink = hval
end)

return class