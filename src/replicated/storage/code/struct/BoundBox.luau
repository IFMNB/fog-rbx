--!native
--!strict
--!optimize 2

const Quaternion = require("../../dependency/Quaternion")
const BoundBoxDirection = require(".././enums/BoundBoxDirection")
const BoundVariant = require(".././enums/BoundVariant")
const object = require(".././object")
const Record = require("../Record")
const namefield = require("../static/namefield")
const project = require("../static/project")
const Coordinate = require("./Coordinate")

const private = {}
const struct = { __index = Record }
setmetatable(struct, struct)

export type struct = object.class<typeof(struct)>

--[=[
	`BoundBox` - конкретный тип `Record`, являющийся геометрическим объемом в пространстве,
	что позволяет его использовать как дискретное описание какой-либо области или объекта
]=]
struct.type = namefield.boundbox

--[=[ 
	Вариант режима работы `BoundBox`, то бишь его `BoundVariant` `enum`

	Переключение из одного варианта работы в другой не приведет к потери информации,
	однако это не рекомендуется в силу появления лишних данных. Если вы собираетесь
	использовать этот же объект в другом виде, рассмотрите `struct:invariant()`
]=]
struct.variant = BoundVariant.OBB

--[=[ 
	Ось `Vector3.yAxis`, направление `BoundBoxDirection.Top`

	Используется для режима `BoundVariant.OBB`
]=]
struct.top = Vector3.yAxis

--[=[ 
	Ось `-Vector3.yAxis`, направление `BoundBoxDirection.Bottom`

	Используется для режима `BoundVariant.OBB`
]=]
struct.bottom = -Vector3.yAxis

--[=[ 
	Ось `Vector3.xAxis`, направление `BoundBoxDirection.Right`

	Используется для режима `BoundVariant.OBB`
]=]
struct.left = Vector3.xAxis

--[=[ 
	Ось `-Vector3.xAxis`, направление `BoundBoxDirection.Left`

	Используется для режима `BoundVariant.OBB`
]=]
struct.right = -Vector3.xAxis

--[=[ 
	Центр `BoundBox`, то есть его позиция, направление `BoundBoxDirection.Center`
]=]
struct.center = Vector3.zero

--[=[ 
	Ось `-Vector3.zAxis`, направление `BoundBoxDirection.Front`

	Используется для режима `BoundVariant.OBB`
]=]
struct.front = -Vector3.zAxis

--[=[ 
	Ось `Vector3.zAxis`, направление `BoundBoxDirection.Back`

	Используется для режима `BoundVariant.OBB`
]=]
struct.back = Vector3.zAxis

--[=[ 
	Полуразмер оригинального `.Size`, используемый для проведения вычислений `BoundBox`
]=]
struct.half = Vector3.zero

--[=[ 
	Позиция, которая по сути описывает левый нижний задний угол `BoundBox`

	Используется для режима `BoundVariant.AABB`
]=]
struct.min = Vector3.zero

--[=[ 
	Позиция, которая по сути описывает правый верхний передний угол `BoundBox`

	Используется для режима `BoundVariant.AABB`
]=]
struct.max = Vector3.zero

--[=[
	Возвращает новый объект `BoundBox`, являющийся геометрическим объемом в пространстве
]=]
function struct.new(
	top: Vector3 | struct | nil,
	bottom: Vector3?,
	left: Vector3?,
	right: Vector3?,
	center: Vector3?,
	front: Vector3?,
	back: Vector3?,
	min: Vector3?,
	max: Vector3?,
	half: Vector3?,
	variant: number?
)
	const this = struct.arch_new(struct, true)

	if object.is(top, struct.type) then
		const that = top :: struct
		return that:clone()
	end

	this.top = top
	this.bottom = bottom
	this.left = left
	this.right = right
	this.center = center
	this.front = front
	this.back = back
	this.min = min
	this.max = max
	this.half = half
	this.variant = variant

	return this
end

private.unknown_boundvariant = function(...: unknown): struct
	project.console_output("unexpected BoundVariant")
	return struct.new()
end

--[=[
	Конвертирует этот `BoundBox` в `Region3`, насильно представляя его как AABB
]=]
function struct:get_region3(): Region3
	const this = self :: struct
	const new = this:invariant(BoundVariant.AABB)
	return Region3.new(new.min, new.max)
