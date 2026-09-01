extends Resource

class_name ItemIdHandler

@export var usedArrays: Array[int] = [0]

func give_id(itemInQuestion: itemClass):
	if itemInQuestion:
		while itemInQuestion.UID == 0:
			var temp = randi()
			var result: int = 1  #0 means used
			for i in range(usedArrays.size()):
				if usedArrays[i] == temp and result != 0:
					result = 0
			if result == 1:
				itemInQuestion.UID = temp
				give_id_based_on_type(itemInQuestion, temp)
				usedArrays.append(temp)

func give_id_based_on_type(theItem: itemClass, id: int):
	match theItem.Type:
		"Spell":
			theItem.theSpell.parentItemUID = id
		"Item":
			pass
		_:
			print("item lacks type, UID not properly assigned to subitems")
