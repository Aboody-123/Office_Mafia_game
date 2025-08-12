extends CharacterBody2D

const speed = 50;

'''I need to find a way that it only follows the x direction of the player'''

enum States {IDLE, IDLEWALKING, FOLLOWING, HITTING, HURT, DEAD}
var state = 0;
var target = 0;
var facingLeft;
var attacking = false;
var player:CharacterBody2D;

@onready var nav = $NavigationAgent2D;

func _ready():
	state = States.IDLE;
	#$DamageComponent/CollisionShape2D.disabled = true
	
func _process(delta: float) -> void:
	stateMachine(delta)
	
	move_and_slide();
	
func stateMachine(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if (velocity.x <0):
		facingLeft = true;
	elif (velocity.x > 0):
		facingLeft = false;
	
	$AnimatedSprite2D.flip_h = !facingLeft;
	
	if (facingLeft):
		$InteractionComponent.position.x = -10
		$DamageComponent.position.x = -12
	else:
		$InteractionComponent.position.x = 10
		$DamageComponent.position.x = 12
		
	match (state):
		# if it is idle
		States.IDLE:
			$AnimatedSprite2D.play("IDLE");
		# milling about
		States.IDLEWALKING:
			$AnimatedSprite2D.play("run");
		# found the player and is following
		States.FOLLOWING:
			$AnimatedSprite2D.play("run");
			
			nav.target_position.x = player.position.x;
			nav.target_position.y = global_position.y;
			var next_path_position = nav.get_next_path_position();
			var direction = global_position.direction_to(next_path_position);
			velocity.x = direction.x * speed;
		# hitting the player
		
		States.HITTING:
			$AnimatedSprite2D.play("attack");
			if ($AnimatedSprite2D.frame == 2):
				attack();
			velocity.x = 0;
		
# attacks
func attack():
	$DamageComponent/CollisionShape2D.disabled = false
	$DisableDamageComponent.start(0.01)

# decides when the player is within range to attack]
func _on_search_component_found() -> void:
	state = States.FOLLOWING;
	player = $SearchComponent.player;


func _on_interaction_component_body_entered(body: Node2D) -> void:
	state = States.HITTING;
	
func _on_interaction_component_body_exited(body: Node2D) -> void:
	state = States.FOLLOWING;

# the timer runs out
func _on_disable_damage_component_timeout() -> void:
	$DamageComponent/CollisionShape2D.disabled = true
