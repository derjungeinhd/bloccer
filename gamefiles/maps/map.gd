class_name map
extends StaticBody2D


func get_player1_pos():
	return $P1Pos.position


func get_player2_pos():
	return $P2Pos.position


func fade_in_background_music():
	$MusicControl.play("fade_in")

func fade_out_background_music():
	$MusicControl.play("fade_out")

func fade_in_out_background_music():
	$MusicControl.play("fade_in_out")
