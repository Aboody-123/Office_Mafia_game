extends Area2D

var level = 1



func _on_body_entered(body: Node2D) -> void:
		get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
		level += 1
		print("Now on level ")
		print(level)
		
