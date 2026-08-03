const Players = game:GetService("Players")
const Disposable = require("@game/ReplicatedStorage/Disposable")
const Event = require("@game/ReplicatedStorage/class/event/Event")
const Node = require("@game/ReplicatedStorage/class/node/Node")
const Storage = require("@game/ReplicatedStorage/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/class/upload/Upload")
const Value = require("@game/ReplicatedStorage/class/value/Value")
const Wrapper = require("@game/ReplicatedStorage/class/wrapper/Wrapper")
const NodeNotificationType = require("@game/ReplicatedStorage/enums/NodeNotificationType")
const StorageMode = require("@game/ReplicatedStorage/enums/StorageMode")
const object = require("@game/ReplicatedStorage/object")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class = { __index = Node }
setmetatable(class, class)

export type class = typeof(class.new())

class.type = namefield.faction
class.name = "Aftersky"
class.max = project.default_max_players_in_faction

function class.new()
	return Disposable.new(class, true)
end

function class:get_count()
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return Upload.fetch(metadata, "count_value", function()
		return Value.new("number") :: Value.generic<number>
	end, function(new: Value.generic<number>)
		this:watch_free_event(function()
			new:free()
		end)
		new:bind_attribute(this, "count")
		this:notificate(NodeNotificationType.new_lazy_value, "count", new)
	end)
end

function class:on_initiate(base: Node.class?)
	const this = self :: class
	const team = this:get_instance() :: Team
	const metadata = private.metadata:fetch(this)
	const to_load: { Wrapper.class<Player> } = metadata.load_when_initiated
	if to_load then
		for i, v in to_load do
			v:get_holder().Team = team
		end
		metadata.load_when_initiated = nil
	end

	const players: { Wrapper.class<Player> } =
		Upload.fetch(metadata, "players", Storage.create_table_with(StorageMode.LazyValues))

	team.PlayerAdded:Connect(function(a0: Player)
		if not Wrapper.find_wrapper_that_holds_that(a0, players) then
			a0.Team = nil
			assert(not project.debug, "someone trying to bypass faction defend rule by adding player. aborted")
		end
	end)
	team.PlayerRemoved:Connect(function(a0: Player)
		if Wrapper.find_wrapper_that_holds_that(a0, players) then
			a0.Team = team
			assert(not project.debug, "someone trying to bypass faction defend rule by removing player. aborted")
		end
	end)
end

function class.get_expected_instance_classname()
	return "Team"
end

function class:get_player_added_event()
	const this = self :: class
	return Upload.fetch(private.metadata:fetch(this), "player_added_event_ctrl", function()
		const new = Event.new()
		this:watch_free_event(function()
			new:free()
		end)
		this:notificate(NodeNotificationType.new_lazy_value, "player_added_event", new:get_face())
		return new
	end):get_face()
end

function class:get_player_removed_event()
	const this = self :: class
	return Upload.fetch(private.metadata:fetch(this), "player_removed_event_ctrl", Event, function()
		const new = Event.new()
		this:watch_free_event(function()
			new:free()
		end)
		this:notificate(NodeNotificationType.new_lazy_value, "player_removed_event", new:get_face())
	end):get_face()
end

function class:get_players(): { Wrapper.class<Player> }
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	const players: { Wrapper.class<Player> } =
		Upload.fetch(metadata, "players", Storage.create_table_with(StorageMode.LazyValues))
	const unpacked = {}

	for i, v in players do
		table.insert(unpacked, v:get_holder() :: Player)
	end

	return unpacked
end

function class:add_player(player: Player | number)
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	const players: { Wrapper.class<Player> } =
		Upload.fetch(metadata, "players", Storage.create_table_with(StorageMode.LazyValues))
	const wrap = Wrapper.new() :: Wrapper.class<Player>
	const instance_player: Player? = (player or game):IsA("Player") and player
		or Players:GetPlayerByUserId(player)
		or nil
	if not instance_player then
		return
	end

	if Wrapper.find_wrapper_that_holds_that(instance_player, players) then
		return false
	end

	wrap:hold(instance_player)
	table.insert(players, wrap)

	if not this:is_initiated() then
		const to_load = Upload.fetch(metadata, "load_when_initiated", Storage.create_table_with(StorageMode.LazyValues))
		table.insert(to_load, wrap)
	else
		const team = this:get_instance()
		instance_player.Team = team
	end

	if metadata.player_added_event_ctrl then
		metadata.player_added_event_ctrl:emit(wrap:get_holder())
	end

	this.count += 1

	return true
end

function class:remove_player(player: Player | number)
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	const players: { Wrapper.class<Player> } =
		Upload.fetch(metadata, "players", Storage.create_table_with(StorageMode.LazyValues))
	const instance_player: Player? = (player or game):IsA("Player") and player
		or Players:GetPlayerByUserId(player)
		or nil
	const is_initiated = this:is_initiated()

	if is_initiated then
		const team = this:get_instance()
		if instance_player.Team ~= team then
			return
		end
	end

	if not instance_player then
		return
	end

	const wrap = Wrapper.find_wrapper_that_holds_that(instance_player, players) :: Wrapper.class<Player>?
	if wrap then
		table.remove(players, table.find(players, wrap))

		if not is_initiated then
			const to_load =
				Upload.fetch(metadata, "load_when_initiated", Storage.create_table_with(StorageMode.LazyValues))
			const pos = table.find(to_load, wrap)
			if pos then
				table.remove(to_load, pos)
			end
		else
			instance_player.Team = nil
		end

		if metadata.player_removed_event_ctrl then
			metadata.player_removed_event_ctrl:emit(wrap:get_holder())
		end

		this.count -= 1
	end
end

private.metadata = Storage.new()

return table.freeze(class)
