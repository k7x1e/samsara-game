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

@export var mainWorldPlayerPos: Vector3

@export var softlocked: bool = false:
	set(value):
		softlocked = value
		#notify that the game has been softlocked
		#Player.notify("You've killed a mortal whose fate was essential to yours. The prophecy cannot be completed.")
		Root.prophecyNotif.show()
		print("game is now uncompletable")

@export var lastCompletedQuestName: String = "None."

@export var goldItem: gold

func getGlobals() -> Dictionary[String, Variant]:
	var quests_copy: Array[Quest] = []
	for q in quests:
		quests_copy.append(q.duplicate(true))
	return {
		#"Root": Root,
		#"Player": Player,
		#"wizard": wizard,
		"stats": stats.duplicate(true),
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
		"mainWorldPlayerPos": mainWorldPlayerPos,
		"lastCompletedQuestName": lastCompletedQuestName,
	}
	#print(quests[0].getQuestState())

func setDefaultGlobals():
	#only thing this should need to do is just reload the gamestate
	gamestate = load("res://Resources/gameState.tres")


func setGlobals(data: Dictionary):
	lastCompletedQuestName = data["lastCompletedQuestName"]
	stats = data["stats"].duplicate(true)
	quests.clear()
	#print("THIS IS THE STATUS OF THE QUEST YOU WANT",data["quests"][0].getQuestState())
	quests = convertArray(data["quests"], Quest)
	#print(quests[0].getQuestState())
	gamestate = data["gamestate"].duplicate(true)
	mainWorldPlayerPos = data["mainWorldPlayerPos"]

func convertArray(from:Array, type:Variant) -> Array:
	var result = []
	result.assign(from)
	result = Array(result, TYPE_OBJECT, "Resource", type)
	return result
