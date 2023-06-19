extends Area2D


func _ready():
	randomize()


func _process(delta):
	randomize()
	$Bouncer
