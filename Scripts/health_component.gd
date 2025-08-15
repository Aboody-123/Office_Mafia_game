extends Node2D
class_name HealthComponent

signal hurt
signal dead

@export var max_health = 100
var health = max_health

func _process(delta: float) -> void:
	#taking damage for testing purposes
	if Input.is_action_just_pressed("TakeDmg"):
		takeDamage(20)

# a function to deal with taking damage

func takeDamage(dam):
	health -= dam
	if (health <= 0):
		dead.emit()
	else:
		hurt.emit()
