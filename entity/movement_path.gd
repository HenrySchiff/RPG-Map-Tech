class_name MovementPath extends Node3D

var icon_scene: PackedScene = preload("res://world/icon.tscn")

@export var entity: Node3D
@export var state: MovementState

@onready var indicators: Node3D = $Indicators
@onready var path: Path3D = $Path3D
@onready var path_mesh: CSGPolygon3D = $CSGPolygon3D

@onready var end_vector: PathFollow3D = $Path3D/EndVector
@onready var start_vector: PathFollow3D = $Path3D/StartVector

var is_selected: bool = false

var selected_indicator: Icon = null
var next_state: MovementState = null

func _ready():
	next_state = MovementState.new()
	end_vector.add_child(next_state)
	end_vector.get_node("Icon").set_hidden(true)
	
	path_mesh.polygon = Util.generate_circle(0.03, 10)
	
	global_transform = Transform3D(
		state.direction,
		state.global_position
	)
	
	_build_indicators()
	_update_indicators()
	_select_indicator(indicators.get_child(4)) # select center icon by default
	
	state.velocity_changed.connect(func():
		_update_indicators()
		_update_curve()
	)
	
	state.exit_angle_factor_changed.connect(func():
		_update_curve()
	)
#
#func _input(_event):
	#if Input.is_action_just_pressed("enter"):
		#if selected_indicator == null: return
		#
		#selected_indicator = null
		#
		#entity.global_position = end_vector.global_position
		#state.direction = end_vector.global_basis
		#
		#global_transform = Transform3D(
			#state.direction,
			#entity.global_position
		#)

func _update_curve() -> void:
	path.curve.clear_points()
	
	if !selected_indicator: return
	
	var control_point = (
		(state.speed * Vector3.FORWARD * state.exit_angle_factor) - 
		selected_indicator.position
	)
	
	var forward := state.direction.z
	var tilt = atan2(forward.x, forward.z)
	
	path.curve.add_point(Vector3.ZERO)
	path.curve.add_point(selected_indicator.position)
	path.curve.add_point(selected_indicator.position - control_point.normalized() * 0.1)
	path.curve.set_point_in(1, control_point)
	path.curve.set_point_out(1, -control_point)
	
	#path.curve.set_point_tilt(0, tilt)
	#path.curve.set_point_tilt(1, tilt)
	#path.curve.set_point_tilt(2, tilt)
	
	var ratio = Util.get_ratio_at_point(path.curve, 1)
	end_vector.progress_ratio = ratio
	
	next_state.direction = end_vector.global_basis

func _build_indicators() -> void:
	for i in range(9):
		var indicator: Icon = icon_scene.instantiate()
		indicators.add_child(indicator)
		
		indicator.set_clickable_radius(0.75)
		indicator.color = Color(0.2, 0.2, 0.2)
		indicator.clicked.connect(func():
			if !is_selected: return
			_select_indicator(indicator)
		)

func _update_indicators() -> void:
	var spacing := state.speed * state.TURNING_RADIUS_FACTOR
	var z_distance := -state.speed
	
	var i = 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			var indicator = indicators.get_child(i)
			indicator.position = Vector3(x * spacing, y * spacing, z_distance)
			#indicator.color = Color.RED if i == 5 else Color.BLACK
			i += 1

func _select_indicator(indicator: Icon):
	selected_indicator = indicator
	_update_curve()

func set_selected(selected: bool) -> void:
	is_selected = selected
	
	#end_vector.get_node("Icon").set_hidden(!selected)
	for icon: Icon in indicators.get_children():
		icon.set_hidden(!selected)
