extends KinematicBody2D

class_name Dino

signal play_sound(sound)
signal shrink()
signal grow()
signal hit(spawn_to_start)
signal win()
signal game_over()

export(int) var speed = 600
export(int) var gravity = 50
export(int) var jump_power = -1300
export(int) var death_below_y = 3000

const FLOOR = Vector2(0, -1)
const SOUND_JUMP = "Jump"
const SOUND_HIT = "Hit"
const SOUND_SHRINK = "Shrink"
const SOUND_GROW = "Grow"

var velocity = Vector2()
var enabled = false 
var points = 0

func enable():
	visible = true
	enabled = true
	for child in get_children():
		if "Collision" in child.name:
			child.set_deferred("disabled", false)

func disable():
	visible = false
	enabled = false
	for child in get_children():
		if "Collision" in child.name:
			child.set_deferred("disabled", true)

func move_left():
	$AnimatedSprite.flip_h = false
	velocity.x = -speed
	for child in get_children():
		if "Collision" in child.name && sign(child.scale.x) == -1:
			child.scale.x *= -1

func move_right():
	$AnimatedSprite.flip_h = true
	velocity.x = speed
	for child in get_children():
		if "Collision" in child.name && sign(child.scale.x) == 1:
			child.scale.x *= -1

func stay():
	velocity.x = 0

func jump():
	velocity.y = jump_power
	emit_signal("play_sound", SOUND_JUMP)

func hit(spawn_to_start):
	$AnimatedSprite.play("Jump")
	emit_signal("play_sound", SOUND_HIT)
	emit_signal("hit", spawn_to_start)

func play_animation():
	if is_on_floor():
		if abs(velocity.x) == speed:
			$AnimatedSprite.play("Run")
		else:
			$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Jump")

func _physics_process(delta):
	if !enabled:
		return
	
	if Input.is_action_pressed("ui_right"):
		move_right()
	elif Input.is_action_pressed("ui_left"):
		move_left()
	else:
		stay()
	
	if Input.is_action_pressed("action_jump") && is_on_floor():
		jump()
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR)
	play_animation()
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if "Hole" in collider.name:
				emit_signal("win")
				continue
			if "Enemy" in collider.name:
				ememy_hit()
				if collider.has_method("kill"):
					collider.kill()
				continue
			if collider is TileMap:
				var tile_pos = collider.world_to_map(position)
				tile_pos -= collision.normal
				var tile_id = collider.get_cellv(tile_pos)
				if tile_id == -1:
					tile_pos.y += 1
					tile_id = collider.get_cellv(tile_pos)
				if tile_id == -1:
					continue
				if "Lava" in collider.tile_set.tile_get_name(tile_id):
					hit(true)
				continue
	
	if position.y > death_below_y:
		emit_signal("game_over")

func collect(point):
	points += point

func shrink():
	emit_signal("shrink")
	emit_signal("play_sound", SOUND_SHRINK)

func ememy_hit():
	emit_signal("grow")
	emit_signal("play_sound", SOUND_GROW)
