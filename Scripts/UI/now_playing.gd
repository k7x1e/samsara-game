extends Control

@onready var label2 = $HBoxContainer/VBoxContainer/SongName
@onready var label3 = $HBoxContainer/VBoxContainer/Album

@onready var anim = $AnimationPlayer

@export var songName: String = "Evil Ass Song"
@export var artistAlbum: String = "Evil Artist, Samsonarum OST"

func initialize():
	label2.text = songName
	label3.text = artistAlbum
	anim.play("nowplaying")
