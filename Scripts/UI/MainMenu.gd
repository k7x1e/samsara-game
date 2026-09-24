extends Control

@onready var loading = $main/loading
@onready var loadOptions = $main/loading/OptionButton
@onready var loadingButton = $main/loading/load

@onready var continueButton = $main/cont
@onready var loadButton = $main/load

@onready var loadingScreen = preload("res://Scenes/loading_screen.tscn")

@onready var sfx = $sfx
@onready var anim = $anim

@export var saves: Dictionary[String, SaveGame]
@export var saves2: Dictionary[int,String]

@onready var buttonSound = preload("res://sound/notification/menu.wav")
@onready var newGameSound = preload("res://sound/notification/mission.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.gamestate.initializeSaves()
	saves = Globals.gamestate.saves
	refreshSaves()
	if saves.size() == 0:
		continueButton.disabled = true
		loadButton.disabled = true

func refreshSaves():
	loadOptions.clear()
	saves2.clear()
	saves = Globals.gamestate.saves
	var x = 0
	for i in saves:
		#print("added", i, x)
		loadOptions.add_item(i,x)
		saves2[x] = i
		x += 1

func menuSound():
	sfx.stream = newGameSound
	sfx.play()
	anim.play("new_game")
	await get_tree().create_timer(3).timeout
	return true

func continue_pressed() -> void:
	await menuSound()
	loadSave(saves2[0])

func new_pressed() -> void:
	Globals.loadSave = false
	Globals.gamestate.initialized = false
	await menuSound()
	get_tree().change_scene_to_packed(loadingScreen)


func load_pressed() -> void:
	refreshSaves()
	loading.show()
	sfx.stream = buttonSound
	sfx.play()


func settings_pressed() -> void:
	pass #open a settings menu


func quit_pressed() -> void:
	await menuSound()
	get_tree().quit()


func _on_load_pressed() -> void:
	var index = loadOptions.get_selected_id()
	var save = saves2[index]
	await menuSound()
	loadSave(save)

func loadSave(_which: String):
	var save3 = saves[_which]
	#print(save)
	
	Globals.saveToLoad = save3
	Globals.loadSave = true
	print(Globals.saveToLoad)
	#load into the loadin screen
	get_tree().change_scene_to_packed(loadingScreen)
