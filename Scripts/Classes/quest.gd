extends Resource
class_name Quest

#most of this will deadass be ripped from dustrialis
@export_enum("Unknown", "Given","Achieved","Completed","Failed") var quest_state: int
@export var progress: int
@export var botched: bool

@export var icon: Texture2D

@export var questName: String
@export var questId: int
@export var mainQuest: bool = false
@export var completeUponAchievement: bool
@export var announce: bool
@export var givesReward: bool
@export var reward: itemClass
@export var progressDescriptionsActive: bool = false
@export var descriptions: Array[String] = [
	"blank",
	"You've discovered this quest.",
	"You've progressed this quest.",
	"You've completed this quest,",
	"mystery status",
	"You've failed this quest."
]## just matches the states.
@export var progressDescriptions: Array[String]
@export var dependentConditions: Dictionary[int, Array] = {
	0: [],
	1: [],
	2: [],
	3: [],
	4: []
} ##THIS WILL BE REPLACED EVENTUALLY. But all conditions contained within these will simply be set to true.

func getQuestState() -> int:
	if botched:
		return 5
	else:
		return quest_state

func getDescription(state: int, progressState: int = 0) -> String:
	if state != 2 or !progressDescriptionsActive:
		return descriptions[state]
	else:
		return progressDescriptions[progressState]

func isQuestStatePossible(state: int):
	if state > quest_state:
		return true
	else:
		return false

func setProgress(value: int):
	var succesful = false
	if value >= progress:
		progress = value
		succesful = true
	
	if succesful:
		Globals.Player.notify(str("Progressed ", questName, "."), "Mission1")

func setQuestState(state: int): ##cannot go backwards, 1 given, 2 achieved, 3 completed.
	#print("changed eyes emoji")
	var succesful = false
	if state > quest_state:
		quest_state = state
		succesful = true
	if completeUponAchievement and state == 2:
		quest_state = 3
		succesful = true
	
	if succesful:
		match state:
			1:
				Globals.Player.notify(str("Discovered quest ", questName, "."), "Mission1")
			2:
				Globals.Player.notify(str("Progressed ", questName, "."), "Mission1")
			3:
				Globals.lastCompletedQuestName = questName
				Globals.Player.notify(str("Completed quest ", questName, "."), "Mission1")
		update()

func update():
	for i in dependentConditions[quest_state]:
		i.fulfilled = true

func botchQuest():
	botched = true
	quest_state = 4
	update()
	Globals.Player.notify(str("Failed quest ", questName, "."), "Mission1")

func questReward(inv: Node):
	if givesReward:
		Globals.inventory.add(reward)

func isQuestDiscovered():
	if quest_state != 0:
		return true
	else:
		return false

func isQuestCompleted():
	if quest_state == 4:
		return true
	else:
		return false
