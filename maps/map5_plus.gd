extends map


var t1
var t2 
var v1
var v2


func _ready():
	randomize()
	t1 = randf_range(0.2, 1)
	v1 = randi_range(1, 5)
	t2 = randf_range(0.2, 1)
	v2 = randi_range(1, 5)


func _process(delta):
	if t1 > 0:
		t1 -= delta
	else:
		t1 = randf_range(0.2, 1)
		v1 = randi_range(1, 5)
	if t2 > 0:
		t2 -= delta
	else:
		t2 = randf_range(0.2, 1)
		v2 = randi_range(1, 5)
	
	
	if v1 >= 4:
		randomize()
		var p = randf_range(0, 1) * delta
		if ($Bouncer1/PathFollow2D.progress_ratio + p) > 1:
			$Bouncer1/PathFollow2D.progress_ratio -= p
			t1 = randf_range(0.2, 1)
			v1 = randi_range(1, 5)
		else:
			$Bouncer1/PathFollow2D.progress_ratio += p
	elif v1 <= 2:
		randomize()
		var p = randf_range(0, 1) * delta
		if ($Bouncer1/PathFollow2D.progress_ratio - p) < 0:
			$Bouncer1/PathFollow2D.progress_ratio += p
			t1 = randf_range(0.2, 1)
			v1 = randi_range(1, 5)
		else:
			$Bouncer1/PathFollow2D.progress_ratio -= p
		
	if v2 >= 4:
		randomize()
		var p = randf_range(0, 1) * delta
		if ($Bouncer2/PathFollow2D.progress_ratio + p) > 1:
			$Bouncer2/PathFollow2D.progress_ratio -= p
			t2 = randf_range(0.2, 1)
			v2 = randi_range(1, 5)
		else:
			$Bouncer2/PathFollow2D.progress_ratio += p
	elif v2 <= 2:
		randomize()
		var p = randf_range(0, 1) * delta
		if ($Bouncer2/PathFollow2D.progress_ratio - p) < 0:
			$Bouncer2/PathFollow2D.progress_ratio += p
			t2 = randf_range(0.2, 1)
			v2 = randi_range(1, 5)
		else:
			$Bouncer2/PathFollow2D.progress_ratio -= p
