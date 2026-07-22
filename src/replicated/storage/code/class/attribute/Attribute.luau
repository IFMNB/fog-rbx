const Disposable = require("../../Disposable")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Event = require("../event/Event")
const Face = require("../face/Face")
const Storage = require("../storage/Storage")
const Upload = require("../upload/Upload")

const private = {}
const class = {}
setmetatable(class, { __index = Disposable })

export type class = object.class<typeof(class)>

class.type = namefield.attribute

--[=[
    Специальный паттерн названия в самом конце объявления поля объекта или таблицы,
    который отделяет неавтоматизированный элемент, то есть автоматически конвертируемый в 
    `Attribute.class`, от автоматизированного

    Поведение для разных видов конвертируемого поля отличается:

    > Для обычных свойств и полей, которые не хранят объекты или функции, все работает прямо

    > Для функций ожидается, что они являются геттерами
]=]
class.pattern = "_attribute_value" :: "_attribute_value"

--[=[
    Допускается оформление `Attribute.class` для несуществующих экземпляров Roblox,
    с учетом того, что практическое (эффективное) поведение этих объектов не будет
    работать

    Эти объекты наследуют `Disposable` и живут с зависимостью от цикла жизни
    экземпляра, к которому они привязаны. Если такового не будет, то их цикл ничем не
    отличается от обычного `Disposable.class`
]=]
function class.new(of: Instance?, name: string?, default: unknown?)
	const this = Disposable.new(class, true)
	const metadata = private.metadata:fetch(this)
	metadata.name = name and tostring(name) or "@attribute" .. tostring(this.identity)
	metadata.instance = of
	metadata.last_value = default or "@never"

	if not class.is_attributable_value(default) then
		project.console_output("unexpected value type, default value converted into nil type")
		metadata.last_value = "@never"
	end

	if of then
		of.Destroying:Once(function()
			this:queue_free()
		end)

		of:SetAttribute(metadata.name, metadata.last_value)
		const connection = of:GetAttributeChangedSignal(metadata.name):Connect(function(...)
			const new_value = of:GetAttribute(metadata.name)
			if private.events:is_exists(this) then
				private.events:fetch(this, Event.new):emit(new_value, metadata.last_value)
			end
			metadata.last_value = new_value
		end)

		this:watch_free_event(connection)
	end

	return this
end

function class.get_attribute_list(from: { [unknown]: unknown }, to: Instance?): { class }
	const result = {}
	for i, v in from do
		const value_T = typeof(v)

        if class.is_attributable_pattern(i) then
            local value_to_check = v
            if value_T == "function" then
                -- Ожидается, что по соглашению class.pattern
                value_to_check = v(from)
            end

            const is_expected_type = private.attribute_expected_types[value_T] ~= nil
            if is_expected_type then
                table.insert(result, class.new(to, i, value_T))
            else
                project.console_output(
                    string.format(
                        "unexpected valuetype for field '%s' that contains special pattern '%s', skipped",
                        i,
                        class.pattern
                    )
                )
            end
        end
	end

	return result
end

--[=[
    Позволяет узнать, подходящая ли эта строка под автоматический конвертер в
    `Attribute.class`, или нет

    При этом имена атрибутов могут быть любыми строками
]=]
function class.is_attributable_pattern(name: string): boolean
	return type(name) == "string" and (string.sub(name, #class.pattern) == class.pattern) or false
end

--[=[
    Позволяет узнать, может ли это поле автоматически превращаться в `Attribute.class`,
    или ему нужна ручная обработка в том или ином виде

    Для функций позволяет предугадать, может ли эта функция использоваться как представление
	атрибута. При этом проверка на тип все равно будет выполняться. Функции, у которых есть
	`Attribute.class .pattern` в конце наименования будут пропускаться, но только если это
	не геттер
]=]
function class.is_attributable_field(name: string, value: any)
	const T = typeof(value)
	const getter = "get_"

	const second_subname = name:sub(-#class.pattern)

	if second_subname == class.pattern then
		if T == "function" then
			const first_subname = name:sub(1, #getter)

			if first_subname == getter then
				return true
			end
		elseif private.attribute_expected_types[T] == true then
			return true
		end
	end


	return false
end

--[=[
    Позволяет узнать, может ли это значение храниться как атрибут
]=]
function class.is_attributable_value(value: any) : boolean
    return private.attribute_expected_types[typeof(value)] == true
end

--[=[
    Возвращает имя этого `Attribute.class`

    Наименование всех `Attribute.class` является внутренним свойством, поэтому
    его невозможно изменять как поле
]=]
function class:get_attribute_name(): string
	const this = self :: class
	
	

	const metadata = private.metadata:fetch(this)
	return metadata.name
end

--[=[
    Возвращает состояние этого `Attribute.class`, по которому можно понять,
    чревато-ли его использование, или это пустышка без какого-либо поведения
]=]
function class:is_attribute_alive(): boolean
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return metadata.instance ~= nil
end

--[=[
    Устанавливает новое значение для этого `Attribute.class`
]=]
function class:set(to: any)
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	const instance = metadata.instance :: Instance

	if not this:is_attribute_alive() then
		project.console_output("instance already destroyed or never existed, abort")
		return
	end

	if private.attribute_expected_types[typeof(to)] ~= nil then
		instance:SetAttribute(metadata.name, to)
	else
		assert(not project.debug_mode, "attempt to set unexpected value to attribute, abort")
	end
end

--[=[
    Получает текущее значение этого `Attribute.class`
]=]
function class:get_value(): unknown?
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	const instance = metadata.instance :: Instance

	if not this:is_attribute_alive() then
		project.console_output("instance already destroyed or never existed, abort")
		return
	end

	return instance:GetAttribute(metadata.name)
end

--[=[
    Получает предыдущее значение этого `Attribute.class`
]=]
function class:get_previous_value(): unknown?
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	return metadata.last_value
end

--[=[
    Возвращает `Face.class`, который первым аргументом получает текущее новое значение,
    а вторым предыдущее старое значение атрибута
]=]
function class:get_changed_event(): Face.class<unknown?, unknown?>
	const this = self :: class
	return private.events
		:fetch(this, function(...)
			const new = Event.new()
			this:watch_free_event(new)
			return new
		end)
		:get_face()
end

private.events = Upload.new()
private.metadata = Storage.new()
private.attribute_expected_types = table.freeze({
	string = true,
	boolean = true,
	number = true,
	Vector3 = true,
	Vector2 = true,
	CFrame = true,
	Color3 = true,
	UDim = true,
    ["nil"] = true,
	UDim2 = true,
	BrickColor = true,
	NumberSequence = true,
	ColorSequence = true,
	NumberRange = true,
	Font = true,
	Rect = true,
	EnumItem = true,
}) :: { [string]: boolean }

return table.freeze(class)
