extends HBoxContainer

@onready var saveNameNode = $saving/LineEdit
@onready var loadingNode = $loading/OptionButton

@onready var saveButton = $saving/save
@onready var loadButton = $loading/load

@export var saves: Dictionary[int,String]

func initialize():
	refreshSaves()

func refreshSaves():
	loadingNode.clear()
	saves.clear()
	var saveList = Globals.Root.gamestate.saves
	var x = 0
	for i in saveList:
		print("added", i)
		loadingNode.add_item(i,x)
		saves.assign({x:i})

func _on_save_pressed() -> void:
	var name = saveNameNode.text
	print(name)
	Globals.Root.save(get_tree().current_scene, name)
	refreshSaves()


func _on_load_pressed() -> void:
	var index = loadingNode.get_selected_id()
	var save = saves[index]
	Globals.Root.loadSave(save)
	
