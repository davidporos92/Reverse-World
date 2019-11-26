extends Control

func _on_NewGameBtn_pressed():
	$BtnClick.play()
	get_tree().change_scene("res://scenes/Level.tscn")
