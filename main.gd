extends Node


@export var mapP = preload("res://mapP.tscn")


var player1_startpos := Vector2(384, 544)
var player2_startpos := Vector2(1536, 544)
var current_map
var goals_p1 = 0
var goals_p2 = 0

func _ready():
	stop_game()
	current_map = mapP.instantiate()
	$Node2D.add_child(current_map)
	player1_startpos = $Node2D/StaticBody2D.get_player1_pos()
	player2_startpos = $Node2D/StaticBody2D.get_player2_pos()


func stop_game():
	pass


func reset_game():
	$Player1.position = player1_startpos
	$Player2.position = player2_startpos
	$Player1.reset()
	$Player2.reset()


func change_map(map_number):
	$Node2D/StaticBody2D.queue_free()
	match map_number:
		_:
			current_map = mapP.instantiate()


func _on_goal(goal, player):
	match goal:
		0:
			match player:
				0:
					goals_p2 += 2
				1:
					goals_p2 -= 1
		1: 
			match player:
				0:
					goals_p1 -= 1
				1:
					goals_p1 += 2
	$HUD.show_new_score(goals_p1, goals_p2)
	reset_game()
