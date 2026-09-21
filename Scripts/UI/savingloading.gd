extends HBoxContainer

@onready var saveNameNode = $VBoxContainer/saving/LineEdit
@onready var loadingNode = $VBoxContainer/loading/OptionButton

@onready var saveButton = $VBoxContainer/saving/save
@onready var loadButton = $VBoxContainer/loading/load

@onready var infoNode = $Label

@export var saves: Dictionary[int,String]

func initialize():
	refreshSaves()

func refreshSaves():
	loadingNode.clear()
	saves.clear()
	var saveList = Globals.Root.gamestate.saves
	var x = 0
	for i in saveList:
		#print("added", i, x)
		loadingNode.add_item(i,x)
		saves[x] = i
		x += 1

func _on_save_pressed() -> void:
	var name = saveNameNode.text
	#print(name)
	Globals.Root.save(get_tree().current_scene, name)
	refreshSaves()


func _on_load_pressed() -> void:
	var index = loadingNode.get_selected_id()
	var save = saves[index]
	print("THIS IS WHAT YOURE LOOKING FOR:", save)
	Globals.Root.loadSave(save)
	


func _on__item_selected(index: int) -> void:
	var sindex = saves[index]
	var selected: SaveGame = Globals.Root.gamestate.saves[sindex]
	var infoString = str(sindex, "\n", selected.timestamp, "\n", selected.Description)
	print(infoString)
	infoNode.text = infoString
