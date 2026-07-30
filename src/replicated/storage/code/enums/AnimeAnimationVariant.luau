--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "AnimeAnimationVariant",

	Walk = EnumItem:new({
		name = "Walk",
	}),

	Run = EnumItem:new({
		name = "Run",
	}),

	Idle = EnumItem:new({
		name = "Idle",
	}),

	Jump = EnumItem:new({
		name = "Jump",
	}),

	Fall = EnumItem:new({
		name = "Fall",
	}),

	Fly = EnumItem:new({
		name = "Fly",
	}),

	Crouch = EnumItem:new({
		name = "Crouch",
	}),

	Prone = EnumItem:new({
		name = "Prone",
	}),
})

return class
