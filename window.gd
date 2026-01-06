extends Window

func _process(_delta):
	$CanvasLayer/FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
