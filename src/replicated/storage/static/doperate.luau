--!strict
const declare = require("@game/ReplicatedStorage/static/declare")

export type tasky<
	current --[=[*based-on-current-realization*]=]
> = declare.construct<{
	read deploy: (self: tasky<current>, path: string) -> (),
	read get_online: (self: tasky<current>) -> { [string]: current },
	read get_offline: (self: tasky<current>) -> { [string]: current },
	read get_existed: (self: tasky<current>, path: string) -> current?,
	read is_exists: (self: tasky<current>, path: string) -> boolean,
} & declare.asyncable, declare.runtimeobject>

export type stack<T = unknown> = declare.construct<{
	max: number,

	read pick: (self: stack<T>) -> T?,
	read put: (self: stack<T>, value: T) -> (),
	read count: (self: stack<T>) -> number,
}, declare.runtimeobject>

export type maybe = declare.construct<{
	read extract: <T>(self: maybe, it: unknown, make: () -> T) -> T,
	read erase: (self: maybe, it: unknown) -> (),
	read exist: (self: maybe, it: unknown) -> boolean,
}, declare.runtimeobject>

export type randentity = declare.construct<{
	input: unknown,
	output: randentity?,

	read get_now: (self: randentity, prebake: boolean?) -> randentity,
	read to_sha256: (self: randentity) -> (),
	read to_blake3: (self: randentity) -> (),
}, declare.runtimeobject>

return declare