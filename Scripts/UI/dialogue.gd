extends Control

@export var dialogueToUse: conversation
@export var index: int = 0

@onready var textNode = $VBoxContainer/Label
@onready var optionNode = $VBoxContainer/Options
@onready var option = preload("res://Scenes/dialogue_option.tscn")

@onready var nameLabel = $VBoxContainer/name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.dialogueMenu = self

func update():
	nameLabel.text = dialogueToUse.speakerName
	print("updating dialogue")
	for i in optionNode.get_children():
		i.queue_free()
	var currentW = dialogueToUse.manuscript[index]
	if currentW.isDialogue:
		textNode.text = currentW.dialogueText
		var b = 0
		#for name: String in names:
		for i: DialogueOption in currentW.dialogueOptions:
			var temp= option.instantiate()
			optionNode.add_child(temp)
			temp.text = i.text
			temp.pressed.connect(optionPressed.bind(i.target))
			b += 1

func optionPressed(i: int):
	if i == -1:
		Globals.Root.stopDialogue()
	index = i
	update()
