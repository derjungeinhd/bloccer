extends Node


const MAPP_PATH = "res://maps/mapP.tscn"
const MAP1_PATH = "res://maps/map1.tscn"
const MAP2_PATH = "res://maps/map2.tscn"
const MAP3_PATH = "res://maps/map3.tscn"
const MAP4_PATH = "res://maps/map4.tscn"


var player1_startpos := Vector2(384, 544)
var player2_startpos := Vector2(1536, 544)
var goals_p1 = 0
var goals_p2 = 0
var is_game_running := false
var is_round_running := false
var maps = [MAPP_PATH, MAP1_PATH, MAP2_PATH, MAP3_PATH, MAP4_PATH]
var current_map
var loaded_map = preload(MAP1_PATH)
var max_stamina = 100
var stamina_player1 = max_stamina
var stamina_player2 = max_stamina
var goals_to_win = 10
var gamemode = 0


func _ready():
	stop_game()
	current_map = loaded_map.instantiate()
	$Node2D.add_child(current_map)
	player1_startpos = $Node2D/StaticBody2D.get_player1_pos()
	player2_startpos = $Node2D/StaticBody2D.get_player2_pos()


func _physics_process(_delta):
	$Player1.update(is_game_running, is_round_running)
	$Player2.update(is_game_running, is_round_running)
	$P1Goal.update(is_round_running)
	$P2Goal.update(is_round_running)
	stamina_player1 = $Player1.get_stamina()
	stamina_player2 = $Player2.get_stamina()
	$HUD.update(stamina_player1, stamina_player2, $Timer.get_time_left())


func stop_game():
	is_round_running = false
	is_game_running = false


func initiate_game(settings):
	print(settings)
	$Node2D.remove_child(current_map)
	ResourceLoader.load_threaded_request(maps[settings["map_number"]+1])
	loaded_map = ResourceLoader.load_threaded_get(maps[settings["map_number"]+1])
	current_map = loaded_map.instantiate()
	$Node2D.add_child(current_map)
	player1_startpos = $Node2D.get_child(-1).get_player1_pos()
	player2_startpos = $Node2D.get_child(-1).get_player2_pos()
	$Player1.position = player1_startpos
	$Player2.position = player2_startpos
	$Player1.apply_settings(settings)
	$Player2.apply_settings(settings)
	gamemode = settings["gamemode"]
	match settings["gamemode"]:
		0:
			goals_to_win = settings["gamelength"]
		1:
			$Timer.wait_time = settings["gamelength"]
	$HUD.reset_scores()
	$HUD/MainMenu/AnimationPlayer.play("stop_loading_panel")


func start_game():
	if gamemode == 1:
		$Timer.stop()
	is_round_running = false
	$Player1.position = player1_startpos
	$Player2.position = player2_startpos
	$Player1.reset()
	$Player2.reset()
	stamina_player1 = max_stamina
	stamina_player2 = max_stamina
	goals_p1 = 0
	goals_p2 = 0
	is_game_running = true


func reset_round():
	if gamemode == 1:
		$Timer.set_paused(true)
	is_round_running = false
	$Player1.position = player1_startpos
	$Player2.position = player2_startpos
	$Player1.reset()
	$Player2.reset()
	stamina_player1 = max_stamina
	stamina_player2 = max_stamina
	$HUD.start_countdown()


func _on_goal(goal, player):
	var goal_case
	match goal:
		0:
			match player:
				0:
					goals_p2 += 2
					goal_case = 1
				1:
					goals_p2 -= 1
					goal_case = 2
			#$GoalSoundP1.play()
		1: 
			match player:
				0:
					goals_p1 -= 1
					goal_case = 3
				1:
					goals_p1 += 2
					goal_case = 4
			#$GoalSoundP2.play()
	$HUD.show_new_score(goals_p1, goals_p2)
	$HUD.show_goal_status(goal_case)
	if goals_p1 >= goals_to_win && gamemode == 0:
		$HUD.show_winner(0)
		is_round_running = false
		is_game_running = false
	elif goals_p2 >= goals_to_win && gamemode == 0:
		$HUD.show_winner(1)
		is_round_running = false
		is_game_running = false
	else:
		reset_round()


func _on_countdown_ended():
	is_round_running = true
	if gamemode == 1:
		$Timer.set_paused(false)

func _on_countdownlong_ended():
	is_round_running = true
	if gamemode == 1:
		$Timer.start()
		$Timer.set_paused(false)

func _on_timer_timeout():
	if gamemode == 1:
		is_round_running = false
		is_game_running = false
		if goals_p1 > goals_p2:
			$HUD.show_winner(0)
		elif goals_p2 > goals_p1:
			$HUD.show_winner(1)
		elif goals_p1 == goals_p2:
			$HUD.show_remis()
