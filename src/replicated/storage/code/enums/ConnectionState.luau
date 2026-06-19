const enum = require('../enum')

const enums = {};

enums.connected = enum.new(enums, "connected")
enums.once = enum.new(enums, "once")
enums.disconnected = enum.new(enums, "disconnected")
enums.initiated = enum.new(enums, "initiated")

return table.freeze(enums);