extends subBehaviour

class_name sayRandom

@export var minDelay: int = 90
@export var maxDelay: int = 1000
@export var delayCounter: int = 0
@export var delay: int = 1

@export var sayings: Array[String]

@export var duration: float = 3.0

func tick(_behaviour: Behaviour):
	if delayCounter == delay:
		delayCounter = 0
		delay = randi_range(minDelay,maxDelay)
		
		_behaviour.say(sayings[randi_range(0,sayings.size()-1)], duration)
	else:
		delayCounter += 1
