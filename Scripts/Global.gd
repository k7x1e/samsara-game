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

@export var quests: Array[Quest]

@export var saveToLoad: SaveGame
@export var loadSave: bool = false

@export var gamestate: gameState = preload("res://Resources/gameState.tres")

func getGlobals() -> Dictionary[String, Variant]:
	return {
		"Root": Root,
		"Player": Player,
		"wizard": wizard,
		"stats": stats,
		"settingsMenu": settingsMenu,
		"dialogueMenu": dialogueMenu,
		"menu": menu,
		"spellMaster": spellMaster,
		"effecthandler": effecthandler,
		"inventory": inventory,
		"currentWorldNode": currentWorldNode,
		"idHandler": idHandler,
		"quests": quests,
		"gamestate": gamestate,
	}

func setGlobals(data: Dictionary[String, Variant]):
	for i in data:
		self.set(i, data.get(i))
