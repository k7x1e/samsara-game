extends Control

@export var maxOffset: float = 2.0
@export var targetPos: Vector2
@export var duration: float = 0.2

@export var toShow: String = "ACT 49: PLACEHOLDER"
@export var letterDelay: float = 0.5
@export var spaceDelay: float = 0.6
@export var reverseLetterDelay: float = 0.05

@export var sound: bool = true

@onready var label = $label
@onready var sfx = $sfx

var tween

func initialize():	
	var l = toShow.length()
	var b = 1
	while b <= l:
		if toShow[b-1] != " ":
			label.text = toShow.left(b)
			shake(duration)
			if sound:
				sfx.play()
			await get_tree().create_timer(letterDelay).timeout
		else:
			await get_tree().create_timer(spaceDelay).timeout
		b += 1
	
	while b >= 0:
		label.text= toShow.left(b)
		await get_tree().create_timer(reverseLetterDelay).timeout
		b -= 1
	
	self.queue_free()


func shake(shakeDur: float):
	var oldPos = global_position
	var curX = global_position.x
	var curY = global_position.y
	var x = 0
	var newOffset = maxOffset
	while x <= shakeDur:
		tween = get_tree().create_tween()
		targetPos = Vector2(randf_range(curX-newOffset, curX+newOffset),randf_range(curY-newOffset, curY+newOffset))
		tween.tween_property(self,"global_position", targetPos, 0.03)
		await get_tree().create_timer(0.03).timeout
		x += 0.03
		newOffset -= (maxOffset/shakeDur)*0.03
	global_position = oldPos
