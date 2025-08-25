extends Control

var diamonds = 0

func _on_player_update_diamond_counter() -> void:
	diamonds += 1
	#turn the label into a string and displays it
	$BoxContainer/VBoxContainer/Label.text = str("Diamonds:", diamonds)
	
