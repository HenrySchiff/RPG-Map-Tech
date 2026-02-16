extends Node3D

var icon_scene: PackedScene = preload("res://world/icon.tscn")

@export var entity: Node3D

@onready var entity_movement: MovementComponent = entity.movement_component
@onready var indicator_pivot: Node3D = $IndicatorPivot
@onready var indicators: Node3D = $IndicatorPivot/Indicators
@onready var path_3d: Path3D = $Path3D

@onready var preview_vector: PathFollow3D = $Path3D/PreviewVector
@onready var progress_vector: PathFollow3D = $Path3D/ProgressVector

var selected_indicator: Icon = null

var moving: bool = false


func _ready():
	$CSGPolygon3D.polygon = Util.generate_circle(0.03, 10)
	
	_build_indicators()
	_update_indicators()
	_update_curve()
	
	entity_movement.velocity_changed.connect(func():
		if moving: return
		_update_indicators()
		_update_curve()
		#_update_pivot_transform()
	)
	
	entity_movement.exit_angle_factor_changed.connect(func():
		_update_curve()
	)

func _process(delta):
	if !moving:
		_update_pivot_transform()
		return
	
	var prev_progress: float = progress_vector.progress_ratio
	progress_vector.progress += delta * 5.0
	entity.position = progress_vector.position
	
	entity.get_node("DirectionVector").basis = progress_vector.global_basis
	entity_movement.direction = -progress_vector.basis.z
	entity_movement.up_direction - progress_vector.basis.y
	
	var ratio = Util.get_ratio_at_point(path_3d.curve, 1)
	
	# progress is past required ratio or has wrapped completely
	if progress_vector.progress_ratio > ratio || progress_vector.progress_ratio < prev_progress:
		progress_vector.progress_ratio = 0.0
		selected_indicator = null
		
		var local_point := path_3d.curve.get_point_position(1)
		var world_point := path_3d.global_transform * local_point
		entity.position = world_point
		entity_movement.direction = -preview_vector.basis.z
		
		_update_pivot_transform()
		_update_indicators()
		selected_indicator = indicators.get_child(4)
		_update_curve()
		
		moving = false

func _input(_event):
	if Input.is_action_just_pressed("enter"):
		if path_3d.curve.point_count < 2:
			return
		
		moving = true
		#var local_point := path_3d.curve.get_point_position(1)
		#var world_point := path_3d.global_transform * local_point
		#
		#selected_indicator = null
		#
		##var ratio = Util.get_ratio_at_point(path_3d.curve, 1)
		##progress_vector.progress += delta * 5.0
		##progress_vector.progress_ratio = fmod(progress_vector.progress_ratio, ratio)
		#
		#entity.position = world_point
		##entity.position_target = world_point
		#entity_movement.direction = -preview_vector.basis.z
		#
		#_update_indicators()

func _update_curve() -> void:
	path_3d.curve.clear_points()
	
	if !selected_indicator: return
	
	var control_point = (
		entity.global_position + 
		(entity_movement.velocity * entity_movement.exit_angle_factor) - 
		selected_indicator.global_position
	)
	
	#print(control_point)
	
	path_3d.curve.add_point(entity.global_position)
	path_3d.curve.add_point(selected_indicator.global_position)
	path_3d.curve.add_point(selected_indicator.global_position - control_point)
	path_3d.curve.set_point_in(1, control_point)
	path_3d.curve.set_point_out(1, -control_point)
	
	var ratio = Util.get_ratio_at_point(path_3d.curve, 1)
	preview_vector.progress_ratio = ratio

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
	
	var reference_up: Vector3 = entity_movement.up_direction
	#var reference_up := Vector3.UP
	#if abs(forward.dot(reference_up)) > 0.98:
		#reference_up = Vector3.FORWARD
	
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
	
	var spacing := speed * entity_movement.TURNING_RADIUS_FACTOR
	
	indicators.position = Vector3(0, 0, -speed)
	
	var i = 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			#var indicator: Icon = icon_scene.instantiate()
			var indicator = indicators.get_child(i)
			indicator.position = Vector3(x * spacing, y * spacing, 0)
			indicator.color = Color.RED if i == 5 else Color.BLACK
			
			i += 1
