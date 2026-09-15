extends Control

@onready var questcontainer = $VBoxContainer/ScrollContainer/questContainer
@onready var questNode = preload("res://Scenes/quest.tscn")

@export var quests: Array[Quest]

func update():
	initialize()

func updateWindow():
	pass


func initialize():
	quests = Globals.quests
	#purge
	for i in questcontainer.get_children():
		i.queue_free()
	
	#add quests
	for i in quests:
		if i.isQuestDiscovered():
			var temp = questNode.instantiate()
			questcontainer.add_child(temp)
			temp.set_owner(self)
			temp.quest = i
			temp.initialize()
