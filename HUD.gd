extends CanvasLayer
class_name HUD


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_new_score(goals_p1, goals_p2):
	$Overlay/Label.text = str(goals_p1) + " : " + str(goals_p2)
