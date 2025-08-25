extends Area2D



func _on_body_entered(body):
	#delete diamond
	queue_free()
	#runs the func add_diamond from the game_manager.
	%game_manager.add_diamond()
	
