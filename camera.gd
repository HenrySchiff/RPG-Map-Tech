extends Node3D

@onready var camera_arm = $CameraArm
@onready var camera: Camera3D = $CameraArm/Camera3D

@export var is_orthogonal: bool = true;

const ROTATION_Y_STEP: float = deg_to_rad(45.0)
const ROTATION_X_STEP: float = deg_to_rad(30.0)
const POSITION_STEP: float = 1.0
#const ZOOM_FACTOR: float = 2.0
const ZOOM_FACTOR: float = 2.0

const ROTATION_X_MIN: float = deg_to_rad(-90.0)
const ROTATION_X_MAX: float = deg_to_rad(0.0)
#const ZOOM_MIN: float = 2.5
#const ZOOM_MAX: float = 40.0
const ZOOM_MIN: float = 3.0
const ZOOM_MAX: float = 96.0

var rotation_y_target: float = deg_to_rad(45.0)
var rotation_x_target: float = deg_to_rad(-45.0)
var position_target: Vector3 = Vector3.ZERO
var zoom_target: float = 12.0

func _ready():
	if is_orthogonal:
		camera.set_projection(Camera3D.PROJECTION_ORTHOGONAL)
	else:
		camera.set_projection(Camera3D.PROJECTION_PERSPECTIVE)

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
	
	var movement := Vector3.ZERO
	
	if Input.is_action_just_pressed("move_left"):
		movement.x += 1
	elif Input.is_action_just_pressed("move_right"):
		movement.x -= 1
	if Input.is_action_just_pressed("move_up"):
		movement.y += 1
	elif Input.is_action_just_pressed("move_down"):
		movement.y -= 1
	elif Input.is_action_just_pressed("move_forward"):
		movement.z += 1
	elif Input.is_action_just_pressed("move_backward"):
		movement.z -= 1
	
	position_target += POSITION_STEP * movement
	
	if !is_equal_approx(camera_arm.rotation.y, rotation_y_target):
		camera_arm.rotation.y = Util.lerpdt(camera_arm.rotation.y, rotation_y_target, 0.00001, delta)
		
	if !is_equal_approx(camera_arm.rotation.x, rotation_x_target):
		camera_arm.rotation.x = Util.lerpdt(camera_arm.rotation.x, rotation_x_target, 0.00001, delta)
		
	if !position.is_equal_approx(position_target):
		#TODO: needs dt
		#position = position.lerp(position_target, 0.2)
		position.x = Util.lerpdt(position.x, position_target.x, 0.00001, delta)
		position.y = Util.lerpdt(position.y, position_target.y, 0.00001, delta)
		position.z = Util.lerpdt(position.z, position_target.z, 0.00001, delta)
		
	if !is_equal_approx(camera.position.z, zoom_target):
		if is_orthogonal:
			camera.size = Util.lerpdt(camera.size, zoom_target, 0.00001, delta)
		else:
			camera.position.z = Util.lerpdt(camera.position.z, zoom_target, 0.0001, delta)

#func convert_orthogonal_zoom(zoom: float) -> float:
	#return remap(zoom, ZOOM_MIN, ZOOM_MAX, 4.0, 20.0)
