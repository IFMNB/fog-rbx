--!strict
const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const declare = require("@game/ReplicatedStorage/static/declare")

export type channel <T = declare.enumitem_network_replication, U... = ...unknown, E... = ...unknown> = declare.construct<{
    everyone: boolean,
    echo: boolean,

    read send: (self: channel<T,U...,E...>, to: T, U...) -> (),
    read sync: (self: channel<T,U...,E...>, to: T, U...) -> declare.answer<T,E...>,
    read async: (self: channel<T,U...,E...>, to: T, U...) -> declare.answer<T,E...>,

    read get_transport: (self: channel<T,U...,E...>) -> declare.enumitem<any>?,
    read get_current_interrogator: (self: channel<T,U...,E...>) -> declare.user?,
    read get_send_response: (self: channel<T,U..., E...>) -> declare.event<T,E...>,
    read get_sync_response: (self: channel<T,U...,E...>, to: T) -> ((U...) -> E...)?,
    read get_async_response: (self: channel<T,U...,E...>, to: T) -> ((U...) -> E...)?,
    read get_peer: (self: channel<T,U...,E...>) -> {declare.user},

    read set_transport: (self: channel<T,U...,E...>, to: declare.enumitem<any>?) -> (),
    read set_sync_response: (self: channel<T,U...,E...>, to: T, f: ((U...) -> E...)? ) -> (),
    read set_async_response: (self: channel<T,U...,E...>, to: T, f: ((U...) -> E...)?) -> (),
    read set_peer: (self: channel<T,U...,E...>, that: declare.user, to: boolean?) -> (),

    read is_peer: (self: channel<T,U...,E...>, that: declare.user) -> boolean,
    read is_transport: (self: channel<T,U..., E...>, of: declare.enumitem<any>) -> boolean
} & declare.asyncable & declare.switchable, declare.observer<>>

const class_par = Observer :: declare.observer<declare.enumitem_network_replication>
const class : channel = Observer:new {

}

return class