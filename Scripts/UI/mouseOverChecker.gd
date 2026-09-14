extends Control

@onready var charSheet = $"../../../../"

@export var mouse_over: bool = false
@export var amIUnderTheCharacterSheet: bool = false
@export var ifSoWhichStatAmI: int

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _mouse_entered():
	print("mouse is over")
	mouse_over = true
	if amIUnderTheCharacterSheet:
		charSheet.showMenu(ifSoWhichStatAmI)

func _mouse_exited():
	mouse_over = false
	if amIUnderTheCharacterSheet:
		charSheet.hideMenu()