end

--[=[
	Конвертирует этот `BoundBox` в `Region3int16`, насильно представляя его как AABB
]=]
function struct:get_region3int16(): Region3int16
	const this = self :: struct
	const new = this:invariant(BoundVariant.AABB)
	return Region3int16.new(
		Vector3int16.new(new.min.X, new.min.Y, new.min.Z),
		Vector3int16.new(new.max.X, new.max.Y, new.max.Z)
	)
end

--[=[
    Все переданные `BasePart` будут преобразованы в `BoundBox` с
    указанным `BoundVariant` или со стандартным дефолтом
]=]
function struct.bound_with(variant: number?, ...: BasePart): { struct }
	const result: { struct } = {}

	for _, part in { ... } do
		table.insert(result, struct.bound(part, variant))
	end

	return result
end

--[=[
	Изменяет размер этого `BoundBox` умножением через `struct:recalculate()`
]=]
function struct:multiple(new_size: number): struct
	const this = self :: struct
	const new = this:clone()
	new.half *= new_size
	new:recalculate()
	return new
end

--[=[
	Изменяет размер этого `BoundBox` делением через `struct:recalculate()`
]=]
function struct:divide(new_size: number): struct
	const this = self :: struct
	const new = this:clone()
	new.half /= new_size
	new:recalculate()
	return new
end

--[=[
	Возвращает инвертированный `BoundBox` с тем же центром что и до этого
]=]
function struct:invert()
	const this = self :: struct
	const new = this:clone()
	new.half = -new.half
	new:recalculate()
	return new
end

--[=[
	Конвертирует информацию из `Region3`, который по сути является AABB, в `BoundBox`
]=]
function struct.from_region3(that: Region3)
	const new = struct.new()
	new.center = that.CFrame.Position
	new.half = that.Size / 2
	new.variant = BoundVariant.AABB
	new:recalculate()
	return new
end

--[=[
	Конвертирует информацию из `Region3int16`, который по сути является AABB, в `BoundBox`
]=]
function struct.from_region3int16(that: Region3int16)
	return struct.from_aabb(
		Vector3.new(that.Min.X, that.Min.Y, that.Min.Z),
		Vector3.new(that.Max.X, that.Max.Y, that.Max.Z)
	)
end

--[=[
	Строит `BoundBox` из переданных `min` и `max` аргументов,
	вычисляя их положение и размер на лету из этих же аргументов
]=]
function struct.from_aabb(min: Vector3, max: Vector3)
	const new = struct.new()
	new.variant = BoundVariant.AABB
	new.max = max
	new.min = min
	new.half = (max - min) / 2
	new.center = (min + max) / 2
	return new
end

--[=[
	Перерасчитывает парсером этот `BoundBox` на основе его текущих данных
]=]
function struct:recalculate(): struct
	const this = self :: struct
	private.bound_variant_parser[this.variant](this, this:get_origin_directions():multiple(this.half))
	return this
end

--[=[
	Приводит этот `BoundBox` к промежуточному состоянию с переданными BB
]=]
function struct:middle(...: struct)
	const this = self :: struct
	const parser: (struct, ...struct) -> struct = private.middle_variant_parser[this.variant or BoundVariant.Unknown]
		or private.middle_variant_parser[BoundVariant.Unknown]

	return parser(this, ...)
end

