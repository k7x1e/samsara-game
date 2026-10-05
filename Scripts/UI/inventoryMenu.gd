extends Control

@onready var inventoryGrid = $VBoxContainer/PanelContainer/GridContainer

func updateWindow():
	inventoryGrid.checkColumns()

func get_save_data():
	return {
		"position": global_position,
		"size": size,
	}

func load_save_data(data: Dictionary):
	global_position = data["position"]
	size = data["size"]
	updateWindow()
