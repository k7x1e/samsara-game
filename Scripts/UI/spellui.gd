extends Control

@onready var iconNode = $spellIcon
@onready var dim = $Dimmin
@onready var timerNode = $Timer
@onready var costLabel = $Label

@export var spel: spell

@export var timer_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_active:
		dim.value = spel.spellTimer.wait_time - spel.spellTimer.time_left


func _on_timer_timeout() -> void:
	timer_active = false
