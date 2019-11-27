extends Area2D

export(int) var points = 1

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("collect"):
			body.collect(points)
			queue_free()
