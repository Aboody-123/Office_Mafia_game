extends Area2D

signal hit

@export var health:HealthComponent


# if a damage component enters it
func _on_area_entered(area: Area2D) -> void:
	if (area.has_method("isDamage")):
		health.takeDamage(area.damage)
		hit.emit()

func isHitbox():
	pass
