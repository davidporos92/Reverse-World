extends KinematicBody2D

export(int) var speed = 600
export(int) var gravity = 50
export(int) var jump_power = -1000

const FLOOR = Vector2(0, -1)

var velocity = Vector2()

func move_left():
	velocity.x = -speed

func move_right():
	velocity.x = speed

func stay():
	velocity.x = 0

func jump():
	velocity.y = jump_power

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

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		move_right()
	elif Input.is_action_pressed("ui_left"):
		move_left()
	else:
		stay()
	
	if Input.is_action_pressed("ui_up") && is_on_floor():
		jump()
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR)
	
	play_animation()
