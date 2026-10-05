extends Resource

class_name dialogue

@export var isDialogue: bool = true
@export var dialogueText: String = "PlaceHolder"

@export var dialogueOptions: Array[DialogueOption]

#@export var target: int

@export_enum("Unknown", "Given","Progressed","Completed","Failed") var questStatus: int = 0## 0 means it doesnt, 1 means it discovers, 2 means it "progresses"(TBA), 3 means it achieves, 4 means it completes and 5 means it botches (fails)
@export var progressionLevel: int = -1 ## only applicable if queststatus is 2. Only goes up cant go down. -1 means it does not do such things
@export var quest: Quest


@export var condition: Condition #not implemented yet
@export var condMode: int = -1 ##-1 nothing, 0 set to false, 1 set to true