private.middle_variant_parser = table.freeze({
	[BoundVariant.AABB] = function(this: struct, ...: struct): struct
		const boxes = { ... }
		const count = #boxes + 1
		local sum_min = this.min
		local sum_max = this.max
		local sum_half = this.half
		local sum_center = this.center

		for _, bb in boxes do
			sum_min += bb.min
			sum_max += bb.max
			sum_half += bb.half
			sum_center += bb.center
		end

		const new = struct.new()
		new.variant = BoundVariant.AABB
		new.min = sum_min / count
		new.max = sum_max / count
		new.half = sum_half / count
		new.center = sum_center / count

		return new
	end,
	[BoundVariant.OBB] = function(this: struct, ...: struct): struct
		const boxes = { ... }
		const count = #boxes + 1
		const this_quaternion = Quaternion.cframe(this:get_cframe())
		local sum_half = this.half
		local sum_center = this.center
		local sum_quaternion_x = this_quaternion.X
		local sum_quaternion_y = this_quaternion.Y
		local sum_quaternion_z = this_quaternion.Z
		local sum_quaternion_w = this_quaternion.W

		for _, bb in boxes do
			sum_half += bb.half
			sum_center += bb.center

			const quaternion_bb = Quaternion.cframe(bb:get_cframe())

			if this_quaternion:Dot(quaternion_bb) < 0 then
				sum_quaternion_x -= quaternion_bb.X
				sum_quaternion_y -= quaternion_bb.Y
				sum_quaternion_z -= quaternion_bb.Z
				sum_quaternion_w -= quaternion_bb.W
			else
				sum_quaternion_x += quaternion_bb.X
				sum_quaternion_y += quaternion_bb.Y
				sum_quaternion_z += quaternion_bb.Z
				sum_quaternion_w += quaternion_bb.W
			end
		end

		sum_half /= count
		sum_center /= count
		sum_quaternion_x /= count
		sum_quaternion_y /= count
		sum_quaternion_z /= count
		sum_quaternion_w /= count

		const new = struct.new()
		new.variant = BoundVariant.OBB
		new.half = sum_half
		new.center = sum_center

		const middle_quaternion = Quaternion.new(sum_quaternion_x, sum_quaternion_y, sum_quaternion_z, sum_quaternion_w)
			:Normalize()
		const source = middle_quaternion:ToCFrame(new.center)

		new.right = new.center + source.RightVector * new.half.X
		new.left = new.center - source.RightVector * new.half.X
		new.top = new.center + source.UpVector * new.half.Y
		new.bottom = new.center - source.UpVector * new.half.Y
		new.front = new.center + source.LookVector * new.half.Z
		new.back = new.center - source.LookVector * new.half.Z

		return new
	end,
	[BoundVariant.Unknown] = private.unknown_boundvariant,
}) :: { (struct, ...struct) -> struct }

--[=[
	Преобразует переданные модели в `BoundBox` с указанными `BoundVariant`,
	при этом будут преобразованы абсолютно все `BasePart` внутри переданных
	экземпляров `Model`
]=]
function struct.from_model(variant: number?, ...: Model)
	const result: { struct } = {}
	const raw: { { struct } } = {}
	for _, mdl in { ... } do
		const parts: { BasePart } = {}

		for _, instance in mdl:GetDescendants() do
			if instance:IsA "BasePart" then
				table.insert(parts, instance :: BasePart)
			end
		end

		const package = struct.bound_with(variant, unpack(parts))
		table.insert(raw, package)
	end

	for _, package in raw do
		for _, that in package do
			table.insert(result, that)
		end
	end

	return result
end

--[=[
    Старается покрыть все переданные BB, используя в качестве якорной
    точки этот `BoundBox` объект

    Если какая-либо структура не совпадает с якорным `BoundVariant`, то
    это не должно вызывать проблем
]=]
function struct:cover(...: struct): struct
	const this = self :: struct
	local covered = this

	for _, BB in { ... } do
		const parser: (struct, struct) -> struct = this.variant == BB.variant
				and private.cover_variant_parser[this.variant or BoundVariant.Unknown]
			or private.cover_variant_parser[BoundVariant.Unknown]

		covered = parser(covered, BB)
	end

	return covered
end

