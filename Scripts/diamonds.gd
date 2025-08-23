extends Area2D

var diamond = 0

func _on_body_entered(body):
	print("+1 diamond")
	queue_free()
