const Record = require("../Record")
const object = require("../object")
const namefield = require("../static/namefield")

const struct = {__index = Record}
setmetatable(struct, struct)

export type struct = object.class<typeof(struct)>
export type free_supported = ()->()|thread|RBXScriptConnection|setmetatable<{[any]:any}, {[any]: any}>|Instance|struct|any
export type in_table = {[any]: any|free_supported}

struct.type = namefield.liberator
struct.in_table = {} :: in_table
struct.for_index = nil :: unknown|free_supported?
struct.parse_every_in_table = false

function struct.new (table: in_table?, for_index: unknown|free_supported?, parse_every: boolean?, identity: typeof(object.identity)?)
	const this = object.new(struct)

	this.in_table = table
	this.for_index = for_index
	this.parse_every_in_table = parse_every
    this.identity = identity or this.identity

	return this
end

return table.freeze(struct)