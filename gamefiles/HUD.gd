extends CanvasLayer
class_name HUD


var p1_need_stamina_recharge = false
var p2_need_stamina_recharge = false
var is_on_start_screen = true
var map_count = 0
var map_names = ["Fußballfeld", "Turnhalle", "Tennisplatz", "Basketballplatz", "Pong"]
var p1_choose_input = false
var p2_choose_input = false
var p1_actions = ["p1_up", "p1_down", "p1_left", "p1_right", "p1_item", "p1_break", "p1_boost"]
var p2_actions = ["p2_up", "p2_down", "p2_left", "p2_right", "p2_item", "p2_break", "p2_boost"]
var keyboard_is_used = false
var gamepad1_is_used = false
var gamepad2_is_used = false
var p1_skin = [0, 0]
var p2_skin = [0, 1]
var circle_skins_count = 12
var square_skins_count = 5
var circle_skin_names = ["Fußball", "Basketball", "Tennisball", "Billiardkugel", "Strandball", "Volleyball", "Schneeball", "Uhr", "Planet", "Blupp (Rot)", "Blupp (Gelb)", "Blupp (Blau)", "Blupp (Grün)"]
var square_skin_names = ["Holzkiste", "Lautsprecher", "Schatztruhe", "Paket", "Würfel", "Fenster",]
var p1_ready = false
var p2_ready = false
var start_initiated = false
var settings := {
	"gamemode": 0,
	"gamelength": 10,
	"max_break_strength": 0.04,
	"max_boost_strength": 0.02,
	"initialspeed" : 2.0,
	"max_speed" : 10.0,
	"max_stamina" : 100,
	"new_stamina" : 0.6,
	"map_number": map_count,
	"p1_skin": p1_skin,
	"p2_skin": p2_skin,
}
var is_userspecified = false
var load_type := 0
var is_in_options = false
var options_tab = 0
var window_size
var screen_size
var screen = 0
var displaymode = 2
var is_pc
var vibration_enabled = true


signal countdown_short_ended
signal countdown_long_ended
signal initiate_game
signal start_game
signal p1_set_input_device
signal p2_set_input_device
signal vibration_changed
signal game_over


#------------------------------------------------------------------------------------------------------------------------------
#
# system functions
#
#------------------------------------------------------------------------------------------------------------------------------


func _ready():
	initiate_display_server()
	$MainMenu/Panel/AnimationPlayer.play("pre_start_animation")


func _input(event):
	if is_on_start_screen:
		if event is InputEventJoypadButton || event is InputEventKey:
			$MainMenu/Panel/AnimationPlayer.play("start_animation")
			is_on_start_screen = false
			$MainMenu/StartGame.play()
	if p1_choose_input:
		if event is InputEventJoypadButton && event.get_device() == 0:
			for i in range(p1_actions.size()):
				InputMap.action_erase_events(p1_actions[i])
				InputMap.action_add_event(p1_actions[i], InputMap.action_get_events("default_gamepad1_inputs")[i])
				if i < 4:
					InputMap.action_add_event(p1_actions[i], InputMap.action_get_events("gp1_dpad")[i])
			set_input(0, 1)
		elif event is InputEventJoypadButton && event.get_device() == 1:
			for i in range(p1_actions.size()):
				InputMap.action_erase_events(p1_actions[i])
				InputMap.action_add_event(p1_actions[i], InputMap.action_get_events("default_gamepad2_inputs")[i])
				if i < 4:
					InputMap.action_add_event(p1_actions[i], InputMap.action_get_events("gp2_dpad")[i])
			set_input(0, 2)
		elif event is InputEventKey:
			for i in range(p1_actions.size()):
				InputMap.action_erase_events(p1_actions[i])
				InputMap.action_add_event(p1_actions[i], InputMap.action_get_events("default_keyboard_inputs")[i])
			set_input(0, 0)
	if p2_choose_input:
		if event is InputEventJoypadButton && event.get_device() == 0 && !gamepad1_is_used:
			for i in range(p2_actions.size()):
				InputMap.action_erase_events(p2_actions[i])
				InputMap.action_add_event(p2_actions[i], InputMap.action_get_events("default_gamepad1_inputs")[i])
				if i < 4:
					InputMap.action_add_event(p2_actions[i], InputMap.action_get_events("gp1_dpad")[i])
			set_input(1, 1)
		elif event is InputEventJoypadButton && event.get_device() == 1 && !gamepad2_is_used:
			for i in range(p2_actions.size()):
				InputMap.action_erase_events(p2_actions[i])
				InputMap.action_add_event(p2_actions[i], InputMap.action_get_events("default_gamepad2_inputs")[i])
				if i < 4:
					InputMap.action_add_event(p2_actions[i], InputMap.action_get_events("gp2_dpad")[i])
			set_input(1, 2)
		elif event is InputEventKey && !keyboard_is_used:
			for i in range(p2_actions.size()):
				InputMap.action_erase_events(p2_actions[i])
				InputMap.action_add_event(p2_actions[i], InputMap.action_get_events("default_keyboard_inputs")[i])
			set_input(1, 0)
	if is_in_options:
		if event.is_action_released("prev_tab"):
			options_tab -= 1
			if options_tab < 0:
				options_tab = 3
			$Options/TabContainer.current_tab = options_tab
			await get_tree().create_timer(0.1).timeout
			match options_tab:
				0:
					resolution_option.grab_focus()
				1:
					$Options/TabContainer/Audio/Master/VBoxContainer/HSlider.grab_focus()
				2:
					$Options/TabContainer/Steuerung/Vibration.grab_focus()
				3:
					$Options/TabContainer/Info/LinkToGithub.grab_focus()
		elif event.is_action_released("next_tab"):
			options_tab += 1
			if options_tab > 3:
				options_tab = 0
			$Options/TabContainer.current_tab = options_tab
			await get_tree().create_timer(0.1).timeout
			match options_tab:
				0:
					resolution_option.grab_focus()
				1:
					$Options/TabContainer/Audio/Master/VBoxContainer/HSlider.grab_focus()
				2:
					$Options/TabContainer/Steuerung/Vibration.grab_focus()
				3:
					$Options/TabContainer/Info/LinkToGithub.grab_focus()


