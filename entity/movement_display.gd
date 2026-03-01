extends Node3D

var icon_scene: PackedScene = preload("res://world/icon.tscn")

@export var entity: Node3D

@onready var entity_movement: MovementComponent = entity.movement_component
@onready var indicators: Node3D = $Indicators
@onready var path_3d: Path3D = $Path3D

@onready var preview_vector: PathFollow3D = $Path3D/PreviewVector
@onready var progress_vector: PathFollow3D = $Path3D/ProgressVector

var selected_indicator: Icon = null


func _ready():
	$CSGPolygon3D.polygon = Util.generate_circle(0.03, 10)
	
	global_transform = Transform3D(
		entity_movement.direction,
		entity.global_position
	)
	
	#indicators.global_transform = Transform3D(
		#entity_movement.direction,
		#entity.global_position + entity_movement.velocity
	#)
	
	_build_indicators()
	_update_indicators()
	
	entity_movement.velocity_changed.connect(func():
		_update_indicators()
		_update_curve()
	)
	
	entity_movement.exit_angle_factor_changed.connect(func():
		_update_curve()
	)


func _process(delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("enter"):
		if selected_indicator == null: return
		
		selected_indicator = null
		
		entity.global_position = preview_vector.global_position
		entity_movement.direction = preview_vector.global_basis
		
		global_transform = Transform3D(
			entity_movement.direction,
			entity.global_position
		)
		
		#indicators.global_transform = Transform3D(
			#entity_movement.direction,
			#entity.global_position + entity_movement.velocity
		#)

func _update_curve() -> void:
	#path_3d.basis = entity_movement.direction
	path_3d.curve.clear_points()
	
	if !selected_indicator: return
	
	var control_point = (
		(entity_movement.speed * Vector3.FORWARD * entity_movement.exit_angle_factor) - 
		selected_indicator.position
	)
	
	#print(control_point)
	#var tilt := entity_movement.global_basis.get_euler().x
	
	var forward := entity_movement.direction.z
	var tilt = atan2(forward.x, forward.z)
	
	#path_3d.curve.add_point(entity.global_position)
	path_3d.curve.add_point(Vector3.ZERO)
	path_3d.curve.add_point(selected_indicator.position)
	path_3d.curve.add_point(selected_indicator.position - control_point)
	path_3d.curve.set_point_in(1, control_point)
	path_3d.curve.set_point_out(1, -control_point)
	
	#path_3d.curve.set_point_tilt(0, tilt)
	#path_3d.curve.set_point_tilt(1, tilt)
	#path_3d.curve.set_point_tilt(2, tilt)
	
	var ratio = Util.get_ratio_at_point(path_3d.curve, 1)
	preview_vector.progress_ratio = ratio

#func _update_indicators_transform() -> void:


func _build_indicators() -> void:
	for i in range(9):
		var indicator = icon_scene.instantiate()
		indicators.add_child(indicator)
		
		indicator.clicked.connect(func():
			selected_indicator = indicator
			_update_curve()
		)

func _update_indicators() -> void:
	
	#indicators.global_transform = Transform3D(
		#entity_movement.direction,
		#entity.global_position + entity_movement.velocity
	#)
	
	var spacing := entity_movement.speed * entity_movement.TURNING_RADIUS_FACTOR
	var z_distance := -entity_movement.speed
	
	var i = 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			#var indicator: Icon = icon_scene.instantiate()
			var indicator = indicators.get_child(i)
			indicator.position = Vector3(x * spacing, y * spacing, z_distance)
			indicator.color = Color.RED if i == 5 else Color.BLACK
			
			i += 1
