extends Resource

class_name conversation

@export var speakerName: String
@export var manuscript: Array[dialogue] = []
@export var linkedQuest: Quest ## you do not need to assign this, its self setting.
@export var hasQuest: bool

func updateQuest(): ## does not support conversations with several quests yet. will implement when needed
	if hasQuest:
		for i in manuscript:
			if i.quest:
				linkedQuest = i.quest
				break
		
		for b in Globals.quests:
			if b.questId == linkedQuest.questId:
				linkedQuest = b
				break
		
		for i in manuscript:
			if i.quest:
				if i.quest.questId == linkedQuest.questId:
					print("updated quest")
					i.quest = linkedQuest
					linkedQuest.update()
		return true
	else:
		return false
