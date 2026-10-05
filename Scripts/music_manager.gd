extends AudioStreamPlayer

@export var playlists: Dictionary[String, Playlist]
@export var currentPlaylist: Playlist

@export var playlistIndex: int = 0
@export var currentQueue: Array[AudioStream]

@export var tweenDuration: float = 1.0

#func _ready() -> void:
	#initalizePlayList("City",true)
	#updateCurrent()

func checkInteriorPlaylist(index: String):
	if playlists.has(index):
		return true
	else:
		return false

func changePlaylist(playlist: String, immediate: bool = false):
	if currentPlaylist:
		initalizePlayList(playlist)
	else:
		initalizePlayList(playlist,true)
	if immediate:
		if currentPlaylist:
			playlistIndex += 1
		updateCurrent(true,true)

func changeSong(song: AudioStream, immediate: bool = false):
	currentQueue.insert(playlistIndex+1, song)
	if immediate:
		playlistIndex += 1
		updateCurrent(true, true)

func initalizePlayList(index: String, fromNone: bool = false):
	currentPlaylist = playlists[index]
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

func updateCurrent(stopCurrent: bool = false, overrideWait: bool = false):
	if stopCurrent:
		await tweenStop(tweenDuration)
	if currentPlaylist.wait and !overrideWait:
		var temp = randf_range(currentPlaylist.minWait,currentPlaylist.maxWait)
		await get_tree().create_timer(temp).timeout
	if playlistIndex >= currentQueue.size():
		print("index too high, falling back to 0")
		playlistIndex = 0
	stream = currentQueue[playlistIndex]
	print("Playing track ", playlistIndex, ", ", stream)
	play()

func tweenStop(duration: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -80.0, duration)
	await tween.finished
	volume_db = 0
	print("volume should be back now")
	return true
