extends Area2D

signal found
var player = 0;

func _on_body_entered(body: Node2D) -> void:
	if (body.has_method("isPlayer")):
		player = body
		found.emit()
