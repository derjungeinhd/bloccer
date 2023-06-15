extends CharacterBody2D


@export var p2 = preload("res://player2.tscn")


var speed := 300.0


signal player2_hit


func _physics_process(delta):
	var rotation_direction = Input.get_axis("p1_left", "p1_right")
	
	
	if rotation_direction:
		rotate(deg_to_rad(180*delta*rotation_direction))
	else:
		pass
	
	
	var direction = Input.get_axis("p1_up", "p1_down")
	if direction:
		velocity = transform.y * direction * speed
		if speed < 1000:
			speed += 10
	else:
		velocity /= 1.01
		if speed > 300:
			speed = 300
	
	
	var collision_bool = move_and_slide()
	if collision_bool:
		var collider = get_last_slide_collision().get_collider()
		if collider.has_method("on_player_2_hit"):
			collider.on_player_2_hit(velocity)
		velocity = velocity.bounce(get_last_slide_collision().get_normal()) * 1.65
	
	
	if velocity.y > 5000:
		velocity.y = 5000
	if velocity.x > 5000:
		velocity.x = 5000
	if velocity.y < -5000:
		velocity.y = -5000
	if velocity.x < -5000:
		velocity.x = -5000


func on_player_1_hit(v):
	velocity += v * 1.3
