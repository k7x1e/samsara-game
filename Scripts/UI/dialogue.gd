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
	#print("updating dialogue")
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
			if i.fallbackTarget == -2 and !i.condition.fulfilled:
				temp.disabled = true
				if i.hide:
					temp.hide()
			temp.pressed.connect(optionPressed.bind(i))
			b += 1
		if currentW.questStatus != 0:
			print(currentW.questStatus)
			currentW.quest.setQuestState(currentW.questStatus)
			#i must say, this system is shit but damn if it isnt convenient to scale

func optionPressed(i: DialogueOption):
	if i.target == -1:
		Globals.Root.stopDialogue()
		return
	index = 3
	match i.condMode:
		1:
			match i.condition.fulfilled:
				true:
					index = i.target
				false:
					index = i.fallbackTarget
		0:
			match i.condition.fulfilled:
				true:
					index = i.fallbackTarget
				false:
					index = i.target
		-1:
			index = i.target
	update()
