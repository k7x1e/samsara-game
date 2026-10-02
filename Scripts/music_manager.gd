extends AudioStreamPlayer

@export var playlists: Dictionary[String, Playlist]

@export var playlistIndex: int = 0
@export var currentQueue: Array[AudioStream]

func _ready() -> void:
	initalizePlayList("City",true)
	updateCurrent()

func initalizePlayList(index: String, fromNone: bool = false):
	currentQueue.clear()
	if !fromNone:
		var old = currentQueue.duplicate()
	
		currentQueue.append(old[playlistIndex])
		
		currentQueue.append(playlists[index].playlist.duplicate())
	else:
		currentQueue = playlists[index].playlist.duplicate()
	playlistIndex = 0

func _on_finished() -> void:
	playlistIndex += 1
	if playlistIndex == currentQueue.size():
		playlistIndex = 0
	updateCurrent()

func updateCurrent():
	print("Playing track ", playlistIndex, ", ", stream)
	stream = currentQueue[playlistIndex]
	play()
