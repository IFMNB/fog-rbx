const MemoryStoreService = game:GetService("MemoryStoreService")
const MessagingService = game:GetService("MessagingService")
const Players = game:GetService("Players")
const TeleportService = game:GetService("TeleportService")
const Service = require("@game/ReplicatedStorage/code/Service")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Face = require("@game/ReplicatedStorage/code/class/face/Face")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Timer = require("@game/ReplicatedStorage/code/class/timer/Timer")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const object = require("@game/ReplicatedStorage/code/object")
const HttpRequest = require("../../class/httprequest/HttpRequest")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const Content = require("@game/ReplicatedStorage/code/struct/Content")
const Result = require("@game/ReplicatedStorage/code/struct/Result")
const config_names = require("../../static/config_names")
const Config = require("../../class/config/Config")
const Job = require("../../class/job/Job")
const ServerNotification = require("../../enums/ServerNotification")
const Server = require("../server/Server")
const Message = require("../../class/message/Message")

const private = {}
const class = {}
setmetatable(class, {__index = Service})

type server_data = {
    session_id: typeof(Server.session_id),
    players_count: number,
    country: string,
    version: typeof(project.version),
    timezone: string,
    state: number,
    shutdown_reason: number?,
    startup_unix_mls: number,
    updated_unix_mls: number
}
type package <T = {}?> = {Data: T, Sent: number}
type notification_package = package<{session_id: number, notification: number}>
export type class = typeof(private.singletone)

class.type = namefield.browser
class.api_access_key = project.interversion_searching and project.api_interversion_key or project.version
class.allow_join = project.default_browser_joining_from_outside
class.allow_move = project.default_browser_joining_from_inside
class.allow_join_to_pending_shutdown = project.browser_allow_joining_to_pending_shutdown

class.browser_size = Config.new(config_names.browser_list_size, 30) :: Config.class<number>
class.environment_update_time = Config.new(config_names.browser_environment_update_time, 10) :: Config.class<number>
class.browser_update_time = Config.new(config_names.browser_list_update_time, 5) :: Config.class<number>

class.move_retry_attempts = 5

function class:notificate_servers (server_notification: number)
    const this = self :: class
    MessagingService:PublishAsync(
        this.api_access_key, 
        {
            session_id = Server.session_id,
            notification = server_notification
        }
    )
end

function class:get_notification_event () : Face.class<notification_package>
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "notification_event", Event, function(new: Event.class)
        MessagingService:SubscribeAsync(this.api_access_key, function(received: notification_package)
            new:emit(received)
        end)
    end):get_face() :: object.generic
end

function class:get_browser_updated_event ()
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "server_list_update_event", Event.new):get_face()
end

function class:get_environment_updated_event()
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "server_environment_update_event", Event.new):get_face()
end

function class:get_environment()
    const this = self :: class
    const result = private.get_from_memory(this,Server.session_id) :: object.generic
    return result :: Result.class<Content.class<server_data>>
end

function class:move(who: Player|number, to_session: string)
    const this = self :: class
    const player = assert(game.IsA(who :: Object, "Player") and who :: Player or Players:GetPlayerByUserId(who :: number), "this is not a player")
    const options = Instance.new "TeleportOptions"

    assert(this.allow_move, "moving isn't allowed")

    options.ServerInstanceId = to_session
    options:SetTeleportData({
        from_session = Server.session_id
    })

    local result = Result :: Result.class<TeleportAsyncResult>
    local attempts = 0
    const event_ctrl_player_moved = Event.new()

    do
        const move = function ()
            repeat
                result:queue_free()
                result = Result.new(pcall(function(...)
                    return TeleportService:TeleportAsync(game.PlaceId, {player}, options)
                end))

                attempts += 1
            until (result.state == true or attempts >= this.move_retry_attempts)

            event_ctrl_player_moved:emit(result)
            event_ctrl_player_moved:queue_free()
        end

        if (project.default_behavior_is_deferred) then
            task.defer(move)
        else
            task.spawn(move)
        end
    end

    return event_ctrl_player_moved:get_face() :: Face.class<Result.class<TeleportAsyncResult>>
end

