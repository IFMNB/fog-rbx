--!strict
const Node = require("@game/ReplicatedStorage/class/actors/Node")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.graphnode = (Node :: declare.node<Folder>):new {
    type = "graphnode",
    name = "GraphNode",
    auto_free_on_destroying = true,

    get_parent = function (self: declare.graphnode) : Instance?
        return self:get_dependency(private.key) :: any
    end,

    set_parent = function (self: declare.graphnode, parent: Instance|declare.node|declare.graphnode|declare.reference|nil) : ()
        const reference = self:get_reference()
        const rbx_node_instance = project.assert(reference:get_instance(), "internal graph node error", true)
        if not rbx_node_instance then return end

        const T = typeof(parent)

        if T == declare.roblox.Instance then
            rbx_node_instance.Parent = parent :: Instance
        elseif T == declare.table then
            if self.is(parent, Node.type) then
                const var = parent :: declare.node
                rbx_node_instance.Parent = var:get_reference():get_instance()

                self:rem_dependency(nil, private.key)
                self:add_dependency(var, private.key)
            elseif self.is(parent, "graphnode") then
                const var = parent :: declare.graphnode
                rbx_node_instance.Parent = var:get_reference():get_instance()

                self:rem_dependency(nil, private.key)
                self:add_dependency(var, private.key)
            elseif self.is(parent, reference.type) then
                const var = parent :: declare.reference
                rbx_node_instance.Parent = var:get_instance()

                self:rem_dependency(nil, private.key)
                self:add_dependency(var, private.key)
            else
                project.console_out_error(`unknown new parent {tostring(parent)}, class aborted`)
            end
        elseif T == nil then
            rbx_node_instance.Parent = nil
        else
            project.console_out_error(`unknown new parent {tostring(parent)}, unexpected aborted`)
        end
    end
}

class:host(function(new: declare.graphnode): ()
	const reference = new:get_reference()
    const graph_node_element_in_rbx = Instance.new "Folder"
    graph_node_element_in_rbx.Name = new.name
    
    reference:set_instance(graph_node_element_in_rbx)
    const c0 = reference:subscribe(ReferenceNotification, ConnectionVariant.Ever, function ()
        if reference:get_instance() ~= graph_node_element_in_rbx then
            reference:set_instance(graph_node_element_in_rbx)
        end
    end)

    new:subscribe(DisposableNotification.Released, ConnectionVariant.Once, function ()
        reference:unsubscribe(c0)
    end)

    for i, v in new :: {[unknown]: unknown} do
        const T0, T1 = typeof(i), typeof(v)

        if not declare.is_primetive(T0) then continue end
        if not declare.is_primetive(T1) then continue end
        if T0 ~= declare.string then continue end

        new:add_attribute(i :: string):set_value(v)
    end
end)

do
    private.key = SecurityRNG:get_hash_sha256("graphnode_key")
end

return class