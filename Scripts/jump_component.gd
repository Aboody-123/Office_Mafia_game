extends Area2D

var pos = 0
func _ready() -> void:
	pos = $A.global_position


func _on_body_entered(body: Node2D) -> void:
	if (!body.jumping):
		body.jumpTarget = pos
		body.canJump = true


func _on_body_exited(body: Node2D) -> void:
	if (!body.jumping):
		body.jumpTarget = Vector2.ZERO
		body.canJump = false
