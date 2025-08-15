
extends CharacterBody2D

var speed = 150.0
const JUMP_VELOCITY = -300.0
var sprint = 200
# the states {0:idle, 1:walking/running, 2:attacking, 3:picking up
enum States { IDLE, WALKING, SPRINTING, JUMPING, FALLING }
var state = States.IDLE
var direction 
var gravity = 9
var jump_released = false

@onready var death_panel: Control = $"Camera2D2/CanvasLayer/Death Panel"




func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	handle_state_transitions()
	perform_state_actions(delta)
	move_and_slide()


func _on_health_component_hurt() -> void:
	print($HealthComponent.health)



func _on_health_component_dead() -> void:
	pass
	
func handle_state_transitions():
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = States.JUMPING
		#only applies jump strength once
		velocity.y = JUMP_VELOCITY
	direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_released("jump") and jump_released == false:
		#cancels jump early when let go
		velocity.y = 0
		state = States.FALLING
		#jump_released ensures that releasing jump only once will cancel the jump. 
		#otherwise when spammed it caused a floating bug
		jump_released = true
	if direction != 0:
		
		state = States.WALKING
		
	elif is_on_floor() and state != States.JUMPING:
		state = States.IDLE
		#resets jump_released so that you can still cancel jumps
		jump_released = false
		
	if Input.is_action_pressed("sprint") and direction:
		state = States.SPRINTING
	
func perform_state_actions(delta):
	match state:
		States.IDLE:
			$AnimatedSprite2D.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)
		States.WALKING:
			$AnimatedSprite2D.play("walk")
			
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
			elif direction < 0:
				$AnimatedSprite2D.flip_h = true
			velocity.x = speed * direction
		
		States.JUMPING:
			pass
			#add animation
			
		States.FALLING:
			pass
			#add animation
			
		States.SPRINTING:
			velocity.x = sprint * direction
			$AnimatedSprite2D.play("walk")
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
			elif direction < 0:
				$AnimatedSprite2D.flip_h = true
		
		
