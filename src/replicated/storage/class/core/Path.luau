--!strict
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const class : path = object:new {
    type = "path",
    absolute_path = "",

    set_path = function (self: path, to: string|Instance) : ()
        const T = typeof(to)

        if T == declare.string then
            self.absolute_path = to :: string
        elseif T == declare.roblox.Instance then
            const var = to :: Instance
            self.absolute_path = var:GetFullName()
        else
            project.console_out_error("cannot set new path, because argument isn't supported now")
        end
    end,

    get_object = function (self: path) : Instance?
        local current: Instance = game
        for _, name in string.split(self.absolute_path, ".") do
            if name == game.Name or name == "game" then continue end

            const child = current:FindFirstChild(name)
            if not child then return nil end
            
            current = child
        end

        return current
    end
}


return class