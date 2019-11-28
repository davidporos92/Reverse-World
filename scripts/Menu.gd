extends Control

func _on_PlayBtn_pressed():
	$BGM.stop()
	$BtnClick.play()
	get_tree().change_scene("res://scenes/Level.tscn")
