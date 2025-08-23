extends Area2D

@onready var timer: Timer = $Timer
@onready var death_panel: Control = $"../Player/Camera2D2/CanvasLayer/Death Panel"

func _on_body_entered(body: Node2D) -> void:
	if (body.has_method("isPlayer")):
		print("wasted")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	death_panel.visible = true
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_player_killed() -> void:
	death_panel.visible = true
	Engine.time_scale = 0.5
	timer.start()
	