private.cover_variant_parser = table.freeze({
	[BoundVariant.AABB] = function(this: struct, of: struct): struct
		const new = struct.new()

		new.min = this.min:Min(of.min)
		new.max = this.max:Max(of.max)
		new.variant = BoundVariant.AABB
		new.half = (new.min - new.max) / 2
		new.center = (new.min + new.max) / 2

		return new
	end,
	[BoundVariant.OBB] = function(this: struct, of: struct): struct
		const new = struct.new()
		const corners_origin = this:corners()
		const corners_right = of:corners()
		const points: { Vector3 } = {}

		for _, point_origin in corners_origin do
			table.insert(points, point_origin)
		end
		for _, point_right in corners_right do
			table.insert(points, point_right)
		end

		const origin = this:get_origin_directions()
		local min_x = math.huge
		local max_x = -math.huge
		local min_y = math.huge
		local max_y = -math.huge
		local min_z = math.huge
		local max_z = -math.huge

		for _, point in points do
			const diff = point - this.center
			const x, y, z = diff:Dot(origin.right), diff:Dot(origin.up), diff:Dot(origin.front)

			min_x = math.min(min_x, x)
			min_y = math.min(min_y, y)
			min_z = math.min(min_z, z)
			max_x = math.max(max_x, x)
			max_y = math.max(max_y, y)
			max_z = math.max(max_z, z)
		end

		new.half = Vector3.new((max_x - min_x) / 2, (max_y - min_y) / 2, (max_z - min_z) / 2)
		new.center = this.center
			+ origin.right * ((min_x + max_x) / 2)
			+ origin.up * ((min_y + max_y) / 2)
			+ origin.front * ((min_z + max_z) / 2)
		new.variant = BoundVariant.OBB

		new.right = new.center + origin.right * new.half.X
		new.left = new.center - origin.right * new.half.X
		new.top = new.center + origin.up * new.half.Y
		new.bottom = new.center - origin.up * new.half.Y
		new.front = new.center + origin.front * new.half.Z
		new.back = new.center - origin.front * new.half.Z

		return new
	end,
	[BoundVariant.Unknown] = function(this: struct, of: struct): struct
		project.console_output("unexpected BoundVariant")
		return struct.new()
	end,
}) :: { (struct, struct) -> struct }

--[=[
	Возвращает новый `BoundBox` объект, прошедший
    преобразование информации из одного варианта `BoundBox` в другой.
    Может преобразовать таргетированно, вернув либо клон либо новый объект

    При преобразовании из OBB в AABB ***информация об ориентации теряется***,
    поэтому обратное преобразование не позволяет восстановить исходную OBB
]=]
function struct:invariant(to_variant: number?): struct
	const this = self :: struct

	if to_variant then
		if this.variant == to_variant then
			return this:clone()
		end

		if to_variant == BoundVariant.AABB then
			const new = struct.new()

			new.half = this.half
			new.center = this.center
			new.variant = BoundVariant.AABB

			private.bound_variant_parser[BoundVariant.AABB](
				new,
				Coordinate.new(
					(this.right - this.center).Unit,
					(this.top - this.center).Unit,
					(this.back - this.center).Unit
				)
			)
			return new
		elseif to_variant == BoundVariant.OBB then
			const center: Vector3 = (this.min + this.max) / 2
			const half: Vector3 = (this.max - this.min) / 2
			const correct = Coordinate.one:multiple(half)

			return struct.new(
				center + correct.up,
				center - correct.up,
				center - correct.right,
				center + correct.right,
				center,
				center + -correct.front,
				center - -correct.front,
				nil,
				nil,
				half,
				BoundVariant.OBB
			)
		else
			project.console_output("unexpected BoundVariant")
			return this:clone()
		end
	else
		if this.variant == BoundVariant.AABB then
			return this:invariant(BoundVariant.OBB)
		elseif this.variant == BoundVariant.OBB then
			return this:invariant(BoundVariant.AABB)
		else
			return this:invariant(BoundVariant.Unknown)
		end
	end
end

--[=[
    Возвращает все вершины этого `BoundBox` в виде позиций
	Первые четыре вершины принадлежат Axis.X+ (right) стороне,
	а остальные четыре Axis.X- (left) стороне

	Вершины возвращаются для каждой стороны вершин в таком виде:
		Верхняя передняя,
		Верхняя задняя,
		Нижняя передная,
		Нижняя задняя
]=]
function struct:corners(): { Vector3 }
	const this = self :: struct

	if this.variant == BoundVariant.OBB then
		const right: Vector3 = this.right - this.center
		const up: Vector3 = this.top - this.center
		const front: Vector3 = this.front - this.center

		return {
			this.center + right + up + front,
			this.center + right + up - front,
			this.center + right - up + front,
			this.center + right - up - front,
			this.center - right + up + front,
			this.center - right + up - front,
			this.center - right - up + front,
			this.center - right - up - front,
		}
	elseif this.variant == BoundVariant.AABB then
		const right: Vector3 = Vector3.xAxis * this.half.X
		const up: Vector3 = Vector3.yAxis * this.half.Y
		const front: Vector3 = Vector3.zAxis * this.half.Z

		return {
			this.center + right + up + front,
			this.center + right + up - front,
			this.center + right - up + front,
			this.center + right - up - front,
			this.center - right + up + front,
			this.center - right + up - front,
			this.center - right - up + front,
			this.center - right - up - front,
		}
	else
		return {
			Vector3.zero,
			Vector3.zero,
			Vector3.zero,
			Vector3.zero,
			Vector3.zero,
			Vector3.zero,
			Vector3.zero,
			Vector3.zero,
		}
	end
