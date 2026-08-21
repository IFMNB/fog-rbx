--!strict
const DataStoreService = game:GetService("DataStoreService")
const Players = game:GetService("Players")
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const UserData = require("@game/ReplicatedStorage/class/local/UserData")
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")
const Result = require("@game/ReplicatedStorage/struct/common/Result")

const private = {}
const class : declare.user = object:new {
    type = namefield.user,
    uid = 0,

    request_data = function <T> (self: declare.user, of: declare.enumitem_user_data_require) : declare.userdata<any>
        if RunService:IsServer() then
            const storage = private.get_data_storage()
            const result = private.get_async(storage, self, of)
            const userdata = UserData:new {
                stored = result
            }    

            return userdata
        else
            const result_raw = private.get_require_channel():InvokeServer(of)
            const result = Result:rebuild(result_raw)
            const userdata = UserData:new {
                stored = result
            }

            return userdata
        end
    end,

    get_unit = function (self: declare.user) : declare.unit?
        return private.units[self]
    end,

    set_unit = function (self: declare.user, to: declare.unit?) : ()
        private.units[self] = to
    end,

    get_local_user = function (self: declare.user) : declare.user
        const local_player = Players.LocalPlayer

        return self:renew({
            uid = local_player and local_player.User.Id,
        })
    end,

    get_player = function (self: declare.user) : declare.reference<Player?>
        const player = Players:GetPlayerByUserId(self.uid)
        const reference = Reference:new() :: declare.reference<Player?>
        reference:set_instance(player)

        return reference
    end
}

do
    private.meta = table.freeze {__mode = "ks"}
    private.units = setmetatable({} :: {[declare.user]: declare.unit?}, private.meta)

    private.get_data_storage = function ()
        return DataStoreService:GetDataStore(project.unique)
    end

    private.get_async = function (of: DataStore, user: declare.user, item: declare.enumitem)
        const key = tostring(user.uid)
        const lambda_getter = function(...)
			local stored: { [unknown]: unknown } = of:GetAsync(key)

			if type(stored) ~= declare.table then
				of:SetAsync(key, {}, { user.uid })
				stored = {}
			end

			return stored
        end

        local state, out = pcall(lambda_getter)
        local i = project.retry
        
        while not state do
            task.wait(project.retry_time)
            i += 1

            state, out = pcall(lambda_getter)
        end

        return Result:new {
            state = state,
            result = out
        }
    end

    private.get_require_channel = function () : RemoteFunction
        if RunService:IsServer() then
            const event = ReplicatedStorage.shared:FindFirstChild("user_data_channel") :: RemoteFunction
            if event then
                return event
            else
                const new_event = Instance.new("RemoteFunction")
                new_event.Name = "user_data_channel"
                new_event.Parent = ReplicatedStorage.shared

                return new_event
            end
        else
            return ReplicatedStorage.shared:WaitForChild("user_data_channel", 100) :: RemoteFunction
        end
    end


    if RunService:IsServer() then
        private.get_require_channel().OnServerInvoke = function (player: Player, requested_item: declare.enumitem): declare.result
            if not UserDataRequire:is_my_enumitem(requested_item) then
                return Result:new({state = false})
            end

            const user = class:new({uid = player.User.Id})
            const stored = private.get_data_storage()
            const result = private.get_async(stored, user, requested_item)

            return result
        end
    end
end

return class