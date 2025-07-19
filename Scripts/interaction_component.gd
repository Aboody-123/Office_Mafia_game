extends Area2D

# 1=player 2=computer 3=npc
@export var type = 0

### Basically each function allows the thing to interact with another pbject
###


func _on_body_entered(body: Node2D) -> void:
	# so it does not react with the same thing 2 times
	if (body.global_position!=global_position):
		#if of the player entered
		if (body.has_method("isPlayer")):
			body.interact = true
			if (type == 3):
				body.nearNPC = true
			elif (type == 2):
				body.nearComp = true
		# npc
		elif (body.has_method("isNpc")):
			body.interact = true
			if (type == 1):
				body.nearPlayer = true
				
			if (type == 3):
				body.nearNPC = true
	


func _on_body_exited(body: Node2D) -> void:
	# so it does not react with the same thing 2 times
	if (body.global_position!=global_position):
		#if of the player exitted
		if (body.has_method("isPlayer")):
			body.interact = false
			if (type == 3):
				body.nearNPC = false
			elif (type == 2):
				body.nearComp = false
		# npc
		elif (body.has_method("isNpc")):
			body.interact = false
			if (type == 1):
				body.nearPlayer = false
				
			if (type == 3):
				body.nearNPC = false
