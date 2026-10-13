class_name DialogueOption
extends Resource

@export var text = "Sample Text"
@export var target: int
@export var requiresItem: bool
@export var requiredItem: Item
@export var takeItem: bool ## unsupported

@export var condition: Condition
@export var condMode: int = -1 ##-1 do nothing, 0 need false, 1 need true.
@export var fallbackTarget: int ##if condition failed go to this target instead.
@export var hide: bool = false ##If condition isnt met and the fallback is -2 this will determine whether the option is given to begin with.

@export var costsMoney: bool = false
@export var cost: int = 10

@export var action: Action = null
