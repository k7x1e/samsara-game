extends Resource

class_name gameState

@export var initnodes: Array[nodePreset]
@export var rootNode: Variant
@export var saves: Dictionary[String, SaveGame]
@export var initialized: bool = false
@export var newWorld: Variant
@export var newWorldName: NodePath ## INSANE JANK, Just make sure no two places have the same name

@export var combatBehaviours: Array[combatBehaviour]

var last_saved: String

func get_last_save() -> SaveGame:
	if last_saved:
		return saves[last_saved]
	else:
		return null

func get_save(i: String) -> SaveGame:
	if saves[i]:
		return saves[i]
		#print("found it")
	else:
		return null

func add_save(theSaveInQuestion: SaveGame, name: String = "placeholder"):
	last_saved = name
	var fuckyou = {name: theSaveInQuestion}
	saves[name] = theSaveInQuestion

func sort_dict_newest_first(dict: Dictionary) -> Dictionary:
	# Get all keys
	var keys := dict.keys()
	
	# Sort the keys by the creation_time of the value objects (newest first)
	keys.sort_custom(func(a, b):
		var time_a := Time.get_unix_time_from_datetime_string(dict[a].timestamp)
		var time_b := Time.get_unix_time_from_datetime_string(dict[b].timestamp)
		return time_a > time_b
	)
	
	# Rebuild a new dictionary in the sorted order
	var sorted_dict: Dictionary [String, SaveGame] = {}
	for key in keys:
		sorted_dict[key] = dict[key]
	
	return sorted_dict

func initializeSaves():
	saves.clear()
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	dir = DirAccess.open("user://saves/")
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		#print("found ourselves a ", file_name)
		var tempname = file_name.left(-4)
		
		var save_file = load(str("user://saves/",file_name))
		#print(save_file)
		#print(tempname)
		if save_file:
			saves[tempname] = save_file.duplicate(true)
			file_name = dir.get_next()
	saves = sort_dict_newest_first(saves)
	return true

func initialize():
	initializeSaves()
	#print(saves.size())
	if !initialized and !Globals.loadSave:
		
		await rootNode.initialize(self)
		rootNode.Menu.set_process(false)
		rootNode.Menu.hide()
		Globals.inventory.initialize()
		rootNode.triggerTutorial()
	elif Globals.loadSave:
		print("loading form a save")
		rootNode.initalizeSave()
		rootNode.signalinit()
		Globals.inventory.initialize()
	#else:
	#	Globals.setGlobals(rootNode.backupGlobals)
