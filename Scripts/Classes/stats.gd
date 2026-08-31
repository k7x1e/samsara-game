extends Node

@export var agility: int
@export var magic: int
@export var perception: int
@export var intelligence: int

@export var stats = [agility, magic, perception, intelligence]
#just put stats and their function

func retrieve(stat: int): #0: agility, 1: magic, 2: perception, 3: intelligence
	return stats[stat]
