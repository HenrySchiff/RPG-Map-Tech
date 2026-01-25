extends Node

@export var control_window: CustomWindow
@export var display_window: CustomWindow
@export var gui: Node

var prev_mouse_drag_pos: Vector2
var curr_mouse_drag_pos: Vector2

var focused_window: CustomWindow = null

func _process(delta):
	if control_window.has_focus():
		focused_window = control_window
	
	if display_window.has_focus():
		focused_window = display_window
	
	if !focused_window: return
	
	# window used here is arbitrary but must be chosen to prevent large jumps when switching windows
	prev_mouse_drag_pos = curr_mouse_drag_pos
	curr_mouse_drag_pos = control_window.sub_vp_container.get_global_mouse_position()
	
	var mouse_vel = (curr_mouse_drag_pos - prev_mouse_drag_pos) / 10.0 * delta
	
	if Input.is_action_pressed("middle_mouse") and !mouse_vel.is_zero_approx():
		focused_window.camera.force_update_rotation(-mouse_vel.y, -mouse_vel.x)
	
	else:
		var rotation_x_dir: int = 0
		var rotation_y_dir: int = 0
		
		rotation_y_dir += int(Input.is_action_just_pressed("camera_right"))
		rotation_y_dir -= int(Input.is_action_just_pressed("camera_left"))
		
		rotation_x_dir += int(Input.is_action_just_pressed("camera_down"))
		rotation_x_dir -= int(Input.is_action_just_pressed("camera_up"))
		
		focused_window.camera.update_rotation(rotation_x_dir, rotation_y_dir)
	
	var zoom_dir: int = 0
	zoom_dir += int(Input.is_action_just_pressed("camera_zoom_in"))
	zoom_dir -= int(Input.is_action_just_pressed("camera_zoom_out"))
	
	focused_window.camera.update_zoom(zoom_dir)
	
	if gui.sync_cameras[0]:
		display_window.camera.sync_targets(focused_window.camera)
		control_window.camera.sync_targets(focused_window.camera)