do --jobs_region

    function private.create_environment_update_job (this: class)
        return Upload.fetch(private.metadata:fetch(this), "server_hello_job", Message, function(new: Message.class)
            const metadata = private.metadata:fetch(this)
            const httprequest_to_server_position = HttpRequest.new("https://ipconfig.io/json")
            const result_of_server_position = httprequest_to_server_position:get_response_async() :: Result.class<{
                time_zone: string,
                country: string,
                country_iso: string,
                [string]: unknown
            }>

            const mls_time_now = DateTime.now().UnixTimestampMillis
            const memory_instance = private.get_memory(this)
            const initiated_hello_environment : server_data = {
                startup_unix_mls = mls_time_now,
                updated_unix_mls = mls_time_now,
                state = Server:get_current_server_state(),
                country = result_of_server_position.state and result_of_server_position.result.country or "Unknown",
                timezone = result_of_server_position.state and result_of_server_position.result.time_zone or "Unknown",
                players_count = #Players:GetPlayers(),
                session_id = Server.session_id,
                version = project.version,
            }

            new:set_topic(Server.session_id)
            memory_instance:SetAsync(new:get_topic(), initiated_hello_environment, this.environment_update_time:get_value() * 2)

            new.action = function (self: unknown)
                const server_data = this:get_environment()
                
                if (server_data.state) then
                    server_data.result.updated_unix_mls = DateTime.now().UnixTimestampMillis
                    server_data.result.state = Server:get_current_server_state()
                    server_data.result.players_count = #Players:GetPlayers()

                    memory_instance:SetAsync(new:get_topic(), server_data.result, this.environment_update_time:get_value() * 2)
                    if (metadata.server_environment_update_event) then
                        metadata.server_environment_update_event:emit(server_data.result)
                    end
                end
            end

            const timer = Timer.new(this.environment_update_time:get_value())
            timer:get_end_event():connect(function()
                timer.time_to_wait = this.environment_update_time:get_value()
            end)

            new:start(timer)
        end)
    end

    function private.create_server_list_update_job (this: class)
        const metadata = private.metadata:fetch(this)
        return Upload.fetch(metadata, "server_lists_job", Job, function(new: Job.class)
            const memory_instance: MemoryStoreHashMap = private.get_memory(this)
            
            new.action = function (self)
                const new_list = {}
                const request = Result.new(pcall(function(...)
                    return memory_instance:ListItemsAsync(this.browser_size:get_value())
                end)) :: Result.class<MemoryStoreHashMapPages>

                if (request.state) then
                    for i,v in request.result:GetCurrentPage() :: {{key: string, value: server_data}} do
                        new_list[v.key] = v.value
                    end
                end

                metadata.servers_list = new_list
                if (metadata.server_list_update_event) then
                    metadata.server_list_update_event:emit(table.clone(new_list))
                end
            end

            const timer = Timer.new(this.browser_update_time:get_value())
            timer:get_end_event():connect(function()
                timer.time_to_wait = this.browser_update_time:get_value()
            end)

            new:start(timer)
        end)
    end

    function private.get_from_memory (this: class, key: string)
        const memory_instance = private.get_memory(this)
        const state, val = pcall(function(...)
            return Content.new(memory_instance:GetAsync(key)) 
        end)

        return Result.new(state, val) :: Result.class<Content.class<{[string]: unknown}>>
    end

    function private.get_memory (this: class)
        return Upload.fetch(private.metadata:fetch(this), "hashmap", function ()
            return MemoryStoreService:GetHashMap(this.api_access_key)
        end) :: MemoryStoreHashMap
    end
end

private.metadata = Storage.new()
private.singletone = object.new(table.freeze(class), false)

do --initiate_region
    const browser = private.singletone

    if (project.browser_online and not project.debug_mode) then
        Server:get_shutdown_event():once(function(reason: number)
            browser:notificate_servers(ServerNotification.PreparingShutdown)
            const metadata = private.metadata:fetch(browser)

            metadata.server_hello_job:stop()
            const memory_instance = private.get_memory(browser)
            const latest_environment = browser:get_environment()
            
            if (latest_environment.state) then
                latest_environment.result.state = Server:get_current_server_state()
                latest_environment.result.shutdown_reason = reason

                local result = Result
                
                while (not result.state) do
                    result = Result.new(pcall(function(...)
                        return memory_instance:SetAsync(Server.session_id, latest_environment.result, 10)
                    end))
                end
            end

            browser:notificate_servers(ServerNotification.Shutdown)
        end)

        private.create_environment_update_job(browser)
        private.create_server_list_update_job(browser)
        browser:notificate_servers(ServerNotification.NewServer)
    end


    TeleportService.LocalPlayerArrivedFromTeleport:Connect(function(a0: Player, a1)
        if (not project.browser_online or not browser.allow_join) then
            a0:Kick "browser does not allow you to join this session"
        end
    end)
end

return private.singletone