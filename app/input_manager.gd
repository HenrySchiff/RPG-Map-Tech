extends Node

@export var control_window: Window
@export var display_window: Window
@export var gui: Node

func _process(_delta):
	var rotation_x_dir: int = 0
	var rotation_y_dir: int = 0
	var zoom_dir: int = 0
	
	rotation_y_dir += int(Input.is_action_just_pressed("camera_right"))
	rotation_y_dir -= int(Input.is_action_just_pressed("camera_left"))
	
	rotation_x_dir += int(Input.is_action_just_pressed("camera_down"))
	rotation_x_dir -= int(Input.is_action_just_pressed("camera_up"))
	
	zoom_dir += int(Input.is_action_just_pressed("camera_zoom_in"))
	zoom_dir -= int(Input.is_action_just_pressed("camera_zoom_out"))
	
	if gui.sync_cameras[0]:
		control_window.world.camera.receive_input(rotation_x_dir, rotation_y_dir, zoom_dir)
		display_window.world.camera.sync_targets(display_window.world.camera)
		return
	
	if control_window.has_focus():
		control_window.world.camera.receive_input(rotation_x_dir, rotation_y_dir, zoom_dir)
	
	if display_window.has_focus():
		display_window.world.camera.receive_input(rotation_x_dir, rotation_y_dir, zoom_dir)
