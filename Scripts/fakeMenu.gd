extends Control

@onready var inventory = $Inventory

func activateMenu():
	pass

func hideMenu():
	inventory.inventoryGrid.closeDropDown()
