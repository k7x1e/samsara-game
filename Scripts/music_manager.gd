extends AudioStreamPlayer

@export var playlists: Dictionary[String, Playlist]
@export var currentPlaylist: Playlist

@export var playlistIndex: int = 0
@export var currentQueue: Array[song]

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
	if currentQueue:
		initalizePlayList(playlist)
	else:
		initalizePlayList(playlist,true)
	if immediate:
		#if currentPlaylist:
			#playlistIndex += 1
		updateCurrent(true,true)

func changeSong(Song: song, immediate: bool = false):
	print("DEPRECATED")
	return false
	#currentQueue.insert(playlistIndex+1, Song)
	#if immediate:
	#	playlistIndex += 1
	#	updateCurrent(true, true)

func initalizePlayList(index: String, fromNone: bool = false):
	currentPlaylist = playlists[index]
	var old = currentQueue.duplicate(true)
	currentQueue.clear()
	if !fromNone:
		#holy shit im retarded
		currentQueue.append(old[playlistIndex])
		
		currentQueue += currentPlaylist.playlist
		print("added said playlist to current.")
	else:
		currentQueue = currentPlaylist.playlist.duplicate(true)
		print("currentqueue should be not empty by now")
	playlistIndex = randi_range(1,currentQueue.size()-1)

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
		print("index: ", playlistIndex, " too high, falling back to 0")
		playlistIndex = 0
	var songsong = currentQueue[playlistIndex]
	if stream != songsong.audio:
		stream = songsong.audio
		#print("Playing track ", playlistIndex, ", ", stream)
		Globals.Root.nowPlaying(songsong.songName, str(songsong.artist,", ", songsong.album))
		play()
	else:
		print("same song, not changing.")

func tweenStop(duration: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -80.0, duration)
	await tween.finished
	volume_db = 0
	print("volume should be back now")
	return true
