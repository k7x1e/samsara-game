extends Control

@onready var statLabel = $VBoxContainer/PanelContainer/Label
@onready var toolTip = $tooltip

@export var stats: Array[Variant] = ["Agility", "Magic", "Perception", "Intelligence", "Strength"]



func _ready() -> void:
	update()

func update():
	var statString: String = ""
	var x = 0
	for i in Globals.stats.stats:
		statString += str(stats[x], ": ", i, "\n")
		x += 1
	statLabel.text = statString

# Called when the node enters the scene tree for the first time.
func updateWindow():
	pass

func showMenu(stat: int):
	toolTip.following = true
	toolTip.show()
	toolTip.pLabel.text = str(Globals.stats.progressStats[stat], "/", Globals.stats.progressMax)
	toolTip.dLabel.text = Globals.stats.statDescriptions[stat]

func hideMenu():
	toolTip.following = false
	toolTip.hide()
