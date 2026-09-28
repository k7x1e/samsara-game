extends Control

@onready var icon = $Stuff/Icon
@onready var nameNode = $Stuff/info/Importance/Name
@onready var status = $Stuff/info/Importance/Status
@onready var description = $Stuff/info/Description
@onready var typeL = $Stuff/info/Description/typelable

@export var quest: Quest

func initialize():
	icon.texture = quest.icon
	nameNode.text = quest.questName
	description.text = quest.getDescription(quest.quest_state)
	match quest.mainQuest:
		true:
			typeL.text = "Main Quest"
		false:
			typeL.text = "Substory Quest"
	
	var tStatus: String = "Failed"
	match quest.getQuestState():
		1:
			tStatus = "Discovered."
		2:
			tStatus = "In Progress."
		3:
			tStatus = "Completed."
		5:
			tStatus = "Failed."
	status.text = tStatus
