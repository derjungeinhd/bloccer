extends CharacterBody2D


var speed := 2.0


const INITIALSPEED = 2.0


signal player1_hit
signal goal


func _physics_process(delta):
	#if Input.is_action_just_released("p2_ldash"):
	#	velocity.x = -1000
	#if Input.is_action_just_released("p2_rdash"):
	#	velocity.x = 1000
	#if Input.is_action_just_released("p2_udash"):
	#	velocity.y = -1000
	#if Input.is_action_just_released("p2_ddash"):
	#	velocity.y = 1000
	
	
	var rotation_direction = Vector2(Input.get_axis("p2_left", "p2_right"), Input.get_axis("p2_up", "p2_down"))
	if rotation_direction.x:
		rotate(deg_to_rad(540*delta*rotation_direction.x))
	elif rotation_direction.y:
		rotate(deg_to_rad(-540*delta*rotation_direction.y))
	
	
	var direction = Vector2(Input.get_axis("p2_left", "p2_right"), Input.get_axis("p2_up", "p2_down"))
	if direction != Vector2.ZERO:
		velocity += direction * speed
		if speed < 10:
			speed += 0.01
	else:
		velocity /= 1.01
	
	
	var collision_bool = move_and_slide()
	if collision_bool:
		var collider = get_last_slide_collision().get_collider()
		if collider.has_method("on_player_1_hit"):
			collider.on_player_1_hit(velocity)
		velocity = velocity.bounce(get_last_slide_collision().get_normal()) * 1.1
	
	
	if velocity.y > 5000:
		velocity.y = 5000
	if velocity.x > 5000:
		velocity.x = 5000
	if velocity.y < -5000:
		velocity.y = -5000
	if velocity.x < -5000:
		velocity.x = -5000


func on_player_2_hit(v):
	velocity += v * 1.1


func on_goal(goal):
	velocity = Vector2.ZERO
	emit_signal("goal", goal, 1)


func reset():
	velocity = Vector2.ZERO
	speed = INITIALSPEED
	rotation = 0
