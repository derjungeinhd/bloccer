extends Area2D


func _on_body_entered(body):
	if body.has_method("on_goal"):
		body.on_goal(0)
