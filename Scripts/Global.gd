extends Node

var Root: Node3D

var Player: CharacterBody3D
var inventory: Control
var wizard: Node
var stats: Stats

var settingsMenu: Control
var dialogueMenu: Control
var menu: Node
var spellMaster: Control
var effecthandler: Control

var currentWorldNode: Node

var idHandler = ItemIdHandler.new()

var quests: Array[Quest]
