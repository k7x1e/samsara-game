extends Resource

class_name gameState

@export var initnodes: Array[nodePreset]
@export var rootNode: Variant
@export var saves: Dictionary[String, SaveGame]
@export var initialized: bool = false

var last_saved: String

func get_last_save() -> SaveGame:
	if last_saved:
		return saves[last_saved]
	else:
		return null

func get_save(i: String) -> SaveGame:
	if saves[i]:
		return saves[i]
		print("found it")
	else:
		return null

func add_save(theSaveInQuestion: SaveGame, name: String = "placeholder"):
	last_saved = name
	var fuckyou = {name: theSaveInQuestion}
	saves[name] = theSaveInQuestion

func initialize():
	
	saves.clear()
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	dir = DirAccess.open("user://saves/")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		print("found ourselves a ", file_name)
		var tempname = file_name.left(-4)
		
		var save_file = load(str("user://saves/",file_name))
		print(save_file)
		print(tempname)
		saves[tempname] = save_file
		file_name = dir.get_next()

	print(saves.size())
	if !initialized:
		await rootNode.initialize(self)
		rootNode.Menu.set_process(false)
		rootNode.Menu.hide()
		Globals.inventory.initialize()
	elif Globals.loadSave:
		rootNode.initalizeSave()
		rootNode.signalinit()
		Globals.inventory.initialize()
	#else:
	#	Globals.setGlobals(rootNode.backupGlobals)