end

--[=[
    При помощи алгоритма SAT находит MTV (Minimum Translation Vector)
    для всех переданных `BoundBox`

	Результатом алгоритма является один минимальный MTV, таблица которого
	состоит из структуры:

	```lua
		const MTV = {
			[1] = 1, -- min
			[2] = 1, -- Axis.X
			[3] = 1, -- Axis.Y
			[4] = 1 -- Axis.Z
		}
	```
]=]
function struct:translated(...: struct): { { number } }
	const this = self :: struct
	const result: { { number } } = {}

	for _, BB in { ... } do
		const sat_result = private.algorithm_of_separating_axis_theorem(this, BB, true)
		table.insert(result, sat_result[4])
	end

	return result
end

--[=[
	Проверяет, не принадлежит ли этот `BoundBox` другому `BoundBox`

	`BoundBox` с другим `BoundVariant` от этого будут отброшены как `false`
]=]
function struct:inside(...: struct): { boolean }
	const this = self :: struct
	const result: { boolean } = {}

	for _, BB in { ... } do
		const parser: (struct, struct) -> boolean = this.variant == BB.variant
				and private.inside_variant_parser[this.variant or BoundVariant.Unknown]
			or private.inside_variant_parser[BoundVariant.Unknown]
		table.insert(result, parser(this, BB))
	end

	return result
end

private.inside_variant_parser = table.freeze({
	[BoundVariant.AABB] = function(this: struct, of: struct): boolean
		return this.min.X <= of.min.X
			and this.max.X >= of.max.X
			and this.min.Y <= of.min.Y
			and this.max.Y >= of.max.Y
			and this.min.Z <= of.min.Z
			and this.max.Z >= of.max.Z
	end,
	[BoundVariant.OBB] = function(this: struct, of: struct): boolean
		for _, result in of:belong(unpack(this:corners())) :: { boolean } do
			if not result then
				return false
			end
		end

		return true
	end,
	[BoundVariant.Unknown] = function(this: struct, of: struct): boolean
		project.console_output("unexpected BoundVariant, abort")
		return false
	end,
}) :: { (struct, struct) -> boolean }

--[=[
	Проверяет, не принадлежит ли точка объему `BoundBox`
]=]
function struct:belong(...: Vector3): { boolean }
	const this = self :: struct
	const result: { boolean } = {}
	const axises = this:get_origin_directions()

	for _, point in { ... } do
		const diff = point - this.center
		table.insert(
			result,
			math.abs(diff:Dot(axises.right)) <= this.half.X
				and math.abs(diff:Dot(axises.up)) <= this.half.Y
				and math.abs(diff:Dot(axises.front)) <= this.half.Z
		)
	end

	return result
end

--[=[
    Все переданные `BoundBox` будут преобразованы через struct:invariant(...)
	в эквивалентный этому `BoundBox` `BoundVariant` вид
]=]
function struct:convert(...: struct): { struct }
	const this = self :: struct
	const result: { struct } = {}

	for _, BB in { ... } do
		table.insert(result, BB:invariant(this.variant))
	end

	return result
end

--[=[
    Возвращает результат пересечения одной коробки в другой
    При этом требуется, чтобы `BoundVariant` для каждых `BoundBox` совпадали
]=]
function struct:intersection(...: struct): { boolean }
	const this = self :: struct
	const result = {}

	for _, BB in { ... } do
		const parser: (struct, struct) -> boolean = this.variant == BB.variant
				and private.intersection_variant[this.variant or BoundVariant.Unknown]
			or private.intersection_variant[BoundVariant.Unknown]
		table.insert(result, parser(this, BB))
	end

	return result
