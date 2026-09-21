extends Control

@onready var healthB = $health/bar
@onready var manaB = $mana/bar

func tick():
	healthB.value = Globals.Player.health
	manaB.value = Globals.Player.mana
