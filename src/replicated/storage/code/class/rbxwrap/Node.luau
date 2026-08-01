--!strict
const Disposable = require("@game/ReplicatedStorage/code/class/arch/Disposable")
const Reference = require("@game/ReplicatedStorage/code/class/common/Reference")
const Maybe = require("@game/ReplicatedStorage/code/class/lazystorage/Maybe")
const Attribute = require("@game/ReplicatedStorage/code/class/rbxwrap/Attribute")
const NotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/NotificationVariant")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class: declare.node = Disposable:new({
	type = namefield.node,

	get_reference = function(self: declare.node): declare.reference<any>
		return private.maybe_ref:extract(self, function()
			return Reference:new()
		end)
	end,


    get_attribute_list = function (self: declare.node) : {declare.value}
        const result = {}

        for _, v in private.get_attributes(self) do
            table.insert(result, v:get_params())
        end

        return result
    end,

    get_attribute = function (self: declare.node, name: string) : declare.value?
        for _, v in private.get_attributes(self) do
            if v.name == name then 
                return v:get_params()
            end
        end

        return nil
    end,

    add_attribute = function (self: declare.node, name: string) : declare.value
        const stored = private.get_attributes(self)
        
        for _, v in stored do
            if v.name == name then
                return v:get_params()
            end
        end

        const attribute_new = Attribute:new {name = name}
        table.insert(stored, attribute_new)

        return attribute_new:get_params()
    end,

    remove_attribute = function  (self: declare.node, name: string) : ()
        const stored = private.get_attributes(self)
        
        for i, v in stored do
            if v.name == name then
                v:queue_free()
                table.remove(stored, i)
                return
            end
        end

        return
    end
})

class:toggle_host(function(new: declare.node)
    new:get_notification_event():connect(function ()
        const attributes = private.get_attributes(new)
        for _, v in attributes do
            v:free()
        end
        table.clear(attributes)
    end, NotificationVariant.PreRelease)
end)

do
    private.maybe_atr = Maybe:new() -- {declare.attribute}
	private.maybe_ref = Maybe:new() -- declare.reference

    function private.get_attributes (to: declare.node)
        return private.maybe_atr:extract<<{declare.attribute}>>(to, function()
            return {} :: {declare.attribute}
        end)
    end
end

return class
