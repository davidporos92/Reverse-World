extends Area2D

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("shrink"):
			body.shrink()
			$CollisionShape2D.set_deferred("disabled", true)
			visible = false
			$Timer.start()


func _on_Timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
