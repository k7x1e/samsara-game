extends Control

@onready var infoNode = $VBoxContainer/PanelContainer/Info
@onready var infoButton = $VBoxContainer/Sections/info

@onready var settingsNode = $VBoxContainer/PanelContainer/Settings
@onready var settingsButton = $VBoxContainer/Sections/settings

@onready var systemNode = $VBoxContainer/PanelContainer/System
@onready var systemButton = $VBoxContainer/Sections/system

var activeMenu: int = 0 #0 info, 1 settings, 2 system

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	Globals.Root.pauseMenu = get_parent()
	updateMenu()

func updateMenu():
	match activeMenu:
		0:
			infoButton.disabled = true
			settingsButton.disabled = false
			systemButton.disabled = false
			
			infoNode.show()
			settingsNode.hide()
			systemNode.hide()
		1:
			infoButton.disabled = false
			settingsButton.disabled = true
			systemButton.disabled = false
			
			infoNode.hide()
			settingsNode.show()
			systemNode.hide()
		2:
			infoButton.disabled = false
			settingsButton.disabled = false
			systemButton.disabled = true
			
			infoNode.hide()
			settingsNode.hide()
			systemNode.show()




func info_pressed() -> void:
	activeMenu = 0
	updateMenu()

func settings_pressed() -> void:
	activeMenu = 1
	updateMenu()


func system_pressed() -> void:
	activeMenu = 2
	updateMenu()
