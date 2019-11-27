extends Node

func _on_play_sound(sound):
	match sound:
		Dino.SOUND_HIT:
			$Hit.play()
		Dino.SOUND_JUMP:
			$Jump.play()
		Dino.SOUND_GROW:
			$Grow.play()
		Dino.SOUND_SHRINK:
			$Shrink.play()
