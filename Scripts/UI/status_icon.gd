extends Control

@onready var icon = $icon
@onready var fadeNode: ColorRect = $fade

@export var fade: float:
	set(value):
		fade = value
		#set transparency

@export var statusEffect: statuseffect
var fading: bool = false

func initialize():
	#statusEffect.initialize()
	icon.texture = statusEffect.icon
	if statusEffect.timed:
		statusEffect.durationOver.connect(stopFading)
		fading = true

func tick():
	if fading:
		print("ticking status icon")
		statusEffect.tick()
		var converted:float = 1.0-((1.0/statusEffect.duration) * statusEffect.timeleft)
		print(converted)
		fadeNode.color.a = converted

func stopFading():
	fading = false
	self.queue_free()
