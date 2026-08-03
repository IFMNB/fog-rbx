const Disposable = require("@game/ReplicatedStorage/Disposable")
const StorageMode = require("@game/ReplicatedStorage/enums/StorageMode")
const object = require("@game/ReplicatedStorage/object")
const storage = require("@game/ReplicatedStorage/class/storage/Storage")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")
const Entity = require("../entity/Entity")

const private = {}
const class = { __index = Entity }
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.lifeform
class.run_speed = 24
class.walk_speed = 12
class.jump_height = 3
class.crounch_speed = 8
class.classname = "PVInstance" :: "PVInstance"

function class.new()
	return Disposable.new(class, true)
end

function class:get_expected_instance_classname()
	return "PVInstance"
end

private.metadata = storage.create_table_with(StorageMode.LazyKeys) :: { [class]: {
	navigation_agent_pos: Vector3,
}? }

function private.get_metadata(this: class)
	local metadata = private.metadata[this]
	if metadata then
		return metadata
	else
		private.metadata[this] = {}

		metadata = private.metadata[this]
		return metadata
	end
end

return table.freeze(class)