#------------------------------------------------------------------------------------------------------------------------------
#
# general functions
#
#------------------------------------------------------------------------------------------------------------------------------


func show_new_score(goals_p1, goals_p2):
	$Overlay/ScoreContainer/Score.text = str(goals_p1) + " : " + str(goals_p2)


func reset_scores():
	$Overlay/ScoreContainer/Score.text = "0 : 0"
	$Overlay/LastGoal.hide()
	$Overlay/LastGoal2.hide()


func show_goal_status(case):
	match case:
		1:
			$Overlay/LastGoal.hide()
			$Overlay/LastGoal2.text = "+2"
			$Overlay/LastGoal2.show()
		2:
			$Overlay/LastGoal.hide()
			$Overlay/LastGoal2.text = "-1"
			$Overlay/LastGoal2.show()
		3:
			$Overlay/LastGoal2.hide()
			$Overlay/LastGoal.text = "-1"
			$Overlay/LastGoal.show()
		4:
			$Overlay/LastGoal2.hide()
			$Overlay/LastGoal.text = "+2"
			$Overlay/LastGoal.show()


#------------------------------------------------------------------------------------------------------------------------------


func start_countdown():
	await get_tree().create_timer(0.2).timeout
	
	
	p1_need_stamina_recharge = false
	$Overlay/StaminaP1Panel.hide()
	$Overlay/StaminaP1Panel2.hide()
	p2_need_stamina_recharge = false
	$Overlay/StaminaP2Panel.hide()
	$Overlay/StaminaP2Panel2.hide()
	
	
	$Overlay/CountdownShort.play()
	$Overlay/MainLabelContainer/MainLabel.show()
	$Overlay/MainLabelContainer/MainLabel.text = "3"
	vibrate(0.5, 0, 0.1)
	await get_tree().create_timer(0.3).timeout
	$Overlay/MainLabelContainer/MainLabel.text = "2"
	vibrate(0.5, 0, 0.1)
	await get_tree().create_timer(0.3).timeout
	$Overlay/MainLabelContainer/MainLabel.text = "1"
	vibrate(0.5, 0, 0.1)
	await get_tree().create_timer(0.3).timeout
	$Overlay/MainLabelContainer/MainLabel.text = "GO!"
	vibrate(0.5, 1, 0.1)
	emit_signal("countdown_short_ended")
	await get_tree().create_timer(0.3).timeout
	$Overlay/MainLabelContainer/MainLabel.text = ""
	$Overlay/MainLabelContainer/MainLabel.hide()


func start_countdownlong():
	p1_need_stamina_recharge = false
	$Overlay/StaminaP1Panel.hide()
	$Overlay/StaminaP1Panel2.hide()
	p2_need_stamina_recharge = false
	$Overlay/StaminaP2Panel.hide()
	$Overlay/StaminaP2Panel2.hide()
	
	
	$Overlay/CountdownLong.play()
	$Overlay/MainLabelContainer/MainLabel.show()
	$Overlay/MainLabelContainer/MainLabel.text = "3"
	vibrate(0.5, 0, 0.2)
	await get_tree().create_timer(0.7).timeout
	$Overlay/MainLabelContainer/MainLabel.text = "2"
	vibrate(0.5, 0, 0.2)
	await get_tree().create_timer(0.7).timeout
	$Overlay/MainLabelContainer/MainLabel.text = "1"
	vibrate(0.5, 0, 0.2)
	await get_tree().create_timer(0.7).timeout
	$Overlay/MainLabelContainer/MainLabel.text = "GO!"
	vibrate(0.5, 1, 0.2)
	emit_signal("countdown_long_ended")
	await get_tree().create_timer(0.3).timeout
	$Overlay/MainLabelContainer/MainLabel.text = ""
	$Overlay/MainLabelContainer/MainLabel.hide()


#------------------------------------------------------------------------------------------------------------------------------


func update(stamina_p1, stamina_p2, time_left):
	$Overlay/StaminaP1.value = stamina_p1
	$Overlay/StaminaP2.value = stamina_p2
	
	
	if stamina_p1 > settings["max_stamina"] - 1 and p1_need_stamina_recharge:
		p1_need_stamina_recharge = false
		$Overlay/StaminaP1Panel.hide()
		$Overlay/StaminaP1Panel2.hide()
	elif stamina_p1 > 20 and not p1_need_stamina_recharge:
		$Overlay/StaminaP1Panel.hide()
		$Overlay/StaminaP1Panel2.hide()
	elif stamina_p1 > 1 and not p1_need_stamina_recharge:
		$Overlay/StaminaP1Panel.show()
		$Overlay/StaminaP1Panel2.hide()
	elif stamina_p1 < 1 and not p1_need_stamina_recharge:
		p1_need_stamina_recharge = true
		$Overlay/StaminaP1Panel.hide()
		$Overlay/StaminaP1Panel2.show()
	
	
	if stamina_p2 > settings["max_stamina"] - 1 and p2_need_stamina_recharge:
		p2_need_stamina_recharge = false
		$Overlay/StaminaP2Panel.hide()
		$Overlay/StaminaP2Panel2.hide()
	elif stamina_p2 > 20 and not p2_need_stamina_recharge:
		$Overlay/StaminaP2Panel.hide()
		$Overlay/StaminaP2Panel2.hide()
	elif stamina_p2 > 1 and not p2_need_stamina_recharge:
		$Overlay/StaminaP2Panel.show()
		$Overlay/StaminaP2Panel2.hide()
	elif stamina_p2 <= 1 and not p2_need_stamina_recharge:
		p1_need_stamina_recharge = true
		$Overlay/StaminaP2Panel.hide()
		$Overlay/StaminaP2Panel2.show()
	
	if settings["gamemode"] == 1:
		var min = time_left / 60
		var sec = fmod(time_left, 60)
		$Overlay/TimeContainer/Time.text = "%d:%02d" % [min, sec]


