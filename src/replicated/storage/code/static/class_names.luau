const names = {
	object = "object" :: "object",
	enum = "enum" :: "enum",
	node = "node" :: "node",
	event = "event" :: "event",
	connection = "connection" :: "connection",
	creature = "creature" :: "creature",
	service = "service" :: "service",
	asset_localructor = "asset_localructor" :: "asset_localructor",
	hitcheck = "hitcheck" :: "hitcheck",
	raycast = "raycast" :: "raycast",
	lifeform = "lifeform" :: "lifeform",
	meta = "meta" :: "meta",
	await = "await" :: "await",
	asset = "asset" :: "asset",
	human = "human" :: "human",
}

export type names_dictionary = typeof(names)
export type class_names = keyof<names_dictionary>

return table.freeze(names)