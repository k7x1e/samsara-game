extends Resource

class_name gameState

@export var initnodes: Array[nodePreset]
@export var rootNode: Variant
@export var saves: Array[PackedScene]
@export var initialized: bool = false

func get_last_save() -> PackedScene:
	var fart = saves.size()-1
	print(fart)
	return saves[fart]

func get_save(i: int) -> PackedScene:
	return saves[i]

func add_save(theSaveInQuestion: PackedScene):
	var fileName = str("save_",saves.size())
	print(fileName)
	var filePath = str("user://Save/", fileName)
	ResourceSaver.save(theSaveInQuestion, filePath)
	saves.append(theSaveInQuestion)
	ResourceSaver.save(self, "user://Save/saves.sav")

func initialize():
	if !initialized:
		await rootNode.initialize(self)
		rootNode.Menu.set_process(false)
		rootNode.Menu.hide()
		Globals.inventory.initialize()
