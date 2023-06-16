extends Area2D

var is_round_running = false

func _on_body_entered(body):
	if body.has_method("on_goal") && is_round_running:
		body.on_goal(0)


func update(round_state):
	is_round_running = round_state
