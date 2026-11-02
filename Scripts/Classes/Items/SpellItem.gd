class_name itemSpell

extends itemClass

@export var theSpell: spell

func hello():
	print("hello")

func initializeStats():
	if "cost" in stats:
		theSpell.basecost = stats["cost"]
	if "cooldown" in stats:
		theSpell.basecoolDown = stats["cooldown"]
	theSpell.stats = stats
