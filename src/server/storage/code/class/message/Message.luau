const HttpService = game:GetService("HttpService")
const Disposable = require("@game/ReplicatedStorage/Disposable")
const Storage = require("@game/ReplicatedStorage/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/class/upload/Upload")
const object = require("@game/ReplicatedStorage/object")
const Job = require("../job/Job")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class = { __index = Job }
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.message

function class.new()
	return Disposable.new(class, true)
end

function class:get_id()
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return Upload.fetch(metadata, "id", HttpService:GenerateGUID(false))
end

function class:set_topic(to: string?)
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	metadata.topic = to or "unknown"
end

function class:get_topic(): string
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return metadata.topic or "unknown"
end

function class:set_owner(to: string?)
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	metadata.owner = to or ""
end

function class:get_onwer()
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return metadata.owner or ""
end

function class:is_owned()
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return metadata.owner == ""
end

function class:get_data()
	const this = self :: class
	return private.data:fetch(this, { message_id = this:get_id() })
end

private.metadata = Storage.new()
private.data = Upload.new() -- {[class]: {[any]:any}}

return table.freeze(class)