func show_winner(winner):
	vibrate(1, 1, 0.5)
	match winner:
		0:
			$Overlay/GameEndUI/WinnerLabelContainer/WinnerLabel.text = "Spieler 1\n gewinnt!"
			match p1_skin[0]:
				0:
					$Overlay/GameEndUI/AnimatedSprite2D.animation = "circle"
					$Overlay/GameEndUI/AnimatedSprite2D.frame = p1_skin[1]
				1:
					$Overlay/GameEndUI/AnimatedSprite2D.animation = "square"
					$Overlay/GameEndUI/AnimatedSprite2D.frame = p1_skin[1]
			$Overlay/AnimationPlayer.play("p1_won")
		1:
			$Overlay/GameEndUI/WinnerLabelContainer/WinnerLabel.text = "Spieler 2\n gewinnt!"
			match p2_skin[0]:
				0:
					$Overlay/GameEndUI/AnimatedSprite2D.animation = "circle"
					$Overlay/GameEndUI/AnimatedSprite2D.frame = p2_skin[1]
				1:
					$Overlay/GameEndUI/AnimatedSprite2D.animation = "square"
					$Overlay/GameEndUI/AnimatedSprite2D.frame = p2_skin[1]
			$Overlay/AnimationPlayer.play("p2_won")


func show_remis():
	vibrate(1, 1, 0.5)
	$Overlay/AnimationPlayer.play("remis")


#------------------------------------------------------------------------------------------------------------------------------


func _on_focus_changed():
	$MainMenu/MenuSelect.play(0.0)


#------------------------------------------------------------------------------------------------------------------------------


func prepare_game():
	$MainMenu/MenuAccept.play(0.0)
	$MainMenu/Preparations/GameSettings.hide()
	$MainMenu/Preparations/MapSettings.show()
	$MainMenu/Preparations/PlayerSettings.hide()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseInputLabel.show()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseInputLabel.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin.hide()
	$MainMenu/AnimationPlayer.play("play_nav_to_preperations")
	is_userspecified = false


func set_input(player, input_device):
	match player:
		0:
			p1_choose_input = false
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseInputLabel.hide()
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin.show()
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseInputLabel.show()
			p2_choose_input = true
			emit_signal("p1_set_input_device", input_device)
			match input_device:
				0:
					keyboard_is_used = true
					gamepad1_is_used = false
					gamepad2_is_used = false
				1:
					keyboard_is_used = false
					gamepad1_is_used = true
					gamepad2_is_used = false
				2:
					keyboard_is_used = false
					gamepad1_is_used = false
					gamepad2_is_used = true
			$MainMenu/MenuAccept.play(0.0)
			await get_tree().create_timer(1.0).timeout
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/ReadyButton.disabled = false
		1:
			p2_choose_input = false
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseInputLabel.hide()
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin.show()
			emit_signal("p2_set_input_device", input_device)
			match input_device:
				0:
					keyboard_is_used = true
				1:
					gamepad1_is_used = true
				2:
					gamepad2_is_used = true
			$MainMenu/Preparations/PlayerSettings/VersusLabel.show()
			$MainMenu/MenuAccept.play(0.0)
			await get_tree().create_timer(1.0).timeout
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/ReadyButton.disabled = false


func init_game():
		$Overlay/CountdownShort.play(0.0)
		$MainMenu/Preparations/PlayerSettings/VersusLabel.text = "3"
		vibrate(0.5, 0, 0.1)
		await get_tree().create_timer(0.3).timeout
		$MainMenu/Preparations/PlayerSettings/VersusLabel.text = "2"
		vibrate(0.5, 0, 0.1)
		await get_tree().create_timer(0.3).timeout
		$MainMenu/Preparations/PlayerSettings/VersusLabel.text = "1"
		vibrate(0.5, 0, 0.1)
		await get_tree().create_timer(0.3).timeout
		$MainMenu/Preparations/PlayerSettings/VersusLabel.text = "GO!"
		vibrate(0.5, 1, 0.1)
		await get_tree().create_timer(0.3).timeout
		settings["p1_skin"] = p1_skin
		settings["p2_skin"] = p2_skin
		if settings["gamemode"] == 1 and settings["gamelength"] == 345:
			if settings["p1_skin"] == [1, 3] and settings["p2_skin"] == [0, 5]:
				settings["map_number"] = -1
			elif settings["p1_skin"] == [0, 5] and settings["p2_skin"] == [1, 3]:
				settings["map_number"] = -1
		else:
			settings["map_number"] = map_count
		load_type = 0
		$MainMenu/AnimationPlayer.play("start_loading_panel")
		$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/CPUParticles2D.emitting = false
		$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/CPUParticles2D.emitting = false
		p1_ready = false
		p2_ready = false
		if settings["gamemode"] == 1:
			$Overlay/TimeContainer/Time.show()
			var min = settings["gamelength"] / 60
			var sec = fmod(settings["gamelength"], 60)
			$Overlay/TimeContainer/Time.text = "%d:%02d" % [min, sec]
		else:
			$Overlay/TimeContainer/Time.hide()


func vibrate(weak: float, strong: float, time: float):
	if vibration_enabled:
		if gamepad1_is_used:
			Input.start_joy_vibration(0, weak, strong, time)
		if gamepad2_is_used:
			Input.start_joy_vibration(1, weak, strong, time)


#------------------------------------------------------------------------------------------------------------------------------
#
# video functions
#
#------------------------------------------------------------------------------------------------------------------------------


