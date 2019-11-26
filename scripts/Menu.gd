extends Control


func _on_TextureButton_pressed():
	pass # Replace with function body.


func _on_PlayBtn_pressed():
	$BGM.stop()
	$BtnClick.play()
	get_tree().change_scene("res://scenes/Level.tscn")
