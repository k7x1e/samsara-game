class_name DialogueOption
extends Resource

@export var text = "Sample Text"
@export var triggersCommand: bool
@export var command = "whatever it does"
@export var target: int
@export var requiresItem: bool
@export var requiredItem: Item
@export var takeItem: bool ## unsupported

@export var condition: Condition
@export var condMode: int = -1 ##-1 do nothing, 0 need false, 1 need true.
@export var fallbackTarget: int ##if condition failed go to this target instead.
