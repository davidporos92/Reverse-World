extends KinematicBody2D

const GRAVITY = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var is_dead = false
var direction = 1

export(int, "Left", "Right") var start_direction
export(int) var speed = 350
export(Vector2) var size = Vector2(10, 10)

func _ready():
	scale = size
	$AnimatedSprite.play("Walk")
	if start_direction == 0:
		turn_around()

func kill():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("Dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

func _physics_process(delta):
	if is_dead:
		return
	
	velocity.x = speed * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		turn_around()
	
	if !$RayCast2D.is_colliding():
		print("Not colliding")
		turn_around()
	elif "Lava" in $RayCast2D.get_collider().name:
		print("Colliding with lava")
		turn_around()
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collider = get_slide_collision(i).collider
			if collider.has_method("ememy_hit"):
				collider.ememy_hit()
				kill()

func turn_around():
	direction *= -1
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	$RayCast2D.position.x *= -1

func _on_Timer_timeout():
	queue_free()
