
extends CharacterBody2D

var speed = 150.0
var dash = 1000.0
var dash_direction = 1
const JUMP_VELOCITY = -300.0
enum States { IDLE, WALKING, DASHING, JUMPING, FALLING }
var state = States.IDLE
var direction 
var gravity = 9
var jump_released = false
@onready var player_hitbox: CollisionShape2D = $CollisionShape2D


var dead = false

var can_dash = true
@onready var death_timer = $death_timer
@onready var death_panel: Control = $"Camera2D/DeathPanelCanvasLayer/Death Panel"


func _ready() -> void:
	death_panel.hide()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and state != States.DASHING:
		#cancels gravity while dashing
		velocity += get_gravity() * delta
		
	if state != States.DASHING:
		#while dashing you cannot change direction or cancel the dash early, fixes certain bugs
		handle_state_transitions()
	perform_state_actions(delta)
	move_and_slide()
	
	


func _on_health_component_hurt() -> void:
	print($HealthComponent.health)



func _on_health_component_dead() -> void:
	if (!dead):
		dead = true
		death_panel.visible = true
		Engine.time_scale = 0.5
		death_timer.start(1.5)
		

func handle_state_transitions():
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = States.JUMPING
		#only applies jump strength once
		velocity.y = JUMP_VELOCITY
	direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_released("jump") and jump_released == false:
		#cancels jump early when let go
		
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
		
	if Input.is_action_just_pressed("dash") and can_dash == true:
		state = States.DASHING
		velocity.x = dash * dash_direction
		#dash direction is the last direction moved by the player. this 
		#allows the player to dash even without directional inpot
		
		#timer controls length of dash
		$dash_timer.start()
		
		print("dash")
		can_dash = false
	
func perform_state_actions(delta):
	match state:
		States.IDLE:
			$AnimatedSprite2D.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)
		States.WALKING:
			$AnimatedSprite2D.play("walk")
			
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
				dash_direction = direction
			elif direction < 0:
				$AnimatedSprite2D.flip_h = true
				dash_direction = direction
			velocity.x = speed * direction
		
		States.JUMPING:
			pass
			#add animation
			
		States.FALLING:
			velocity += get_gravity() * delta
			#add animation
			
		States.DASHING:
			pass
			#add animation
		
	
func _on_dash_timer_timeout() -> void:
	
	$dash_cooldown.start()
	state = States.IDLE
	#stops the dash after the timer
	

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	#prevents spam dashing


func isPlayer():
	pass


func _on_death_timer_timeout() -> void:
	print(1)
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
