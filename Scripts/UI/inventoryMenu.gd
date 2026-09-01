extends Control

@onready var inventoryGrid = $VBoxContainer/PanelContainer/GridContainer

func updateWindow():
	inventoryGrid.checkColumns()
