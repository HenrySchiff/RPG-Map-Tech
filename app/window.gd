class_name CustomWindow extends Window

@onready var sub_vp_container: SubViewportContainer = $SubViewportContainer
@onready var world: World = $SubViewportContainer/SubViewport/World
@onready var player: Player = $SubViewportContainer/SubViewport/World/Player
@onready var camera: CameraRig = $SubViewportContainer/SubViewport/World/CameraRig

var prev_mouse_drag_pos: Vector2
var curr_mouse_drag_pos: Vector2

func _process(_delta):
	$CanvasLayer/FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	
	#if has_focus() and Input.is_action_pressed("middle_mouse"):
		#prev_mouse_drag_pos = curr_mouse_drag_pos
		#curr_mouse_drag_pos = get_mouse_position()
		#$CanvasLayer/Node2D.start = prev_mouse_drag_pos
		#$CanvasLayer/Node2D.end = curr_mouse_drag_pos
		#$CanvasLayer/Node2D.queue_redraw()
