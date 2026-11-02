extends subBehaviour

class_name sayRandom

@export var minDelay: int = 90
@export var maxDelay: int = 1000
@export var delayCounter: int = 0
@export var delay: int = 1

@export var sayings: Array[String]

@export var duration: float = 3.0

var lastSaid: int = 0
var temp: int = 0

func tick(_behaviour: Behaviour):
	if delayCounter == delay:
		delayCounter = 0
		delay = randi_range(minDelay,maxDelay)
		temp = randi_range(0,sayings.size()-1)
		while temp == lastSaid:
			temp = randi_range(0,sayings.size()-1)
		_behaviour.say(sayings[temp], duration)
		lastSaid = temp
	else:
		delayCounter += 1
