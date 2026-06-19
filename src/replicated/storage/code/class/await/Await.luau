--!strict

const RunService = game:GetService("RunService")
const object = require("../../object")
const class_names = require("../../static/class_names")

const private = {}
const class = {}
setmetatable(class, {__index = object})

export type class = typeof(class.new())
export type generic <T = unknown> = setmetatable<{
    type: typeof(class.type),
    new: (wait_for: any?) -> class,
    wait: (self: class) -> T,
    load: T?,
    deferred: boolean
}, typeof(object)>

class.type = class_names.await
class.load = nil :: Instance|string|nil
class.deferred = false

private.awaited = setmetatable({}::{[class]:{thread}}, {__mode = "ks"})

function class.new(wait_for: any?)
    const this = object.new(class, true)
    this.load = wait_for
    private.awaited[this] = {}
    return this
end

function class:wait ()
    const this = self :: class

    table.insert(private.awaited[this], coroutine.running())
    coroutine.yield()

    return this.load :: any
end

function private.await_process ()
    for i,v in private.awaited do
        if (i.load ~= nil) then
            const type_load = typeof(i.load)

            private.check_and_set_string(i, type_load)

            private.push_event(i)
        end
    end
end

function private.check_and_set_string (this: class, type_load: string)
    if (type_load == "string") then
        const instance = private.get_by_path(this.load :: string)

        if (instance) then
            this.load = instance
            return true
        end
    end

    return false
end

function private.push_event (this: class)
    for j,k in private.awaited[this] do
        if (this.deferred) then
            task.defer(k)
        else
            task.spawn(k)
        end
    end
end

function private.get_by_path (path: string) : Instance?
    if path == '' or path == nil then
		return nil
	end
	
	local current = game
	
    
    for name in string.gmatch(path, "[^.]+") do
		if name ~= "game" then
			current = current:FindFirstChild(name)
			if not current then
				return nil
			end
		end
	end
	return current
end

RunService.Heartbeat:Connect(private.await_process)
table.freeze(class :: any)
return class