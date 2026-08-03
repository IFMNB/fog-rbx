--LEGACY

const collection_service = game:GetService("CollectionService")
const http_service = game:GetService("HttpService")
const service = require("@game/ReplicatedStorage/class/service/Service")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const event = require("@game/ReplicatedStorage/class/event/Event")
const connection_state = require("@game/ReplicatedStorage/enums/ConnectionState")

const private = {}
const class = { __index = service }
setmetatable(class, class)

export type class = typeof(class)

class.type = namefield.hitcheck

private.uid_events = {} :: { [string]: event.class }

function class:get_tag(instance: BasePart): string
	const this = self :: class
	const tags = collection_service:GetTags(instance) :: { string? }
	local uid: string = ""

	for i, v in tags do
		if string.match(v, this.type) then
			uid = v
			break
		end
	end

	if uid == "" then
		uid = this.type .. http_service:GenerateGUID()
		const event_controller = event.new()
		private.uid_events[uid] = event_controller
	end

	collection_service:AddTag(instance, uid)

	instance.Destroying:Once(function()
		const event_controller = private.uid_events[uid]
		event_controller:free()
	end)

	return uid
end

function class:get_tag_event(uid: string): event.class?
	const event_controller = private.uid_events[uid]

	if event_controller then
		return event_controller:get_face()
	else
		return nil
	end
end

function class:get_all_tagged_hitable()
	const this = self :: class
	const to_return: { BasePart } = {}

	for i, v in collection_service:GetAllTags() do
		const object = collection_service:GetTagged(v)

		if typeof(object) == "BasePart" then
			if string.match(v, this.type) then
				table.insert(to_return, object :: any)
			end
		end
	end

	return to_return
end

function class:emit_hitted(uid: string)
	const event_controller = private.uid_events[uid]

	if event_controller then
		event_controller:emit()
	end
end

function class:raycast_check(from: Vector3, direction: Vector3): string?
	const this = self :: class
	const raycast = RaycastParams.new()

	raycast.FilterType = Enum.RaycastFilterType.Include
	raycast.IgnoreWater = true
	raycast.IncludeInstances = this:get_all_tagged_hitable() :: { Instance }
	raycast.BruteForceAllSlow = false
	raycast.RespectCanCollide = true

	return nil
end

table.freeze(class :: any)
return class
