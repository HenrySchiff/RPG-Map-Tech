class_name Player extends Node3D

@onready var collision_shape_3d = $Area3D/CollisionShape3D
@onready var graph_cube = $GraphCube

const POSITION_STEP: float = 1.0
var position_target: Vector3 = Vector3.ZERO

@export_range(5.0, 50.0) var view_range: float = 5.0:
	set(value):
		view_range = value
		call_deferred("_apply_view_range")

var target_view_range = view_range

func _apply_view_range():
	collision_shape_3d.shape.size = Vector3.ONE * view_range * 2.0
	graph_cube.edge_length = view_range * 2.0

func _process(delta):
	if !is_equal_approx(view_range, target_view_range):
		view_range = Util.lerpdt(view_range, target_view_range, 0.0001, delta)
	
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
	
	if !position.is_equal_approx(position_target):
		#TODO: needs dt
		position.x = Util.lerpdt(position.x, position_target.x, 0.00001, delta)
		position.y = Util.lerpdt(position.y, position_target.y, 0.00001, delta)
		position.z = Util.lerpdt(position.z, position_target.z, 0.00001, delta)
