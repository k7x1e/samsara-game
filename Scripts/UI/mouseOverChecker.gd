extends Control

@onready var charSheet = $"../../../../"

@export var mouse_over: bool = false
@export var amIUnderTheCharacterSheet: bool = false
@export var ifSoWhichStatAmI: int

func _gui_input(event: InputEvent) -> void:
	print("mouse is over")
	mouse_over = true
	if amIUnderTheCharacterSheet:
		charSheet.showMenu(ifSoWhichStatAmI)

func mouse_exited():
	mouse_over = false
	if amIUnderTheCharacterSheet:
		charSheet.hideMenu()
