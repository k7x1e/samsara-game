extends Control

@onready var effectsnode = $effect
@onready var effect = preload("res://Scenes/status_icon.tscn")

@export var effects: Array[statuseffect]

func _ready() -> void:
	Globals.effecthandler = self

func initialize():
	refreshEffects()

func refreshEffects():
	#flush
	for i in effectsnode.get_children():
		i.queue_free()
	
	#start initializing
	effects = Globals.Player.statuseffects
	for b in range(effects.size()):
		var bx = effects.size()-1 - b
		if effects[bx].active:
			var temp = effect.instantiate()
			effectsnode.add_child(temp)
			temp.set_owner(self)
			
			#scrapped tooltip implementation
			#temp.gui_input.connect(iconguiInput.bind(temp))
			temp.statusEffect = effects[bx]
			temp.initialize()

#func iconguiInput
