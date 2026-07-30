--!strict

const Record = require("../Record")
const object = require("../object")
const namefield = require("../static/namefield")

const class = {}
setmetatable(class, {__index = Record})

export type class<T=any> = Record.extend<setmetatable<{result: T}, {__index: typeof(class)}>>
export type extend <T = {}> = object.class<T, class>

class.type = namefield.content
class.result = nil :: unknown
class.state = false

function class.new<U>(state: boolean?, result: U?)
    const this = Record.new(class, true)
    this.state = state
    this.result = result
    return this
end

function class.call_of <T,U> (func: (...T) -> U, ...: T)
    const state, out = pcall(func, ...)
    return class.new(state, out :: U)
end

return table.freeze(class)