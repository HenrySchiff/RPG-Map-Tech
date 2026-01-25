class_name CameraRig extends Node3D

@onready var window: Window = find_parent("*Window")
@onready var camera_arm = $CameraArm
@onready var camera: Camera3D = $CameraArm/Camera3D

@export var is_orthogonal: bool = true:
	set(value):
		is_orthogonal = value
		call_deferred("_apply_is_orthogonal")

@export var anchor: Node3D = null

const ROTATION_Y_STEP: float = deg_to_rad(45.0/2.0)
const ROTATION_X_STEP: float = deg_to_rad(30.0)
const POSITION_STEP: float = 1.0
const ZOOM_FACTOR: float = 2.0

const ROTATION_X_MIN: float = deg_to_rad(-90.0)
const ROTATION_X_MAX: float = deg_to_rad(0.0)
const ZOOM_MIN: float = 3.0
const ZOOM_MAX: float = 96.0

var rotation_y_target: float = deg_to_rad(45.0)
var rotation_x_target: float = deg_to_rad(-45.0)
var position_target: Vector3 = Vector3.ZERO
var zoom_target: float = 12.0

func _ready():
	_apply_is_orthogonal()

func _process(delta):
	
	position_target = anchor.global_position
	#global_position = anchor.global_position
	#position_target = global_position
	
	if !is_equal_approx(camera_arm.rotation.y, rotation_y_target):
		camera_arm.rotation.y = Util.lerpdt(camera_arm.rotation.y, rotation_y_target, 0.00001, delta)
		
	if !is_equal_approx(camera_arm.rotation.x, rotation_x_target):
		camera_arm.rotation.x = Util.lerpdt(camera_arm.rotation.x, rotation_x_target, 0.00001, delta)
		
	if !global_position.is_equal_approx(position_target):
		#TODO: make lerpdt function for vectors
		global_position.x = Util.lerpdt(global_position.x, position_target.x, 0.00001, delta)
		global_position.y = Util.lerpdt(global_position.y, position_target.y, 0.00001, delta)
		global_position.z = Util.lerpdt(global_position.z, position_target.z, 0.00001, delta)
		
	#TODO: adjust zooming to be consistent across both projections
	if !is_equal_approx(camera.position.z, zoom_target):
		if is_orthogonal:
			camera.size = Util.lerpdt(camera.size, zoom_target, 0.00001, delta)
		else:
			camera.position.z = Util.lerpdt(camera.position.z, zoom_target, 0.0001, delta)

func _apply_is_orthogonal():
	var projection := Camera3D.PROJECTION_ORTHOGONAL if is_orthogonal else Camera3D.PROJECTION_PERSPECTIVE
	camera.set_projection(projection)

func sync_targets(other: CameraRig):
	#anchor = other.anchor
	rotation_x_target = other.rotation_x_target
	rotation_y_target = other.rotation_y_target
	position_target = other.position_target
	zoom_target = other.zoom_target

func force_update_rotation(rot_x_delta: float, rot_y_delta: float):
	camera_arm.rotation.x += rot_x_delta
	camera_arm.rotation.y += rot_y_delta
	rotation_x_target = camera_arm.rotation.x
	rotation_y_target = camera_arm.rotation.y
	
	camera_arm.rotation.x = clamp(camera_arm.rotation.x, ROTATION_X_MIN, ROTATION_X_MAX)

func update_rotation(rot_x_dir: int, rot_y_dir: int):
	if rot_x_dir:
		rotation_x_target += ROTATION_X_STEP * rot_x_dir
		rotation_x_target = round(rotation_x_target / ROTATION_X_STEP) * ROTATION_X_STEP
		rotation_x_target = clamp(rotation_x_target, ROTATION_X_MIN, ROTATION_X_MAX)
	
	if rot_y_dir:
		rotation_y_target += ROTATION_Y_STEP * rot_y_dir
		rotation_y_target = round(rotation_y_target / ROTATION_Y_STEP) * ROTATION_Y_STEP
	

func update_zoom(zoom_dir: int):
	zoom_target /= ZOOM_FACTOR ** zoom_dir
	zoom_target = clamp(zoom_target, ZOOM_MIN, ZOOM_MAX)
