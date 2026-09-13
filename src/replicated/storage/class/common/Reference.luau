--!strict
const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.reference = Observer:new({
	type = "reference",

	get_instance = ftype:write(function(self: declare.reference): any?
		return private.stored[self]
	end, ftype:opt(declare.anyt), "reference"),

	set_instance = ftype:write(function(self: declare.reference, to: any): ()
		const stored = private.stored[self]
		const connection = private.connections[self]
		private.stored[self] = to

		if connection then
			connection:Disconnect()
			private.connections[self] = nil
		end

		if typeof(to) == "Instance" then
			const that = to :: Instance

			private.connections[self] = that.Destroying:Once(function()
				self:notificate(ReferenceNotification.DestroyedInstance )
			end)
		end

		if stored == nil and to == nil then
			self:notificate(ReferenceNotification.NullifiedInstance )
		elseif stored == nil and to ~= nil then
			self:notificate(ReferenceNotification.NewInstance )
		elseif stored ~= to then
			self:notificate(ReferenceNotification.ChangedInstance )
		else
			project.console_out("missmatch reference")
		end
	end, declare["nil"], "reference", ftype:uor(declare.roblox.Instance, declare.anyt)),

	is_instance_exists = ftype:write(function(self: declare.reference): boolean
		return typeof(self:get_instance()) == "Instance"
	end, declare.boolean, "reference"),

	clear = ftype:write(function(self: declare.reference): ()
		const instance = self:get_instance()
		if instance and type(instance) == declare.roblox.Instance then
			const rbx_instance = instance :: Instance
			rbx_instance:Destroy()
		end

		self:set_instance(nil :: any)
	end, declare["nil"], "reference"),
})

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.stored = setmetatable({} :: { [declare.reference]: Instance }, private.frozen)
	private.connections = setmetatable({} :: { [declare.reference]: RBXScriptConnection }, private.frozen)
end

return class
