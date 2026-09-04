extends Resource
class_name Quest

#most of this will deadass be ripped from dustrialis
@export_enum("Unknown", "Given","Achieved","Completed") var quest_state: int

@export var botched: bool
@export var questName: String
@export var questId: int
@export var completeUponAchievement: bool
@export var announce: bool
@export var givesReward: bool
@export var reward: itemClass
@export var descriptions: Array[String] ## just matches the states.

func getQuestState() -> int:
	if botched:
		return 5
	else:
		return quest_state

func isQuestStatePossible(state: int):
	if state > quest_state:
		return true
	else:
		return false

func setQuestState(state: int): ##cannot go backwards, 1 given, 2 achieved, 3 completed.
	if state > quest_state:
		quest_state = state
	if completeUponAchievement and state == 2:
		state = 3

func botchQuest():
	botched = true

func questReward(inv: Node):
	if givesReward:
		Globals.inventory.add(reward)

func isQuestCompleted():
	if quest_state == 4:
		return true
	else:
		return false
