extends CharacterBody2D


var speed = 50
const JUMP_VELOCITY = -300.0

enum States {IDLE, FOLLOW, JUMP, ATTACK};
var state = States.IDLE;

# can it jump is it in position
var canJump = false;
# is it jumping
var jumping = false
# jump target
var jumpTarget = Vector2.ZERO;#
# attacking
var attacking = false
# navigation
@onready var nav_agent_walk = $WalkAgent;
@onready var nav_agent_jump = $JumpAgent;
# player to follow
var playerTarget:CharacterBody2D;

# is it facing left or right for animation purposes
var facingRight = false;

func _physics_process(delta: float):
	# states
	stateMachine();

	# succumbs to gravity
	if (!is_on_floor()):
		velocity += get_gravity() * delta
		
	# deals with facingRight
	if (velocity.x < 0):
		facingRight = false;
	elif(velocity.x > 0):
		facingRight = true;
	
	# deals with orientation is it looking left or right
	if (facingRight):
		$AnimatedSprite2D.flip_h = true
		$InteractionComponent/CollisionShape2D.position.x = 10
		$DamageComponent/CollisionShape2D.position.x = 14.0
	else:
		$AnimatedSprite2D.flip_h = false
		$InteractionComponent/CollisionShape2D.position.x = -10
		$DamageComponent/CollisionShape2D.position.x = -14.0
		
	# does jump and fall animations
	if (velocity.y < 0):
		$AnimatedSprite2D.play("jump")
	elif (velocity.y > 0):
		$AnimatedSprite2D.play("fall")
	
	move_and_slide()
	
func stateMachine():
	match state:
		# Idle
		States.IDLE:
			$AnimatedSprite2D.play("IDLE")
		
		# Following
		States.FOLLOW:
			$AnimatedSprite2D.play("run")
			# sets up nav_agent
			nav_agent_walk.target_position = playerTarget.position
			
			# sets up speed
			speed = 50
			
			if (attacking):
				state = States.ATTACK
			
			# basic following
			var next_path_position = nav_agent_walk.get_next_path_position()
			var direction = global_position.direction_to(next_path_position)
			
			# moves it in that direction
			if (direction.x < 0):
				velocity.x = -speed;
			elif (direction.x > 0):
				velocity.x = speed;
			else:
				velocity.x = 0
			
			# is it facing the correct direction to jump
			var indir = false;
			if (jumpTarget != Vector2.ZERO):
				if ((direction.x < 0 and !facingRight) or (direction.x > 0 and facingRight)):
					indir = true
				if (is_on_wall()):
					indir = true
				
			var willJump = jumpDecide(indir, next_path_position)
			
			# will it jump and activates everything needed
			if (willJump or jumping):
				canJump = false
				jumping = true
				state = States.JUMP
				if (is_on_floor()):
					velocity.y += JUMP_VELOCITY

			
			
		States.JUMP:
			nav_agent_jump.target_position = jumpTarget
			# speed
			speed = 200
			
			# is it nearing the end target
			if (int(position.x/10) == int(jumpTarget.x/10)):
				velocity.x = 20
			else:
				
				# following
				var next_path_position = nav_agent_jump.get_next_path_position()
				var direction = global_position.direction_to(next_path_position)
				
				# directions
				if (direction.x < 0):
					velocity.x = -speed;
				elif (direction.x > 0):
					velocity.x = speed;
				else:
					velocity.x = 0
				
				
			# it jhas reached its target
			if (nav_agent_jump.is_target_reached() or is_on_floor()):
				jumping = false
				jumpTarget = Vector2.ZERO
				state = States.FOLLOW
			
		# attacking the player
		States.ATTACK:
			velocity.x = 0
			$AnimatedSprite2D.play("attack")
			
			if (!attacking):
				state = States.FOLLOW
			
			if ($AnimatedSprite2D.frame == 2):
				$DamageComponent/CollisionShape2D.disabled = false
				$DamageTimer.start(0.2)
			
		
# is the guy gonna make the jump
func jumpDecide(inDirection, nextPos):
	if ((canJump) and (!jumping) and is_on_floor() and (nextPos.y < position.y - 5) and inDirection):
		return true
	else:
		return false


# if player found
func _on_search_component_found() -> void:
	playerTarget = $SearchComponent.player
	state = States.FOLLOW


func _on_interaction_component_body_entered(body: Node2D) -> void:
	if (body.has_method("isPlayer")):
		attacking = true
func _on_interaction_component_body_exited(body: Node2D) -> void:
	if (body.has_method("isPlayer")):
		attacking = false


func _on_damage_timer_timeout() -> void:
	$DamageComponent/CollisionShape2D.disabled = true
