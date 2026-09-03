extends Control

@onready var healthB = $health/bar
@onready var manaB = $mana/bar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	healthB.value = Globals.Player.health
	manaB.value = Globals.Player.mana
