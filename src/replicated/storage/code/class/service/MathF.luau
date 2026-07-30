const Service = require("../../Service")
const OperationVariant = require("../../enums/OperationVariant")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")

const private = {}
const class = {}
setmetatable(class, { __index = Service })

export type class = object.class<typeof(class)>

class.type = namefield.mathf

do --minmax_region
	function class.minmax<T, U>(left: T, right: U, operation_variant: number?)
		return private.minmax_operation_variant[operation_variant or OperationVariant.Unknown](left, right)
	end

	function class.minmax_add<T, U>(left: T, right: U)
		return class.substract(left, right), class.add(right, left)
	end

	function class.minmax_substract<T, U>(left: T, right: U)
		return class.add(left, right), class.substract(right, left)
	end

	function class.minmax_multiple<T, U>(left: T, right: U)
		return class.multiple(left, right), class.multiple(right, left)
	end

	function class.minmax_divide<T, U>(left: T, right: U)
		return class.divide(left, right), class.divide(right, left)
	end

	private.minmax_operation_variant = table.freeze({
		[OperationVariant.Add] = class.minmax_add,
		[OperationVariant.Substract] = class.minmax_substract,
		[OperationVariant.Multiple] = class.minmax_multiple,
		[OperationVariant.Divide] = class.minmax_divide,
		[OperationVariant.Unknown] = function<T, U>(left: T, right: U)
			project.console_out_error("OperationVariant @Unknown")
			return left, right
		end,
	})
end

do --by_operationvariant_region
	function class.operate(left, right, operation_variant: number?)
		return private.by_operationvariant[operation_variant or OperationVariant.Unknown](left, right)
	end

	function class.add(left, right)
		return left + right
	end

	function class.substract(left, right)
		return left - right
	end

	function class.multiple(left, right)
		return left * right
	end

	function class.divide(left, right)
		return left / right
	end

	private.by_operationvariant = table.freeze({
		[OperationVariant.Add] = class.add,
		[OperationVariant.Substract] = class.substract,
		[OperationVariant.Multiple] = class.multiple,
		[OperationVariant.Divide] = class.divide,
		[OperationVariant.Unknown] = function<T, U>(left: T, right: U)
			project.console_out_error("OperationVariant @Unknown")
			return left, right
		end,
	})
end

do --stepwise
	function class.stepwise_add(left, right)
		return (left.X + right.X) + (left.Y + right.Y) + (left.Z + right.Z)
	end

	function class.stepwise_multiple(left, right)
		return (left.X + right.X) * (left.Y + right.Y) * (left.Z + right.Z)
	end

	function class.stepwise_substract(left, right)
		return (left.X + right.X) - (left.Y + right.Y) - (left.Z + right.Z)
	end

	function class.stepwise_divide(left, right)
		return (left.X + right.X) / (left.Y + right.Y) / (left.Z + right.Z)
	end

	function class.stepwise_reverse_add(left, right)
		return (left.X + right.X) + (left.Y + right.Y) + (left.Z + right.Z)
	end

	function class.stepwise_reverse_multiple(left, right)
		return (left.X * right.X) + (left.Y * right.Y) + (left.Z * right.Z)
	end

	function class.stepwise_reverse_substract(left, right)
		return (left.X - right.X) + (left.Y - right.Y) + (left.Z - right.Z)
	end

	function class.stepwise_reverse_divide(left, right)
		return (left.X / right.X) + (left.Y / right.Y) + (left.Z / right.Z)
	end
end

do --init_region
	const mathf = object.new(class, class.type)

	private.singletone = mathf
	table.freeze(class)
	table.freeze(private)
end

return private.singletone
