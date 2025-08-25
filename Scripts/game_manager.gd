extends Node

var diamonds = 0
signal diamond_collected

func add_diamond():
	diamonds += 1
	#emitted to player to emit to UI
	diamond_collected.emit()
	
