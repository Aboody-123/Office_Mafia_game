extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


func pauseMenu():
	if get_tree().paused == true:
		$CanvasLayer.hide()
		get_tree().paused = false
		
	if get_tree().paused == false:
		$CanvasLayer.show()
		get_tree().paused = true
		
func _on_resume_pressed() -> void:
	pauseMenu()
	print("resume")
	
	
func _on_options_pressed() -> void:
	print("options")
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()
	
