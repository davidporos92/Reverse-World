extends Node2D

signal health_changed(live_count)

const SIZE_ADULT = 1
const SIZE_MINI = 0

onready var player_container = {
	SIZE_ADULT: $Adult,
	SIZE_MINI: $Mini,
}
onready var max_size = player_container.keys().max()
onready var min_size = player_container.keys().min()
export(int, "Mini", "Adult") var size

var lives = 0
var being_hit = false
var is_changing_size = false

func _on_Dino_shrink():
	if is_changing_size || size <= min_size:
		return
	
	is_changing_size = true
	
	var pos = player_container[size].position
	player_container[size].disable()
	size -= 1
	player_container[size].position = pos
	player_container[size].enable()
	
	is_changing_size = false

func _on_Dino_grow():
	if is_changing_size || size >= max_size:
		return
	
	is_changing_size = true
	
	var pos = player_container[size].position
	player_container[size].disable()
	size += 1
	player_container[size].position = pos
	player_container[size].enable()
	
	is_changing_size = false

func _on_Dino_hit(spawn_to_start):
	if being_hit:
		return
	
	being_hit = true
	
	lives += 1
	emit_signal("health_changed", lives)
	if lives >= 3:
		game_over()
	
	if spawn_to_start:
		spawn_at_starting_position()
	
	being_hit = false

func _ready():
	for p in player_container:
		if size == p:
			player_container[p].enable()
		else:
			player_container[p].disable()
	spawn_at_starting_position()

func _physics_process(delta):
	$Camera2D.position = player_container[size].position

func spawn_at_starting_position():
	player_container[size].position = get_parent().get_node("StartingPosition").position

func win():
	get_tree().change_scene("res://scenes/Win.tscn")

func game_over():
	get_tree().change_scene("res://scenes/GameOver.tscn")
