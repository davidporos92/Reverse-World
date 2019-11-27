extends Node2D

signal health_changed(live_count)

const SIZE_ADULT = 2
const SIZE_MINI = 1

onready var player_container = {
	SIZE_ADULT: $Adult,
	SIZE_MINI: $Mini,
}
onready var max_size = player_container.keys().max()
onready var min_size = player_container.keys().min()
onready var size = max_size

var lives = 0
var last_hit = 0
var last_shrink = 0
var last_grow = 0
var wait_til_next_hit_msec = 1500
var wait_til_next_size_change_msec = 1500

func _on_Dino_shrink():
	if size <= min_size:
		return
	
	if OS.get_ticks_msec() - last_shrink < wait_til_next_size_change_msec:
		return
	
	last_shrink = OS.get_ticks_msec()
	
	var pos = player_container[size].position
	player_container[size].disable()
	size -= 1
	player_container[size].position = pos
	player_container[size].enable()

func _on_Dino_grow():
	if size >= max_size:
		return
	
	if OS.get_ticks_msec() - last_grow < wait_til_next_size_change_msec:
		return
	
	last_grow = OS.get_ticks_msec()
	
	var pos = player_container[size].position
	player_container[size].disable()
	size += 1
	player_container[size].position = pos
	player_container[size].enable()

func _on_Dino_hit(spawn_to_start):
	if OS.get_ticks_msec() - last_hit < wait_til_next_hit_msec:
		return
	
	last_hit = OS.get_ticks_msec()
	lives += 1
	emit_signal("health_changed", lives)
	if lives >= 3:
		game_over()
	
	if spawn_to_start:
		spawn_at_starting_position()

func _ready():
	$Adult.enable()
	$Mini.disable()
	spawn_at_starting_position()

func _physics_process(delta):
	$Camera2D.position = player_container[size].position

func spawn_at_starting_position():
	player_container[size].position = get_parent().get_node("StartingPosition").position

func win():
	get_tree().change_scene("res://scenes/Win.tscn")

func game_over():
	get_tree().change_scene("res://scenes/GameOver.tscn")
