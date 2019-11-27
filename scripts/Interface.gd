extends CanvasLayer

export(bool) var muted = false

onready var sound = $UI/MarginContainer/HBoxContainer/Buttons/Sound
onready var music = $BGM
onready var lives = $UI/MarginContainer/HBoxContainer/HBoxContainer/Lives

var img_unmuted = preload("res://images/buttons/unmuted.png")
var img_muted = preload("res://images/buttons/muted.png")
var lives_0 = preload("res://images/misc/lives_0.png")
var lives_1 = preload("res://images/misc/lives_1.png")
var lives_2 = preload("res://images/misc/lives_2.png")
var lives_3 = preload("res://images/misc/lives_3.png")
var is_ready = false

func _ready():
	is_ready = true

func mute():
	muted = true
	sound.texture_normal = img_muted
	music.stream_paused = true

func unmute():
	muted = false
	sound.texture_normal = img_unmuted
	music.stream_paused = false

func _on_Sound_pressed():
	if muted:
		unmute()
	else:
		mute()

func set_lives(live_count):
	match live_count:
		1:
			lives.texture = lives_1
		2:
			lives.texture = lives_2
		3:
			lives.texture = lives_3
		_:
			lives.texture = lives_0

func _on_Player_health_changed(live_count):
	set_lives(live_count)


func _on_Back_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
