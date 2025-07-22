extends Control

func _process(delta: float) -> void:
	#when escape is pressed then runs func pauseMenu
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


func pauseMenu():
	#if its paused already, then hide the menu
	if get_tree().paused == true:
		$CanvasLayer.hide()
		get_tree().paused = false
	#if its not paused then open the menu
	elif get_tree().paused == false:
		$CanvasLayer.show()
		get_tree().paused = true
		
func _on_resume_pressed() -> void:
	#when paused and resume is hit then unpauses
	pauseMenu()
	print("resume")
	
	
func _on_options_pressed() -> void:
	print("options")
	#fill in later
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()
	
