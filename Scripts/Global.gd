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
	var quests_copy: Array[Quest] = []
	for q in quests:
		quests_copy.append(q.duplicate(true))
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
		"quests": quests_copy,
		"gamestate": gamestate.duplicate_deep(Resource.DEEP_DUPLICATE_ALL),
	}
	#print(quests[0].getQuestState())

func setGlobals(data: Dictionary):
	quests.clear()
	#print("THIS IS THE STATUS OF THE QUEST YOU WANT",data["quests"][0].getQuestState())
	quests = convertArray(data["quests"], Quest)
	#print(quests[0].getQuestState())
	gamestate = data["gamestate"].duplicate(true)

func convertArray(from:Array, type:Variant) -> Array:
	var result = []
	result.assign(from)
	result = Array(result, TYPE_OBJECT, "Resource", type)
	return result
