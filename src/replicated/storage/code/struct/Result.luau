const object = require("../object")
const namefield = require("../static/namefield")

const class = {__index = object}
setmetatable(class, class)

export type class<T=any> = object.generic<{result: T}, typeof(class)>

class.type = namefield.content
class.result = nil :: unknown
class.state = false

function class.new (state: boolean?, result: any?)
    const this = object.new(class, true)
    this.state = state
    this.result = result
    return this :: class
end

function class.call_of <T,U> (func: (...T) -> U, ...: T)
    const state, out = pcall(func, ...)
    return class.new(state, out)
end

return table.freeze(class)