@onready var resolution_option = $Options/TabContainer/Video/VBoxContainer/Resolution/OptionButton
@onready var displaymode_option = $Options/TabContainer/Video/VBoxContainer/Displaymode/OptionButton
@onready var screen_option = $Options/TabContainer/Video/VBoxContainer/Screen/VBoxContainer/HSlider
@onready var screen_label = $Options/TabContainer/Video/VBoxContainer/Screen/Label
@onready var vsync_option = $"Options/TabContainer/Video/VBoxContainer/V-Sync/OptionButton"
@onready var resolution_container = $Options/TabContainer/Video/VBoxContainer/Resolution
@onready var resolution_seperator = $Options/TabContainer/Video/VBoxContainer/HSeparator
@onready var displaymode_container = $Options/TabContainer/Video/VBoxContainer/Displaymode
@onready var displaymode_seperator = $Options/TabContainer/Video/VBoxContainer/HSeparator2
@onready var screen_container = $Options/TabContainer/Video/VBoxContainer/Screen
@onready var screen_seperator = $Options/TabContainer/Video/VBoxContainer/HSeparator3
@onready var vsync_container = $"Options/TabContainer/Video/VBoxContainer/V-Sync"


func initiate_display_server():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	if DisplayServer.get_name() == "Windows" or DisplayServer.get_name() == "X11":
		is_pc = true
		change_video_settings_visibility(true, true, true, true)
		screen = DisplayServer.get_primary_screen()
		DisplayServer.window_set_current_screen(screen)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		screen_size = DisplayServer.screen_get_size(screen)
		window_size = DisplayServer.window_get_size()
		resolution_option.disabled = true
		resolution_option.select(0)
		check_resolutions()
	else:
		is_pc = false
		change_video_settings_visibility(false, false, false, true)


func change_video_settings_visibility(res: bool, dis: bool, scr: bool, vsy: bool):
	if res:
		resolution_container.show()
		resolution_seperator.show()
	else:
		resolution_container.hide()
		resolution_seperator.hide()
	
	
	if dis:
		displaymode_container.show()
		displaymode_seperator.show()
	else:
		displaymode_container.hide()
		displaymode_seperator.hide()
	
	
	if scr:
		screen_container.show()
		screen_seperator.show()
	else:
		screen_container.hide()
		screen_seperator.hide()
	
	
	if vsy:
		vsync_container.show()
	else:
		vsync_container.hide()


func check_resolutions():
	screen_option.set_max(DisplayServer.get_screen_count()-1)
	screen_option.value = screen
	
	if screen_size.x < 960 or screen_size.y < 540:
		resolution_option.select(0)
		resolution_option.disabled = true
	elif screen_size.x < 1280 or screen_size.y < 720:
		resolution_option.set_item_disabled(1, true)
		resolution_option.set_item_disabled(2, true)
		resolution_option.set_item_disabled(3, true)
		resolution_option.set_item_disabled(4, true)
		resolution_option.set_item_disabled(5, true)
		resolution_option.set_item_disabled(6, false)
	elif screen_size.x < 1600 or screen_size.y < 900:
		resolution_option.set_item_disabled(1, true)
		resolution_option.set_item_disabled(2, true)
		resolution_option.set_item_disabled(3, true)
		resolution_option.set_item_disabled(4, true)
		resolution_option.set_item_disabled(5, false)
		resolution_option.set_item_disabled(6, false)
	elif screen_size.x < 1920 or screen_size.y < 1080:
		resolution_option.set_item_disabled(1, true)
		resolution_option.set_item_disabled(2, true)
		resolution_option.set_item_disabled(3, true)
		resolution_option.set_item_disabled(4, false)
		resolution_option.set_item_disabled(5, false)
		resolution_option.set_item_disabled(6, false)
	elif screen_size.x < 2560 or screen_size.y < 1440:
		resolution_option.set_item_disabled(1, true)
		resolution_option.set_item_disabled(2, true)
		resolution_option.set_item_disabled(3, false)
		resolution_option.set_item_disabled(4, false)
		resolution_option.set_item_disabled(5, false)
		resolution_option.set_item_disabled(6, false)
	elif screen_size.x < 3840 or screen_size.y < 2160:
		resolution_option.set_item_disabled(1, true)
		resolution_option.set_item_disabled(2, false)
		resolution_option.set_item_disabled(3, false)
		resolution_option.set_item_disabled(4, false)
		resolution_option.set_item_disabled(5, false)
		resolution_option.set_item_disabled(6, false)
	else:
		resolution_option.set_item_disabled(1, false)
		resolution_option.set_item_disabled(2, false)
		resolution_option.set_item_disabled(3, false)
		resolution_option.set_item_disabled(4, false)
		resolution_option.set_item_disabled(5, false)
		resolution_option.set_item_disabled(6, false)


func set_window_pos_and_size(size):
	DisplayServer.window_set_size(size)
	if screen_size == size:
		_on_displaymode_selected(2)
	else:
		DisplayServer.window_set_position(Vector2(DisplayServer.screen_get_position()) + screen_size * 0.5 - size * 0.5)


func _on_displaymode_selected(index):
	resolution_option.select(0)
	screen_size = DisplayServer.screen_get_size(screen)
	displaymode = index
	match index:
		0:
			resolution_option.disabled = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(screen_size*0.5)
			DisplayServer.window_set_position(screen_size*0.25)
		1:
			resolution_option.disabled = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_size(screen_size*0.5)
			DisplayServer.window_set_position(screen_size*0.25)
		2:
			resolution_option.disabled = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		3:
			resolution_option.disabled = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	DisplayServer.window_set_current_screen(screen)
	window_size = DisplayServer.window_get_size()
	check_resolutions()


func _on_resolution_selected(index):
	screen_size = DisplayServer.screen_get_size(screen)
	window_size = DisplayServer.window_get_size()
	match index:
		0:
			DisplayServer.window_set_size(screen_size*0.5)
			DisplayServer.window_set_position(screen_size*0.25)
		1:
			set_window_pos_and_size(Vector2i(3840, 2160))
		2:
			set_window_pos_and_size(Vector2i(2560, 1440))
		3:
			set_window_pos_and_size(Vector2i(1920, 1080))
		4:
			set_window_pos_and_size(Vector2i(1600, 900))
		5:
			set_window_pos_and_size(Vector2i(1280, 720))
		6:
			set_window_pos_and_size(Vector2i(960, 540))
	DisplayServer.window_set_current_screen(screen)


