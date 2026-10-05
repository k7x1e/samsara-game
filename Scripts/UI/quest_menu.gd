extends Control

#words to the wise, make sure these arent twisted
@onready var sidequestcontainer = $VBoxContainer/ScrollContainer/questContainer/sub
@onready var mainquestcontainer = $VBoxContainer/ScrollContainer/questContainer/main
@onready var questNode = preload("res://Scenes/quest.tscn")

@export var quests: Array[Quest]

func update():
	initialize()

func updateWindow():
	pass


func initialize():
	quests = Globals.quests
	#purge
	for i in mainquestcontainer.get_children():
		if i.name != "Label":
			i.queue_free()
	for i in sidequestcontainer.get_children():
		if i.name != "Label":
			i.queue_free()
	
	#add quests
	for i in quests:
		if i.isQuestDiscovered():
			var temp = questNode.instantiate()
			match i.mainQuest:
				true:
					#print("main quest")
					mainquestcontainer.add_child(temp)
				false:
					#print("side quest")
					sidequestcontainer.add_child(temp)
			temp.set_owner(self)
			temp.quest = i
			temp.initialize()

func get_save_data():
	return {
		"position": global_position,
		"size": size,
	}

func load_save_data(data: Dictionary):
	global_position = data["position"]
	size = data["size"]
	updateWindow()
