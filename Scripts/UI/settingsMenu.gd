extends Control

@onready var scaleSlider = $VBoxContainer/Scale/Control/HSlider
var scaleValue: float
var backupScale

@onready var resolutionPicker = $VBoxContainer/Resolution/Control/OptionButton
var resolutionValue: Vector2i = Vector2i(1920,1080)
var backupResolution

@onready var shadowPicker = $VBoxContainer/shadow/Control/OptionButton
var shadowValue: int = 1024
var backupshadow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.settingsMenu = self
	initialize()

func initialize():
	var sData
	sData = await loadSettings()
	await get_tree().create_timer(0.1).timeout
	scaleValue = sData["uiscale"]
	#resolutionValue = sData["resolutionvalue"], depreceated. does not work
	await saveSettings(false)
	scaleSlider.value = ProjectSettings.get_setting("display/window/stretch/scale")

func loadSettings():
	#assign defaults
	var settingdata = {
		"uiscale": ProjectSettings.get_setting("display/window/stretch/scale"),
		"resolutionvalue": DisplayServer.window_get_size()
	}
	
	if not FileAccess.file_exists("user://settings.shit"):
		print("didnt exist")
		return settingdata
	
	var open_err = FileAccess.open("user://settings.shit", FileAccess.READ)
	var json_object = JSON.new()
	var _parse_err = json_object.parse(open_err.get_as_text())
	print ("succeeded in loading")
	settingdata = json_object.get_data()
	return settingdata

func saveSettings(toFile: bool):
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/size", shadowValue)
	get_window().content_scale_factor = scaleValue
	DisplayServer.window_set_size(resolutionValue)
	if toFile:
		saveToPedofile()

func saveToPedofile():
	var save_file = FileAccess.open("user://settings.shit", FileAccess.WRITE)
	
	var setting_data = {
		"uiscale": scaleValue,
		"resolutionvalue": resolutionValue
	}
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(setting_data)

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func save_pressed() -> void:
	saveSettings(true)
	backupScale = scaleValue
	backupResolution = resolutionValue

func discard_pressed() -> void:
	scaleSlider.value = backupScale

func slider_drag_ended(_value_changed: bool) -> void:
	scaleValue = scaleSlider.value
