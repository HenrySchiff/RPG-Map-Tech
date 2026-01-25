extends Node3D

var icon_scene: PackedScene = preload("res://world/icon.tscn")

@export var entity: Node3D

@onready var entity_movement: MovementComponent = entity.movement_component
@onready var indicator_pivot: Node3D = $IndicatorPivot
@onready var indicators: Node3D = $IndicatorPivot/Indicators
@onready var path_3d: Path3D = $Path3D

var selected_indicator: Icon


func _ready():
	_build_indicators()
	_update_indicators()
	
	entity_movement.velocity_changed.connect(func():
		_update_indicators()
		_update_curve()
		#_update_pivot_transform()
	)

func _process(_delta):
	_update_pivot_transform()

func _input(_event):
	if Input.is_action_just_pressed("enter"):
		if path_3d.curve.point_count < 2:
			return
		
		var local_point := path_3d.curve.get_point_position(1)
		var world_point := path_3d.global_transform * local_point
		
		var center_pos := entity.global_position + entity_movement.velocity
		var dir := (world_point - center_pos).normalized()
		
		selected_indicator = null
		
		entity.position = world_point
		entity.position_target = world_point
		if !dir.is_zero_approx(): entity_movement.direction = dir
		
		_update_indicators()

func _update_curve() -> void:
	path_3d.curve.clear_points()
	
	if !selected_indicator:  return
	
	path_3d.curve.add_point(entity.global_position)
	path_3d.curve.add_point(selected_indicator.global_position)
	path_3d.curve.set_point_in(
		1,
		entity.global_position + entity_movement.velocity - selected_indicator.global_position
	)
	
	$Path3D/PathFollow3D.progress_ratio = 1.0


func _update_pivot_transform() -> void:
	var vel := entity_movement.velocity
	var _basis := _movement_basis(vel)

	indicator_pivot.global_transform = Transform3D(
		_basis,
		entity.global_position
	)

#NOTE: not my code idk how this works
func _movement_basis(vel: Vector3) -> Basis:
	var forward := vel.normalized()
	
	if forward.is_zero_approx():
		return indicator_pivot.global_basis
	
	var reference_up := Vector3.UP
	if abs(forward.dot(reference_up)) > 0.98:
		reference_up = Vector3.FORWARD
	
	var right := forward.cross(reference_up).normalized()
	var up := right.cross(forward).normalized()
	
	return Basis(right, up, -forward)


func _build_indicators() -> void:
	for i in range(9):
		var indicator = icon_scene.instantiate()
		indicators.add_child(indicator)
		
		indicator.clicked.connect(func():
			selected_indicator = indicator
			_update_curve()
		)

func _update_indicators() -> void:
	var vel := entity_movement.velocity
	var speed := vel.length()

	const spacing := 3.0

	# Offset indicators forward in movement space
	indicators.position = Vector3(0, 0, -speed)

	var i = 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			#var indicator: Icon = icon_scene.instantiate()
			var indicator = indicators.get_child(i)
			i += 1
			indicator.position = Vector3(x * spacing, y * spacing, 0)
