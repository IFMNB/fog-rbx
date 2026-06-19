const enum = require('../enum')

const enums = {};

enums.operational = enum.new(enums, "operational")
enums.disabled = enum.new(enums, "disabled")

return table.freeze(enums);