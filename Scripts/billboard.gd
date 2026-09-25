extends Node3D

@export var billboardtext: String = "Placeholder"
@onready var textNode = $SubViewport/CanvasLayer/CenterContainer/RichTextLabel
@export var duration: float = 3.0
@export var yOffset: float = 1.5
@onready var spriteNode = $Sprite3D
@export var letterDelay: float = 0.06
@export var spaceDelay: float = 0.05
@export var removeDelay: float = 0.01
@onready var sfx = $sfx

func initialize():
	spriteNode.position.y += yOffset
	
	var l = billboardtext.length()
	var b = 1
	while b <= l:
		if billboardtext[b-1] != " ":
			textNode.text = billboardtext.left(b)
			sfx.play()
			await Engine.get_main_loop().create_timer(letterDelay).timeout
		else:
			await Engine.get_main_loop().create_timer(spaceDelay).timeout
		b += 1
	
	if duration != 0.0:
		await Engine.get_main_loop().create_timer(duration).timeout
		
		while b >= 0:
			textNode.text = billboardtext.left(b)
			await Engine.get_main_loop().create_timer(removeDelay).timeout
			b -= 1
		self.queue_free()
	return true
