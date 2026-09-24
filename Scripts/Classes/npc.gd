extends Resource

class_name npc

@export var npcName: String
@export var usesModel: bool = true
@export var model: PackedScene
@export var behaviour: Behaviour

@export var necessary: bool = false ## if true, killing this npc will warn the player that the game cannot be progressed
