extends Node3D

@onready var tram = preload("res://Scenes/tram.tscn")

@export var containsTrams: bool = true
@export var tramTransforms: Dictionary[int,Array]
@export var tramNodes: Dictionary[int, Path3D]

@export var alreadyInitialized = false

@export var isGlobal: bool = true
@export var globalName: StringName = "currentWorldNode"

func _ready() -> void:
	Globals.currentWorldNode = self
	await get_tree().create_timer(0.2).timeout
	if !alreadyInitialized:
		initialize()
		alreadyInitialized=true
	

func initialize():
	#print("initializing")
	var startPoint
	var x = 0
	if containsTrams:
		for i in tramNodes:
			var stop_offsets: Array[float]
			var curve = Curve3D.new()
			#var temptramNodes = i #i dont know why i felt this was necessary
			
			tramTransforms[x].sort_custom(func(a: Node3D, b: Node3D) -> bool:
				return a.pathIndex < b.pathIndex
			)
			#var shit: Array[Vector3]
			for b in tramTransforms[x]:
				curve.add_point(b.global_position)
				#check if its the start point, honestly redundant.
				if b.isStop:
					#print("stop found, murdering coder")
					var offset = curve.get_closest_offset(tramNodes[i].to_local(b.global_position))
					stop_offsets.append(offset)
				if b.isStartPoint:
					#print("found start point")
					startPoint = b
					#this SHOULD fix origin starting issue
					#tramNodes[i].global_position = b.global_position
				#shit.append(b.global_position)
			
			tramNodes[i].curve = curve.duplicate()
			stop_offsets.sort()
			
			var shitfart = tram.instantiate()
			self.add_child(shitfart)
			shitfart.TramFollower.reparent(tramNodes[i])
			shitfart.set_owner(self)
			shitfart.TramFollower.stopoffsets = stop_offsets.duplicate()
			
			#print("Baked length: ", curve.get_baked_length())
			#print(curve.get_point_position(0))
			
			x+=1
