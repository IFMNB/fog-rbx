--!strict
const Struct = require("@game/ReplicatedStorage/class/core/Struct")
const AABBVolume = require("@game/ReplicatedStorage/class/struct/geometry/AABBVolume")
const CubeVolume = require("@game/ReplicatedStorage/class/struct/geometry/CubeVolume")
const SAT = require("@game/ReplicatedStorage/dependency/SAT")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : obbvolume = CubeVolume:new {
    type = "obbvolume",
    half = vector.one / 2,

    from = function (self: obbvolume, ...: geometry_supported) : obbvolume
        local new = self
        
        for _, v in {...} do
            new = private.generate_from_convert(new, v) or new
        end

        return new
    end,

    middle = function (self: obbvolume, ...: geometry_supported) : obbvolume

    end,

    cover = function (self: obbvolume, ...: geometry_supported) : obbvolume
    
    end,

    is_inside = function (self: obbvolume, ...: geometry_supported) : boolean
    
    end,

    is_interacts = function (self: obbvolume, ...: geometry_supported) : boolean
    
    end,

    is_intersection = function (self: obbvolume, ...: geometry_supported) : boolean
    
    end,
}

do

    do
        private.convert = function (v: geometry_supported): obbvolume?
			const gen = private.find_right_in(private.convert_list, v)

			if gen then
				return gen(v)
			else
				return nil
			end
        end

        --[==[
            Функции для конвертации поддерживаемых типов объектов в `obbvolume`
        ]==]
        private.convert_list = table.freeze {
			[class.type] = function(prev: obbvolume, new: obbvolume): obbvolume end,

			[AABBVolume.type] = function(prev: obbvolume, new: aabbvolume): obbvolume end,

			[CubeVolume.type] = function(prev: obbvolume, new: cubevolume): obbvolume end,

			["Model"] = function(prev: obbvolume, new: Model): obbvolume end,

			["BasePart"] = function(prev: obbvolume, new: BasePart): obbvolume end,

			["PVInstance"] = function(prev: obbvolume, new: PVInstance): obbvolume end,
        } :: {[string]: (geometry_supported) -> obbvolume}
    end

    do
		private.generate_from_convert = function(self: obbvolume, v: geometry_supported): obbvolume?
            const gen = private.find_right_in(private.from_convert, v)
            
            if gen then
                return gen(self, v)
            else
                return nil
            end
		end

        --[==[
            Функции для конвертации и\или соединения объекта с уже существующим obbvolume
        ]==]
		private.from_convert = table.freeze({
			[class.type] = function(prev: obbvolume, new: obbvolume): obbvolume end,

			[AABBVolume.type] = function(prev: obbvolume, new: aabbvolume): obbvolume end,

			[CubeVolume.type] = function(prev: obbvolume, new: cubevolume): obbvolume end,

			["Model"] = function(prev: obbvolume, new: Model): obbvolume end,

			["BasePart"] = function(prev: obbvolume, new: BasePart): obbvolume end,

			["PVInstance"] = function(prev: obbvolume, new: PVInstance): obbvolume end,
		}) :: { [string]: (obbvolume, geometry_supported | Instance) -> obbvolume }
    end

    private.find_right_in = function (list: {[string]: (...any) -> any}, v: geometry_supported) : ((...any) -> any)?
		local func

		if class:that(v, Struct.type) then
			const var = v :: object
			func = list[var.type]
		elseif typeof(v) == declare.roblox.Instance then
			const var = v :: Instance
			func = list[var.ClassName]
		else
			project.console_out_error("cannot reach unknown object, skipped")
			return nil
		end

		if not project.assert(func, "cannot find right generator", true) then
			return nil
		else
			return func
		end
    end
end

return class