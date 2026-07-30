const Service = require("../../Service")
const Upload = require("../../class/upload/Upload")
const Wrapper = require("../../class/wrapper/Wrapper")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")

const private = {}
const class = {}
setmetatable(class, { __index = Service })

export type class = typeof(class)

class.type = namefield.linked

-- Ссылки могут быть созданы только 1 раз на 1 объект.
function class.link(this: object.class, to: Instance)
	const global_for_to = Wrapper.get_global_wrap(to)

	if private.stored:is_exists(global_for_to) then
		project.console_out_error("instance already linked, abort")
		return
	end

	private.stored:fetch(global_for_to, this, function(new: object.class)
		this:watch_free_event(function()
			private.stored:clear(global_for_to)
		end)
	end)
	private.stored:fetch(this, global_for_to, function(new: Wrapper.class)
		global_for_to:watch_free_event(function()
			private.stored:clear(this)
		end)
	end)
end

type function negation(t: type)
	return types.negationof(t)
end
type Test = {} & setmetatable<{}, { __index: { P: number } }>

local b: Test & negation<nil>
b.P = 4

function class.get_by_instance(to: Instance): object.class?
	if private.stored:is_exists(to) then
		return private.stored:fetch(to, nil) :: object.class
	else
		return nil
	end
end

function class.get_by_this(this: object.class): Instance?
	if not private.stored:is_exists(this) then
		return nil
	end

	const linked_instance_global = private.stored:fetch(this, nil) :: Wrapper.class<Instance>
	return linked_instance_global:get_holder() :: Instance
end

private.stored = Upload.new() -- {[wrapper]: object.generic}

do --init_region
	const linked = object.new(class, class.type)

	private.singletone = linked
	table.freeze(class)
	table.freeze(private)
end

return private.singletone
