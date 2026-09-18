extends Resource

class_name statuseffect

signal durationOver()

@export var icon: Texture
@export var Name: String
@export var active: bool = false

@export var timed: bool = false
@export var duration: float
@export var timeleft: float

var temptimer: Timer

func initialize():
	if timed:
		temptimer = Timer.new()
		Globals.effecthandler.add_child(temptimer)
		temptimer.start(duration)
		temptimer.timeout.connect(stop)

func tick():
	print("ticking effect")
	timeleft = temptimer.time_left
	print(timeleft)

func stop():
	durationOver.emit()