end

private.intersection_variant = table.freeze({
	[BoundVariant.AABB] = function(this: struct, of: struct): boolean
		return this.min.X <= of.max.X
			and this.max.X >= of.min.X
			and this.min.Y <= of.max.Y
			and this.max.Y >= of.min.Y
			and this.min.Z <= of.max.Z
			and this.max.Z >= of.min.Z
	end,

	[BoundVariant.OBB] = function(this: struct, of: struct): boolean
		const computed = private.algorithm_of_separating_axis_theorem(this, of)

		for i, distance in computed[1] do
			if distance > computed[2][i] + computed[3][i] then
				return false
			end
		end

		return true
	end,

	[BoundVariant.Unknown] = private.unknown_boundvariant,
} :: { (struct, struct) -> boolean })

function private.algorithm_of_separating_axis_theorem(this: struct, of: struct, mtv: boolean?): { { number } }
	const axis_list_left: { Vector3 } = this:get_origin_directions():unpack()
	const axis_list_right: { Vector3 } = of:get_origin_directions():unpack()
	const axises: { Vector3 } = {}

	for _, axis_left in axis_list_left do
		table.insert(axises, axis_left.Unit)
	end
	for _, axis_right in axis_list_right do
		table.insert(axises, axis_right.Unit)
	end

	for _, axis_left in axis_list_left do
		for _, axis_right in axis_list_right do
			const new = axis_left:Cross(axis_right)

			if new:Dot(new) > 1e-8 then
				table.insert(axises, new.Unit)
			end
		end
	end

	const diff: Vector3 = this.center - of.center
	const compute_distance: { number } = {}
	const compute_left: { number } = {}
	const compute_right: { number } = {}

	for _, axis in axises do
		table.insert(compute_distance, math.abs(diff:Dot(axis)))
		table.insert(
			compute_left,
			this.half.X * math.abs(axis:Dot(axis_list_left[1]))
				+ this.half.Y * math.abs(axis:Dot(axis_list_left[2]))
				+ this.half.Z * math.abs(axis:Dot(axis_list_left[3]))
		)
		table.insert(
			compute_right,
			of.half.X * math.abs(axis:Dot(axis_list_right[1]))
				+ of.half.Y * math.abs(axis:Dot(axis_list_right[2]))
				+ of.half.Z * math.abs(axis:Dot(axis_list_right[3]))
		)
	end

	if mtv then
		const compute_mtv: { number } = {}
		local min = math.huge
		local mtv_axis = Vector3.zero

		for i, axis in axises do
			const distance = compute_distance[i]
			const left = compute_left[i]
			const right = compute_right[i]
			const overlap = left + right - distance

			if overlap < 0 then
				continue
			end

			if overlap < min then
				min = overlap
				mtv_axis = axis
			end
		end

		compute_mtv[1] = min
		compute_mtv[2] = mtv_axis.X
		compute_mtv[3] = mtv_axis.Y
		compute_mtv[4] = mtv_axis.Z

		return { compute_distance, compute_left, compute_right, compute_mtv }
	end

	return { compute_distance, compute_left, compute_right }
end

--[=[
    В зависимости от this.variant режима вернет таблицу элементов,
    с которыми работает этот режим
]=]
function struct:unpack(): { Vector3 }
	const this = self :: struct

	return this.variant == BoundVariant.OBB
			and { this.top, this.bottom, this.left, this.right, this.center, this.front, this.back }
		or this.variant == BoundVariant.AABB and { this.min, this.max }
		or { project.console_output("cannot properly unpack unexpected BoundVariant") }
end

--[=[
    Возвращает новый `BoundBox`, который охватывает собой область всего
	переданного в функцию объекта
]=]
function struct.bound(that: BasePart, variant: number?)
	const new = struct.new()

	new.half = that.Size / 2
	new.variant = variant or struct.variant

	const correct = Coordinate.new(
		that.CFrame.RightVector * new.half.X,
		that.CFrame.UpVector * new.half.Y,
		that.CFrame.LookVector * new.half.Z
	)

	new.center = that.CFrame.Position
	const parser = private.bound_variant_parser[new.variant] or private.bound_variant_parser[BoundVariant.Unknown]
	parser(new, correct)

	return new
