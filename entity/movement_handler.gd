class_name MovementHandler extends Node3D

var movement_path_scene: PackedScene = preload("res://entity/movement_path.tscn")

const MAX_PATHS: int = 3

@export var entity: Entity

var root_path: MovementPath = null
var leaf_path: MovementPath = null

var selected_path: MovementPath = null

func _ready():
	_build_root_path()

func _input(_event):
	if Input.is_action_just_pressed("space"):
		var new_path: MovementPath = movement_path_scene.instantiate()
		new_path.entity = selected_path.entity
		new_path.state = selected_path.next_state
		
		selected_path.end_vector.add_child(new_path)
		_select_path(new_path)
		_connect_click_handler(new_path)
		
		leaf_path = new_path

func _build_root_path():
	if !entity: return
	
	root_path = movement_path_scene.instantiate()
	root_path.entity = entity
	root_path.state = entity.get_node("MovementState")
	leaf_path = root_path
	
	add_child(root_path)
	_select_path(root_path)
	_connect_click_handler(root_path)

func _select_path(path: MovementPath) -> void:
	if selected_path: selected_path.set_selected(false)
	selected_path = path
	selected_path.set_selected(true)

func _connect_click_handler(path: MovementPath) -> void:
	path.start_vector.get_node("Icon").clicked.connect(_select_path.bind(path))

func set_entity(_entity: Entity) -> void:
	entity = _entity
	reset_paths()

func move_entity() -> void:
	entity.global_position = leaf_path.end_vector.global_position
	entity.movement_state.direction = leaf_path.end_vector.global_basis
	reset_paths()

func reset_paths() -> void:
	if root_path: root_path.queue_free()
	_build_root_path()
