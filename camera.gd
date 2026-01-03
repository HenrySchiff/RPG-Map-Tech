extends Node3D

@onready var camera_arm = $CameraArm
@onready var camera = $CameraArm/Camera3D

const ROTATION_Y_STEP: float = deg_to_rad(45)
const ROTATION_X_STEP: float = deg_to_rad(15)
const POSITION_STEP: float = 1.0
const ZOOM_FACTOR: float = 2.0

const ROTATION_X_MIN: float = deg_to_rad(-90)
const ROTATION_X_MAX: float = deg_to_rad(0)
const ZOOM_MIN: float = 2.5
const ZOOM_MAX: float = 40.0

var rotation_y_target: float = 0.0
var rotation_x_target: float = deg_to_rad(-45)
var position_target: Vector3 = Vector3.ONE * 0.5
var zoom_target: float = 10.0

func _process(delta):
	if Input.is_action_just_pressed("camera_left"):
		rotation_y_target -= ROTATION_Y_STEP
	
	if Input.is_action_just_pressed("camera_right"):
		rotation_y_target += ROTATION_Y_STEP
		
	if Input.is_action_just_pressed("camera_up"):
		rotation_x_target = clamp(rotation_x_target - ROTATION_X_STEP, ROTATION_X_MIN, ROTATION_X_MAX)
	
	if Input.is_action_just_pressed("camera_down"):
		rotation_x_target = clamp(rotation_x_target + ROTATION_X_STEP, ROTATION_X_MIN, ROTATION_X_MAX)
	
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_target = clamp(zoom_target / ZOOM_FACTOR, ZOOM_MIN, ZOOM_MAX)
	
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_target = clamp(zoom_target * ZOOM_FACTOR, ZOOM_MIN, ZOOM_MAX)
	
	#var movement: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#position_target += POSITION_STEP * Vector3(movement.x, 0, movement.y)
	
	var movement := Vector2.ZERO
	
	if Input.is_action_just_pressed("move_left"):
		movement.x -= 1
	elif Input.is_action_just_pressed("move_right"):
		movement.x += 1
	elif Input.is_action_just_pressed("move_up"):
		movement.y -= 1
	elif Input.is_action_just_pressed("move_down"):
		movement.y += 1
	
	position_target += POSITION_STEP * Vector3(movement.x, 0, movement.y)
	
	if !is_equal_approx(rotation.y, rotation_y_target):
		rotation.y = Util.lerpdt(rotation.y, rotation_y_target, 0.001, delta)
		
	if !is_equal_approx(rotation.x, rotation_x_target):
		camera_arm.rotation.x = Util.lerpdt(camera_arm.rotation.x, rotation_x_target, 0.0001, delta)
		
	if !position.is_equal_approx(position_target):
		#TODO: needs dt
		position = position.lerp(position_target, 0.1)
		
	if !is_equal_approx(camera.position.z, zoom_target):
		camera.position.z = Util.lerpdt(camera.position.z, zoom_target, 0.0001, delta)