end

private.bound_variant_parser = table.freeze({
	[BoundVariant.OBB] = function(this: struct, correct: Coordinate.struct)
		this.top = this.center + correct.up
		this.bottom = this.center - correct.up
		this.left = this.center - correct.right
		this.right = this.center + correct.right
		this.front = this.center + correct.front
		this.back = this.center - correct.front
	end,
	[BoundVariant.AABB] = function(this: struct, correct: Coordinate.struct)
		const relative = correct:abs()

		const world = Vector3.new(
			relative.right.X * this.half.X + relative.up.X * this.half.Y + relative.front.X * this.half.Z,
			relative.right.Y * this.half.X + relative.up.Y * this.half.Y + relative.front.Y * this.half.Z,
			relative.right.Z * this.half.X + relative.up.Z * this.half.Y + relative.front.Z * this.half.Z
		)

		this.min = this.center - world
		this.max = this.center + world
	end,
	[BoundVariant.Unknown] = private.unknown_boundvariant,
})

--[=[
    Переключает `this.half` в его Abs() версию
    Возвращает новый `BoundBox` объект
]=]
function struct:abs()
	const this = self :: struct

	if this.variant == BoundVariant.AABB then
		return struct.new(
			nil,
			nil,
			nil,
			nil,
			this.center,
			nil,
			nil,
			this.min,
			this.max,
			this.half:Abs(),
			this.variant :: number
		)
	elseif this.variant == BoundVariant.OBB then
		return struct.new(
			this.top,
			this.bottom,
			this.left,
			this.right,
			this.center,
			this.front,
			this.back,
			nil,
			nil,
			this.half:Abs(),
			this.variant :: number
		)
	else
		return private.unknown_boundvariant(this) :: any
	end
end

--[=[
    Переводит все внутренности в `.Unit` в зависимости от текущего
    режима `BoundVariant` на преобразуемом объекте, исключая
    только `this.center` и `this.half`
    Возвращает новый `BoundBox` объект
]=]
function struct:unit()
	const this = self :: struct

	if this.variant == BoundVariant.AABB then
		return struct.new(
			nil,
			nil,
			nil,
			nil,
			this.center,
			nil,
			nil,
			this.min.Unit,
			this.max.Unit,
			this.half,
			this.variant :: number
		)
	elseif this.variant == BoundVariant.OBB then
		return struct.new(
			this.top.Unit,
			this.bottom.Unit,
			this.left.Unit,
			this.right.Unit,
			this.center,
			this.front.Unit,
			this.back.Unit,
			nil,
			nil,
			this.half,
			this.variant :: number
		)
	else
		return private.unknown_boundvariant(this) :: any
	end
end

--[[
    if (this.variant == BoundVariant.AABB) then
        return struct.new(
            nil,
            nil,
            nil,
            nil,
            this.center,
            nil,
            nil,
            this.min, this.max, this.half, this.variant)
    elseif (this.variant == BoundVariant.OBB) then
		return struct.new(this.top, this.bottom, this.left, this.right, this.center, this.front, this.back, nil, nil, this.half, this.variant)
    else
        project.console_output "BoundVariant @Unknown"
        return this:clone()
    end
]]

--[=[

    Возвращает оригинальные единичные направления `that.CFrame` из `correct`,
    который был получен результатом умножения направления на половину размера
    в том же направлении

    ```lua
    local correct = Coordinate.new (
        that.CFrame.направление * this.half.направление,
        ...
    )
    ```

    Для AABB всегда возвращаются мировые направленные XYZ, то бишь они являются:
    `Vector3.xAxis, Vector3.yAxis, Vector3.zAxis` соответственно
]=]
function struct:get_origin_directions(): Coordinate.struct
	const this = self :: struct

	if this.variant == BoundVariant.OBB then
		return Coordinate.new(
			(this.right - this.center) / this.half.X,
			(this.top - this.center) / this.half.Y,
			-(this.front - this.center) / this.half.Z
		)
	elseif this.variant == BoundVariant.AABB then
		return Coordinate.new(Vector3.xAxis, Vector3.yAxis, Vector3.zAxis)
	else
		project.console_output("")
		return Coordinate.new(Vector3.zero, Vector3.zero, Vector3.zero)
	end
