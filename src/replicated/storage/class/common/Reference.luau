--!strict
const Observer = require("@game/ReplicatedStorage/class/core/Observer")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: reference = Observer:new({
	type = "reference",

	get_instance = ftype:write(function(self: reference): any?
		return private.stored[self]
	end, ftype:opt(declare.anyt), "reference"),

	set_instance = ftype:write(function(self: reference, to: any): ()
		const stored = private.stored[self]
		const connection = private.connections[self]
		private.stored[self] = to

		if project.debug.state and project.debug.show_reference_internal then
			project.console_out("new stored", to)
		end

		if connection then
			if project.debug.state and project.debug.show_reference_internal then
				project.console_out("previous connection detected and removed")
			end

			connection:Disconnect()
			private.connections[self] = nil
		end

		if typeof(to) == "Instance" then
			const that = to :: Instance

			if project.debug.state and project.debug.show_reference_internal then
				project.console_out("detected instance, setup new destroy connection")
			end

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

	is_instance_exists = ftype:write(function(self: reference): boolean
		return typeof(self:get_instance()) == "Instance"
	end, declare.boolean, "reference"),

	clear = ftype:write(function(self: reference): ()
		const instance = self:get_instance()
		if instance and type(instance) == declare.roblox.Instance then
			const rbx_instance = instance :: Instance
			rbx_instance:Destroy()
		end

		self:set_instance(nil :: any)
	end, declare["nil"], "reference"),
})

do
	private.frozen = declare.tables.__mode_ks
	private.stored = setmetatable({} :: { [reference]: Instance }, private.frozen)
	private.connections = setmetatable({} :: { [reference]: RBXScriptConnection }, private.frozen)
end

return class
