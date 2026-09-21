extends Node

var backupGlobals

@export var Root: Node3D

@export var Player: CharacterBody3D
@export var wizard: Node
@export var stats: Stats

@export var settingsMenu: Control
@export var dialogueMenu: Control
@export var menu: Node
@export var spellMaster: Control
@export var effecthandler: Control
@export var inventory: Control

@export var currentWorldNode: Node

@export var idHandler = ItemIdHandler.new()

#its important that all story stuff is stored here so that we can keep track of them
@export var quests: Array[Quest]
@export var conditions: Array[Condition]

@export var saveToLoad: SaveGame
@export var loadSave: bool = false

@export var gamestate: gameState = preload("res://Resources/gameState.tres")

func getGlobals() -> Dictionary[String, Variant]:
	return {
		#"Root": Root,
		#"Player": Player,
		#"wizard": wizard,
		#"stats": stats.duplicate(true),
		#"settingsMenu": settingsMenu,
		#"dialogueMenu": dialogueMenu,
		#"menu": menu,
		#"spellMaster": spellMaster,
		#"effecthandler": effecthandler,
		#"inventory": inventory,
		#"currentWorldNode": currentWorldNode,
		#"idHandler": idHandler.duplicate(true),
		"quests": quests.duplicate(true),
		"gamestate": gamestate.duplicate(true),
	}

func setGlobals(data: Dictionary):
	quests = convertArray(data["quests"], Quest)
	gamestate = data["gamestate"]

func convertArray(from:Array, type:Variant) -> Array:
	var result = []
	result.assign(from)
	result = Array(result, TYPE_OBJECT, "Resource", type)
	return result