end

--[=[
    Возвращает оси, то бишь указанное направление (всегда первый индекс),
    либо вообще все полуоси для всех направлений в следующем порядке:
    `(right, up, front)`, он же `([1]X,[2]Y,[3]Z)`
]=]
function struct:get_axis(of: Enum.Axis?): { Vector3 }
	const this = self :: struct
	if of then
		if this.variant == BoundVariant.OBB then
			return {
				of == Enum.Axis.X and this.right - this.center
					or of == Enum.Axis.Y and this.top - this.center
					or of == Enum.Axis.Z and this.front - this.center,
			}
		elseif this.variant == BoundVariant.AABB then
			return { Vector3.xAxis, Vector3.yAxis, Vector3.zAxis }
		else
			project.console_output("unexpected BoundVariant")
			return {
				Vector3.zero,
			}
		end
	else
		return {
			struct.get_axis(this, Enum.Axis.X)[1],
			struct.get_axis(this, Enum.Axis.Y)[1],
			struct.get_axis(this, Enum.Axis.Z)[1],
		}
	end
end

--[=[
	Вернет оригинальный размер откуда был сгенерирован `BoundBox`,
	при этом этот размер всегда будет положительным

	Внутри `BoundBox` полуразмер может быть как положителен так и
	отрицателен, поэтому если понадобится восстановить оригинальный размер
	объекта в Roblox системе координат выполняется `Vector3.Abs(this.half*2)`
]=]
function struct:get_origin_size(): Vector3
	const this = self :: struct
	return (this.half * 2):Abs()
end

--[=[
	Возвращает середину фейса указанной стороны или центр `BoundBox`,
	затем оно будет преобразовано как ортонормированное направление
]=]
function struct:get_direction(boundbox_direction: number?): Vector3
	const this = self :: struct
	const bound_by_direction = this:get_bound_by_direction(boundbox_direction)
	return (bound_by_direction - this.center).Unit
end

--[=[
	Возвращает середину фейса указанной стороны или центр `BoundBox`
]=]
function struct:get_bound_by_direction(boundbox_direction: number?): Vector3
	const this = self :: struct
	boundbox_direction = boundbox_direction or BoundBoxDirection.Front

	return boundbox_direction == BoundBoxDirection.Top and this.top
		or boundbox_direction == BoundBoxDirection.Bottom and this.bottom
		or boundbox_direction == BoundBoxDirection.Front and this.front
		or boundbox_direction == BoundBoxDirection.Back and this.back
		or boundbox_direction == BoundBoxDirection.Left and this.left
		or boundbox_direction == BoundBoxDirection.Right and this.right
		or boundbox_direction == BoundBoxDirection.Center and this.center
		or this.center
end

--[=[
	Возвращает пересчитанный `this.half` с учетом `BoundVariant`
]=]
function struct:get_half_computed(): Vector3
	const this = self :: struct

	return this.variant == BoundVariant.OBB
			and Vector3.new(
				(this.left - this.center).Magnitude,
				(this.top - this.center).Magnitude,
				(this.back - this.center).Magnitude
			)
		or this.variant == BoundVariant.AABB and (this.max - this.min) / 2
		or Vector3.zero
end

--[=[
	Возвращает `CFrame` с учетом текущего `BoundVariant` режима
]=]
function struct:get_cframe(): CFrame
	const this = self :: struct

	if this.variant == BoundVariant.OBB then
		return CFrame.fromMatrix(
			this.center,
			(this.right - this.center).Unit,
			(this.top - this.center).Unit,
			-(this.front - this.center).Unit
		)
	elseif this.variant == BoundVariant.AABB then
		return CFrame.fromMatrix(this.center, Vector3.xAxis, Vector3.yAxis, Vector3.zAxis)
	else
		return CFrame.identity
	end
end

--[=[
	Пустой `BoundBox` без каких-либо данных
]=]
struct.zero = struct.new():immutable()
--[=[
	`BoundBox` с единичными размерами
]=]
struct.one = struct.from_aabb(Vector3.zero, Vector3.one):immutable()

return table.freeze(struct)
