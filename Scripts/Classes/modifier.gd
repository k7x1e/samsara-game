extends Resource

class_name itemModifier

@export var typename: String = "Standard"

@export_enum("none","=","+","*","/") var operand: int = 0
@export var effects: Dictionary[StringName, Variant]

func getvalue(i: StringName, item: itemClass) -> Variant:
	var applicable = effects[i]
	var affected = item.get_proper(i)
	var product = affected
	match operand:
		1:
			product = applicable
		2:
			product = affected + applicable
		3:
			product = affected * applicable
		4:
			product = affected / applicable
	print(i, product)
	return product
