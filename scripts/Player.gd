extends KinematicBody2D

signal health_changed(live_count)

export(int) var speed = 600
export(int) var gravity = 50
export(int) var jump_power = -1000

const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var lives = 0

func move_left():
	velocity.x = -speed

func move_right():
	velocity.x = speed

func stay():
	velocity.x = 0

func jump():
	velocity.y = jump_power
	$Jump.play()

func add_health():
	lives += 1
	emit_signal("health_changed", lives)
	if lives >= 3:
		game_over()

func play_animation():
	if velocity.x < 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = true
			
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite.play("Run")
		else:
			$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Jump")

func win():
	get_tree().change_scene("res://scenes/Win.tscn")

func game_over():
	get_tree().change_scene("res://scenes/GameOver.tscn")

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		move_right()
	elif Input.is_action_pressed("ui_left"):
		move_left()
	else:
		stay()
	
	if Input.is_action_pressed("ui_up") && is_on_floor():
		add_health()
		jump()
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR)
	play_animation()
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Hole" in get_slide_collision(i).collider.name:
				win()
