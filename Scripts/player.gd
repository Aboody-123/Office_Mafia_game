extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# the states {0:idle, 1:walking/running, 2:attacking, 3:picking up
var state = 0
# where is it facing
var facingRight = true



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# left and right
	var direction := Input.get_axis("left", "right")
	
	if direction:
		if (direction == 1):
			facingRight = true
		else:
			facingRight = false
		velocity.x = direction * SPEED
		state = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# handles walking
		state = 0
	
	# flips the animation when neccessary
	if (facingRight):
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	# Plays animations when needed
	if (state == 1):
		$AnimatedSprite2D.play("walk")
	elif (state == 0):
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()


func _on_health_component_hurt() -> void:
	print($HealthComponent.health)



func _on_health_component_dead() -> void:
	print("dead")
