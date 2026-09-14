extends Node3D

@export var billboardtext: String = "Placeholder"
@onready var textNode = $SubViewport/CanvasLayer/CenterContainer/RichTextLabel
@export var duration: float = 3.0
@export var yOffset: float = 1.5
@onready var spriteNode = $Sprite3D

func initialize():
	spriteNode.position.y += yOffset
	textNode.text = billboardtext
	if duration != 0.0:
		await Engine.get_main_loop().create_timer(duration).timeout
		self.queue_free()
	return true
