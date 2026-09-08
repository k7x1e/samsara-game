extends Control

@onready var healthB = $health/bar
@onready var manaB = $mana/bar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func tick():
	healthB.value = Globals.Player.health
	manaB.value = Globals.Player.mana
