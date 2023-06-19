extends CharacterBody2D


var initialspeed := 2.0
var max_speed := 10.0
var max_stamina = 100
var new_stamina = 0.6
var max_break_strength = 0.04
var max_boost_strength = 0.02


var speed := 2.0
var is_game_running = false
var is_round_running = false
var stamina = max_stamina
var need_stamina_recharge = false
var collision_shape
var collision_shape_type
var input_device
var vibration_enabled = true


signal player2_hit
signal goal


func _ready():
	collision_shape = $CircleCollisionShape2D
	collision_shape_type = 0
	$SquareCollisionShape2D.set_deferred("disabled", true)
	$SquareCollisionShape2D.hide()


func _physics_process(delta):
	if is_round_running:
		var rotation_direction = Vector2(Input.get_axis("p1_left", "p1_right"), Input.get_axis("p1_up", "p1_down"))
		if rotation_direction.x:
			rotate(deg_to_rad(540*delta*rotation_direction.x))
		elif rotation_direction.y:
			rotate(deg_to_rad(-540*delta*rotation_direction.y))
		
		
		var direction = Vector2(Input.get_axis("p1_left", "p1_right"), Input.get_axis("p1_up", "p1_down"))
		if direction != Vector2.ZERO:
			velocity += direction * speed
			if speed < max_speed:
				speed += 0.01
		else:
			velocity /= 1.01
		
		if stamina > 1 and not need_stamina_recharge:
			if Input.get_axis("null_axis" , "p1_break") >= 0.5:
				var break_strength = max_break_strength * Input.get_axis("null_axis" , "p1_break")
				velocity /= break_strength + 1
				stamina -= break_strength + 1
			if Input.get_axis("null_axis" , "p1_boost") >= 0.5:
				var boost_strength = max_boost_strength * Input.get_axis("null_axis" , "p1_boost")
				velocity *= boost_strength + 1
				stamina -= boost_strength + 1
		else:
			need_stamina_recharge = true
		
		
		velocity = check_velocity(velocity)
		
		
		var collision_bool = move_and_slide()
		if collision_bool:
			var collider = get_last_slide_collision().get_collider()
			if collider.has_method("on_player_2_hit"):
				collider.on_player_2_hit(velocity)
			velocity = velocity.bounce(get_last_slide_collision().get_normal()) * 1.1
			vibrate(0.3, 0, 0.1)
		
		stamina += new_stamina
		if stamina > max_stamina:
			stamina = max_stamina
			need_stamina_recharge = false
		
	velocity = check_velocity(velocity)

func check_velocity(v):
	if v.y > 5000:
		v.y = 5000
	if v.x > 5000:
		v.x = 5000
	if v.y < -5000:
		v.y = -5000
	if v.x < -5000:
		v.x = -5000
	return v


func on_player_1_hit(v):
	velocity += v * 1.1
	vibrate(0.5, 0, 0.1)


func on_goal(goal):
	is_round_running = false
	velocity = Vector2.ZERO
	emit_signal("goal", goal, 0)
	vibrate(1, 0, 0.2)


func reset():
	is_round_running = false
	velocity = Vector2.ZERO
	speed = initialspeed
	rotation = 0
	stamina = max_stamina
	collision_shape.set_deferred("disabled", false)


func update(game_state, round_state):
	is_game_running = game_state
	is_round_running = round_state


func get_stamina():
	return stamina

func stop_collision():
	collision_shape.set_deferred("disabled", true)


func switch_collision_shape(new_collision_shape_type):
	collision_shape.set_deferred("disabled", true)
	collision_shape.hide()
	match new_collision_shape_type:
		0:
			collision_shape = $CircleCollisionShape2D
		1:
			collision_shape = $SquareCollisionShape2D
	collision_shape.set_deferred("disabled", false)
	collision_shape.show()


func apply_settings(settings):
	initialspeed = settings["initialspeed"]
	max_speed = settings["max_speed"]
	max_stamina = settings["max_stamina"]
	new_stamina = settings["new_stamina"]
	max_break_strength = settings["max_break_strength"]
	max_boost_strength = settings["max_boost_strength"]
	var new_skin = settings["p1_skin"]
	match new_skin[0]:
		0:
			switch_collision_shape(0)
			$AnimatedSprite2D.animation = "circle"
			$AnimatedSprite2D.frame = new_skin[1]
		1:
			switch_collision_shape(1)
			$AnimatedSprite2D.animation = "square"
			$AnimatedSprite2D.frame = new_skin[1]


func vibrate(weak: float, strong: float, time: float):
	if vibration_enabled and input_device > 0:
		Input.start_joy_vibration(input_device - 1, weak, strong, time)


func _on_p1_set_input_device(i):
	input_device = i


func _on_vibration_changed(state):
	vibration_enabled = state
