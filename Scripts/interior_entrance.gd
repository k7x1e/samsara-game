@tool
extends Node3D

@onready var playerChecker = $check
@export var targetSceneString: String = "null"
@export var fromInterior: bool
@export var interiorName: String = "placeHolder"
@export var unlocked: bool = true

@onready var billboard = $billboard

var targetScene: PackedScene

var overlapping: bool

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	targetSceneString = entity_properties["targetScene"] as String
	fromInterior = entity_properties["fromInterior"] as bool
	interiorName = entity_properties["interiorName"] as String
	unlocked = entity_properties["unlocked"] as bool

func _ready() -> void:
	billboard.billboardtext = interiorName
	billboard.initialize()
	#var stringshit = str("res://Scenes/Worlds/Interiors/",targetSceneString,".tscn")
	#targetScene = load(targetSceneString)
	#print(stringshit)
	#load("res://Scenes/Worlds/Interiors/londonPub.tscn")

func _process(delta: float) -> void:
	if overlapping:
		#print("overlapping")
		billboard.show()
		#billboard.global_position = Globals.Player.global_position
		if Input.is_action_just_pressed("enter"):
			#print("pressed a button eyes emoji")
			var bodies = playerChecker.get_overlapping_bodies()
			for body in bodies:
				#print(body.name)
				if body.name == "Player":
					if unlocked:
						if fromInterior:
							Globals.Root.changeWorld(self, targetSceneString, false)
						else:
							Globals.Root.changeWorld(self, targetSceneString, true)
					else:
						body.notify("locked...", "locked")
	else:
		billboard.hide()
	


func body_entered(body: Node3D) -> void:
	overlapping = true


func body_exited(body: Node3D) -> void:
	overlapping = false