func _on_screen_changed(value):
	screen = value
	DisplayServer.window_set_current_screen(screen)
	displaymode_option.select(0)
	_on_displaymode_selected(0)


func _on_v_sync_selected(index):
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)


#------------------------------------------------------------------------------------------------------------------------------
#
# button inputs
#
#------------------------------------------------------------------------------------------------------------------------------


func _on_play_pressed():
	$MainMenu/MenuAccept.play(0.0)
	$MainMenu/Panel/MainNavigation/Play.release_focus()
	$MainMenu/Panel/AnimationPlayer.play("switch_main_and_play_nav")


func _on_options_pressed():
	$MainMenu/MenuAccept.play(0.0)
	$MainMenu/Panel/MainNavigation/Options.release_focus()
	$Options.show()
	$Options/AnimationPlayer.play("start_nav_to_options")
	options_tab = 0
	$Options/TabContainer.current_tab = options_tab
	var master_bus_volume = snapped(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")), 0.1)
	var sfx_bus_volume = snapped(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Soundeffects")), 0.1)
	var music_bus_volume = snapped(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")), 0.1)
	var menu_sfx_bus_volume = snapped(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MenuSFX")), 0.1)
	if master_bus_volume == -50:
		$Options/TabContainer/Audio/Master/Label.text = "Allgemein: Stumm"
	else:
		$Options/TabContainer/Audio/Master/Label.text = "Allgemein: " + str((master_bus_volume * 2) + 100) + "%"
	if master_bus_volume == -50:
		$Options/TabContainer/Audio/SFX/Label.text = "Soundeffekte: Stumm"
	else:
		$Options/TabContainer/Audio/SFX/Label.text = "Soundeffekte: " + str((sfx_bus_volume * 2) + 100) + "%"
	if master_bus_volume == -50:
		$Options/TabContainer/Audio/Music/Label.text = "Musik: Stumm"
	else:
		$Options/TabContainer/Audio/Music/Label.text = "Musik: " + str((music_bus_volume * 2) + 100) + "%"
	if master_bus_volume == -50:
		$Options/TabContainer/Audio/MenuSFX/Label.text = "Menu: Stumm"
	else:
		$Options/TabContainer/Audio/MenuSFX/Label.text = "Menu: " + str((menu_sfx_bus_volume * 2) + 100) + "%"
	$Options/TabContainer/Audio/Master/VBoxContainer/HSlider.value = master_bus_volume
	$Options/TabContainer/Audio/SFX/VBoxContainer/HSlider.value = sfx_bus_volume
	$Options/TabContainer/Audio/Music/VBoxContainer/HSlider.value = music_bus_volume
	$Options/TabContainer/Audio/MenuSFX/VBoxContainer/HSlider.value = menu_sfx_bus_volume


func _on_quit_game_pressed():
	$MainMenu/Panel/MainNavigation/QuitGame.release_focus()
	$MainMenu/Panel/MainNavigation/QuitGame.disabled = true
	$MainMenu/MenuDeny.play(0.0)
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


#------------------------------------------------------------------------------------------------------------------------------


func _on_classic_pressed():
	$MainMenu/Panel/PlayNavigation/Back.disabled = true
	$MainMenu/Panel/PlayNavigation/Classic.release_focus()
	settings = {
		"gamemode": 0,
		"gamelength": 10,
		"max_break_strength": 0.04,
		"max_boost_strength": 0.02,
		"initialspeed" : 2.0,
		"max_speed" : 10.0,
		"max_stamina" : 100,
		"new_stamina" : 0.6,
		"map_number": map_count,
		"p1_skin": p1_skin,
		"p2_skin": p2_skin,
	}
	prepare_game()

func _on_timemode_pressed():
	$MainMenu/Panel/PlayNavigation/Back.disabled = true
	$MainMenu/Panel/PlayNavigation/Timemode.release_focus()
	settings = {
		"gamemode": 1,
		"gamelength": 180,
		"max_break_strength": 0.04,
		"max_boost_strength": 0.02,
		"initialspeed" : 2.0,
		"max_speed" : 10.0,
		"max_stamina" : 100,
		"new_stamina" : 0.6,
		"map_number": map_count,
		"p1_skin": p1_skin,
		"p2_skin": p2_skin,
	}
	prepare_game()


func _on_compeditive_pressed():
	$MainMenu/Panel/PlayNavigation/Back.disabled = true
	$MainMenu/Panel/PlayNavigation/Compeditive.release_focus()
	settings = {
		"gamemode": 1,
		"gamelength": 300,
		"max_break_strength": 0.06,
		"max_boost_strength": 0.05,
		"initialspeed" : 5.0,
		"max_speed" : 15.0,
		"max_stamina" : 150,
		"new_stamina" : 0.8,
		"map_number": map_count,
		"p1_skin": p1_skin,
		"p2_skin": p2_skin,
	}
	prepare_game()


func _on_userspecified_pressed():
	$MainMenu/Panel/PlayNavigation/Back.disabled = true
	$MainMenu/Panel/PlayNavigation/Userspecified.release_focus()
	$MainMenu/MenuAccept.play(0.0)
	$MainMenu/Preparations/GameSettings.show()
	$MainMenu/Preparations/MapSettings.hide()
	$MainMenu/Preparations/PlayerSettings.hide()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseInputLabel.show()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseInputLabel.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin.hide()
	$MainMenu/AnimationPlayer.play("play_nav_to_preperations")
	is_userspecified = true


func _on_back_pressed():
	$MainMenu/Panel/PlayNavigation/Back.disabled = true
	$MainMenu/MenuDeny.play(0.0)
	$MainMenu/Panel/PlayNavigation/Back.release_focus()
	$MainMenu/Panel/AnimationPlayer.play("switch_play_and_main_nav")


func _on_options_back_button_pressed():
	is_in_options = false
	$Options/BackButton.disabled = true
	$MainMenu/MenuDeny.play(0.0)
	$Options/AnimationPlayer.play("options_to_start_nav")


#------------------------------------------------------------------------------------------------------------------------------


func _on_next_map_pressed():
	$MainMenu/MenuAccept.play(0.0)
	match map_count:
		0:
			map_count = 1
		1:
			map_count = 2
		2:
			map_count = 3
		3:
			map_count = 4
		4:
			map_count = 0
	$MainMenu/Preparations/MapSettings/MapName.text = map_names[map_count]
	$MainMenu/Preparations/MapSettings/AnimatedSprite2D.frame = map_count


func _on_prev_map_pressed():
	$MainMenu/MenuAccept.play(0.0)
	match map_count:
		0:
			map_count = 4
		1:
			map_count = 0
		2:
			map_count = 1
		3:
			map_count = 2
		4:
			map_count = 3
	$MainMenu/Preparations/MapSettings/MapName.text = map_names[map_count]
	$MainMenu/Preparations/MapSettings/AnimatedSprite2D.frame = map_count


func _on_mapsettings_back_button_pressed():
	$MainMenu/Preparations/MapSettings/BackButton.release_focus()
	$MainMenu/Preparations/MapSettings/BackButton.disabled = true
	$MainMenu/MenuDeny.play(0.0)
	if not is_userspecified:
		$MainMenu/AnimationPlayer.play("preperations_to_play_nav")
	else:
		$MainMenu/AnimationPlayer.play("mapsettings_to_gamesettings")


func _on_mapsettings_continue_button_pressed():
	$MainMenu/MenuAccept.play(0.0)
	$MainMenu/AnimationPlayer.play("mapsettings_to_playersettings")


#------------------------------------------------------------------------------------------------------------------------------


func _on_p1_ready_button_pressed():
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/ReadyButton.disabled = true
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/ReadyButton.hide()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/PrevSkin.hide()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/NextSkin.hide()
	$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/CPUParticles2D.emitting = true
	p1_ready = true
	$MainMenu/MenuAccept.play(0.0)
	if p2_ready:
		init_game()


func _on_p2_ready_button_pressed():
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/ReadyButton.disabled = true
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/ReadyButton.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/PrevSkin.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/NextSkin.hide()
	$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/CPUParticles2D.emitting = true
	p2_ready = true
	$MainMenu/MenuAccept.play(0.0)
	if p1_ready:
		init_game()


func _on_p1_prev_skin_pressed():
	$MainMenu/MenuSelect.play(0.0)
	var new_skin = p1_skin[1] - 1
	if p1_skin[0] == 0 && new_skin < 0:
		p1_skin = [1, square_skins_count]
	elif p1_skin[0] == 1 && new_skin < 0:
		p1_skin = [0, circle_skins_count]
	else:
		p1_skin.pop_back()
		p1_skin.append(new_skin)
	match p1_skin[0]:
		0:
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.animation = "circle"
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.frame = p1_skin[1]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/SkinName.text = circle_skin_names[p1_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/TypeName.text = "Typ: Kreis"
		1:
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.animation = "square"
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.frame = p1_skin[1]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/SkinName.text = square_skin_names[p1_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/TypeName.text = "Typ: Quadrat"


func _on_p1_next_skin_pressed():
	$MainMenu/MenuSelect.play(0.0)
	var new_skin = p1_skin[1] + 1
	if p1_skin[0] == 0 && new_skin > circle_skins_count:
		p1_skin = [1, 0]
	elif p1_skin[0] == 1 && new_skin > square_skins_count:
		p1_skin = [0, 0]
	else:
		p1_skin.pop_back()
		p1_skin.append(new_skin)
	match p1_skin[0]:
		0:
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.animation = "circle"
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.frame = p1_skin[1]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/SkinName.text = circle_skin_names[p1_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/TypeName.text = "Typ: Kreis"
		1:
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.animation = "square"
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/AnimatedSprite2D.frame = p1_skin[1]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/SkinName.text = square_skin_names[p1_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/TypeName.text = "Typ: Quadrat"


func _on_p2_prev_skin_pressed():
	$MainMenu/MenuSelect.play(0.0)
	var new_skin = p2_skin[1] - 1
	if p2_skin[0] == 0 && new_skin < 0:
		p2_skin = [1, square_skins_count]
	elif p2_skin[0] == 1 && new_skin < 0:
		p2_skin = [0, circle_skins_count]
	else:
		p2_skin.pop_back()
		p2_skin.append(new_skin)
	match p2_skin[0]:
		0:
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.animation = "circle"
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.frame = p2_skin[1]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/SkinName.text = circle_skin_names[p2_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/TypeName.text = "Typ: Kreis"
		1:
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.animation = "square"
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.frame = p2_skin[1]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/SkinName.text = square_skin_names[p2_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/TypeName.text = "Typ: Quadrat"


func _on_p2_next_skin_pressed():
	$MainMenu/MenuSelect.play(0.0)
	var new_skin = p2_skin[1] + 1
	if p2_skin[0] == 0 && new_skin > circle_skins_count:
		p2_skin = [1, 0]
	elif p2_skin[0] == 1 && new_skin > square_skins_count:
		p2_skin = [0, 0]
	else:
		p2_skin.pop_back()
		p2_skin.append(new_skin)
	match p2_skin[0]:
		0:
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.animation = "circle"
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.frame = p2_skin[1]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/SkinName.text = circle_skin_names[p2_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/TypeName.text = "Typ: Kreis"
		1:
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.animation = "square"
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/AnimatedSprite2D.frame = p2_skin[1]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/SkinName.text = square_skin_names[p2_skin[1]]
			$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/TypeName.text = "Typ: Quadrat"


#------------------------------------------------------------------------------------------------------------------------------


func _on_gamemode_selected(index):
	$MainMenu/MenuAccept.play(0.0)
	settings["gamemode"] = index
	match index:
		0:
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/Label.text = "Tore zum Sieg: 10"
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.step = 1
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.min_value = 3
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.max_value = 40
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.value = 10
		1:
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/Label.text = "Spielzeit: 3:00min"
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.step = 15
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.min_value = 60
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.max_value = 600
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/VBoxContainer/HSlider.value = 180


func _on_gamelength_value_changed(value):
	settings["gamelength"] = value
	match settings["gamemode"]:
		0:
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/Label.text = "Punkte zum Sieg: " + str(value)
		1:
			var min = value / 60
			var sec = fmod(value, 60)
			$MainMenu/Preparations/GameSettings/VBoxContainer/GameLength/Label.text = "Spielzeit: %d:%02dmin" % [min, sec]


func _on_maxbreakstrength_value_changed(value):
	settings["max_break_strength"] = value
	if value < 0.3:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBreakStrength/Label.text = "Stärke\n der Bremse: Rutschpartie"
	elif value < 0.4:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBreakStrength/Label.text = "Stärke\nder Bremse: Schwach"
	elif value == 0.4:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBreakStrength/Label.text = "Stärke\nder Bremse: Normal"
	elif value > 0.5:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBreakStrength/Label.text = "Stärke\nder Bremse: Handbremse"
	elif value > 0.4:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBreakStrength/Label.text = "Stärke\nder Bremse: Stark"

func _on_maxbooststrength_value_changed(value):
	settings["max_boost_strength"] = value
	if value < 0.2:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBoostStrength/Label.text = "Stärke der\nBeschleinigung: Eisreifen"
	elif value == 0.2:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBoostStrength/Label.text = "Stärke der\nBeschleinigung: Normal"
	elif value > 0.5:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBoostStrength/Label.text = "Stärke der\nBeschleinigung: Zahnrad"
	elif value > 0.2:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxBoostStrength/Label.text = "Stärke der\nBeschleinigung: Stark"


func _on_initialspeed_value_changed(value):
	settings["initialspeed"] = value
	if value < 1.5:
		$MainMenu/Preparations/GameSettings/VBoxContainer/Initialspeed/Label.text = "Startgeschwindigkeit:\nSchneckentempo"
	elif value < 2:
		$MainMenu/Preparations/GameSettings/VBoxContainer/Initialspeed/Label.text = "Start-\ngeschwindigkeit: Langsam"
	elif value == 2:
			$MainMenu/Preparations/GameSettings/VBoxContainer/Initialspeed/Label.text = "Start-\ngeschwindigkeit: Normal"
	elif value > 3.5:
			$MainMenu/Preparations/GameSettings/VBoxContainer/Initialspeed/Label.text = "Start-\ngeschwindigkeit: Schall"
	elif value > 2:
			$MainMenu/Preparations/GameSettings/VBoxContainer/Initialspeed/Label.text = "Start-\ngeschwindigkeit: Schnell"



func _on_maxspeed_value_changed(value):
	settings["max_speed"] = value
	if value < 8:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxSpeed/Label.text = "Maximale\nGeschwindigkeit: Zu Fuß"
	elif value < 10:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxSpeed/Label.text = "Maximale\nGeschwindigkeit: Niedrig"
	elif value == 10:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxSpeed/Label.text = "Maximale\nGeschwindigkeit: Normal"
	elif value > 19:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxSpeed/Label.text = "Maximale\nGeschwindigkeit: Schall"
	elif value > 10:
			$MainMenu/Preparations/GameSettings/VBoxContainer/MaxSpeed/Label.text = "Maximale\nGeschwindigkeit: Hoch"



func _on_maxstamina_value_changed(value):
	settings["max_stamina"] = value
	if value < 80:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxStamina/Label.text = "Maximale Ausdauer: Papier"
	elif value < 100:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxStamina/Label.text = "Maximale Ausdauer: Niedrig"
	elif value == 100:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxStamina/Label.text = "Maximale Ausdauer: Normal"
	elif value > 190:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxStamina/Label.text = "Maximale Ausdauer: Marathon"
	elif value > 100:
		$MainMenu/Preparations/GameSettings/VBoxContainer/MaxStamina/Label.text = "Maximale Ausdauer: Hoch"


func _on_newstamina_value_changed(value):
	settings["new_stamina"] = value
	if value < 0.4:
		$MainMenu/Preparations/GameSettings/VBoxContainer/NewStamina/Label.text = "Ausdauererholung:\nSchneckentempo"
	elif value < 0.6:
		$MainMenu/Preparations/GameSettings/VBoxContainer/NewStamina/Label.text = "Ausdauererholung: Langsam"
	elif value < 0.7:
		$MainMenu/Preparations/GameSettings/VBoxContainer/NewStamina/Label.text = "Ausdauererholung: Normal"
	elif value > 0.8:
		$MainMenu/Preparations/GameSettings/VBoxContainer/NewStamina/Label.text = "Ausdauererholung:\nSchallgeschwindigkeit"
	elif value > 0.6:
		$MainMenu/Preparations/GameSettings/VBoxContainer/NewStamina/Label.text = "Ausdauererholung: Schnell"


func _on_gamesettings_continue_button_pressed():
	$MainMenu/MenuAccept.play(0.0)
	$MainMenu/AnimationPlayer.play("gamesettings_to_mapsettings")


func _on_gamesettings_back_button_pressed():
	$MainMenu/Preparations/GameSettings/BackButton.release_focus()
	$MainMenu/Preparations/GameSettings/BackButton.disabled = true
	$MainMenu/MenuDeny.play(0.0)
	$MainMenu/AnimationPlayer.play("preperations_to_play_nav")
	is_userspecified = false


#------------------------------------------------------------------------------------------------------------------------------


func _on_back_to_menu_button_pressed():
	$MainMenu/MenuAccept.play(0.0)
	load_type = 1
	$MainMenu/Preparations.position = Vector2(64, 1152)
	$MainMenu/Preparations.hide()
	$MainMenu/AnimationPlayer.play("start_loading_panel")


#------------------------------------------------------------------------------------------------------------------------------


func _on_master_volume_changed(value):
	var bus = AudioServer.get_bus_index("Master")
	if value == -50:
		AudioServer.set_bus_mute(bus, true)
		$Options/TabContainer/Audio/Master/Label.text = "Allgemein: Stumm"
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
		$Options/TabContainer/Audio/Master/Label.text = "Allgemein: " + str((value * 2) + 100) + "%"


func _on_sfx_volume_changed(value):
	var bus = AudioServer.get_bus_index("Soundeffects")
	if value == -50:
		AudioServer.set_bus_mute(bus, true)
		$Options/TabContainer/Audio/SFX/Label.text = "Soundeffekte: Stumm"
		
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
		$Options/TabContainer/Audio/SFX/Label.text = "Soundeffekte: " + str((value * 2) + 100) + "%"


func _on_music_volume_changed(value):
	var bus = AudioServer.get_bus_index("Music")
	if value == -50:
		AudioServer.set_bus_mute(bus, true)
		$Options/TabContainer/Audio/Music/Label.text = "Musik: Stumm"
		
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
		$Options/TabContainer/Audio/Music/Label.text = "Musik: " + str((value * 2) + 100) + "%"


func _on_menu_sfx_value_changed(value):
	var bus = AudioServer.get_bus_index("MenuSFX")
	if value == -50:
		AudioServer.set_bus_mute(bus, true)
		$Options/TabContainer/Audio/MenuSFX/Label.text = "Menu: Stumm"
		
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
		$Options/TabContainer/Audio/MenuSFX/Label.text = "Menu: " + str((value * 2) + 100) + "%"


#------------------------------------------------------------------------------------------------------------------------------


func _on_vibration_toggled(button_pressed):
	vibration_enabled = button_pressed
	emit_signal("vibration_changed", button_pressed)


#------------------------------------------------------------------------------------------------------------------------------
#
# animations players
#
#------------------------------------------------------------------------------------------------------------------------------


func _on_MainMenu_animation_finished(anim_name):
	match anim_name:
		"start_animation":
			$MainMenu/Panel/MainNavigation/Play.grab_focus()
		"switch_main_and_play_nav":
			$MainMenu/Panel/PlayNavigation/Classic.grab_focus()
			$MainMenu/Panel/PlayNavigation/Back.disabled = false
		"switch_play_and_main_nav", "show_play_nav":
			$MainMenu/Panel/MainNavigation/Play.grab_focus()


func _on_options_animation_player_animation_finished(anim_name):
	match anim_name:
		"start_nav_to_options":
			$Options/BackButton.disabled = false
			resolution_option.grab_focus()
			is_in_options = true
		"options_to_start_nav":
			$Options.hide()
			$MainMenu/Panel/MainNavigation/Play.grab_focus()


func _on_main_menu_animation_player_animation_finished(anim_name):
	match anim_name:
		"play_nav_to_preperations":
			if $MainMenu/Preparations/MapSettings.visible:
				$MainMenu/Preparations/MapSettings/BackButton.disabled = false
				$MainMenu/Preparations/MapSettings/ContinueButton.grab_focus()
				$MainMenu/Preparations/MapSettings/MapName.text = map_names[map_count]
				$MainMenu/Preparations/MapSettings/AnimatedSprite2D.frame = map_count
			elif $MainMenu/Preparations/GameSettings.visible:
				$MainMenu/Preparations/GameSettings/BackButton.disabled = false
				$MainMenu/Preparations/GameSettings/ContinueButton.grab_focus()
		"preperations_to_play_nav":
			$MainMenu/Panel/PlayNavigation/Classic.grab_focus()
			$MainMenu/Panel/PlayNavigation/Back.disabled = false
		"mapsettings_to_playersettings":
			p1_choose_input = true
		"start_loading_panel":
			$MainMenu/AnimationPlayer.play("loading")
			match load_type:
				0:
					emit_signal("initiate_game", settings)
					$MainMenu.hide()
				1:
					await get_tree().create_timer(0.5).timeout
					$Overlay/GameEndUI.hide()
					$MainMenu.show()
					$MainMenu/Preparations/PlayerSettings/VersusLabel.hide()
					$MainMenu/Preparations/PlayerSettings/VersusLabel.text = "VS"
					$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseInputLabel.show()
					$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin.hide()
					$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/NextSkin.show()
					$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/PrevSkin.show()
					$MainMenu/Preparations/PlayerSettings/P1Panel/ChooseSkin/ReadyButton.show()
					$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseInputLabel.hide()
					$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin.hide()
					$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/NextSkin.show()
					$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/PrevSkin.show()
					$MainMenu/Preparations/PlayerSettings/P2Panel/ChooseSkin/ReadyButton.show()
					$MainMenu/AnimationPlayer.play("stop_loading_panel")
		"stop_loading_panel":
			match load_type:
				0:
					emit_signal("start_game")
					reset_scores()
					start_countdownlong()
				1:
					$MainMenu/Panel/AnimationPlayer.play("show_play_nav")
		"gamesettings_to_mapsettings":
			$MainMenu/Preparations/MapSettings/BackButton.disabled = false
			$MainMenu/Preparations/MapSettings/ContinueButton.grab_focus()
			$MainMenu/Preparations/MapSettings/MapName.text = map_names[map_count]
			$MainMenu/Preparations/MapSettings/AnimatedSprite2D.frame = map_count
		"mapsettings_to_gamesettings":
			$MainMenu/Preparations/GameSettings/BackButton.disabled = false
			$MainMenu/Preparations/GameSettings/ContinueButton.grab_focus()


func _on_overlay_animation_player_animation_finished(anim_name):
	match anim_name:
		"p1_won":
			$Overlay/GameEndUI/BackButton.grab_focus()
			emit_signal("game_over")
		"p2_won":
			$Overlay/GameEndUI/BackButton.grab_focus()
			emit_signal("game_over")
		"remis":
			$Overlay/GameEndUI/BackButton.grab_focus()
			emit_signal("game_over")

