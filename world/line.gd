class_name Line extends Node3D

@export var animated: bool = false:
	set(value):
		animated = value
		if !is_inside_tree(): return
		line_mesh.mesh.get_material().set_shader_parameter("animated", value);

@export var dashed: bool = true:
	set(value):
		dashed = value
		if !is_inside_tree(): return
		line_mesh.mesh.get_material().set_shader_parameter("dashed", value);

@export var thickness: float = 0.05:
	set(value):
		thickness = value
		if !is_inside_tree(): return
		line_mesh.mesh.top_radius = thickness * 0.5
		line_mesh.mesh.bottom_radius = thickness * 0.5

@export var color: Color = Color.BLACK:
	set(value):
		color = value
		if !is_inside_tree(): return
		line_mesh.mesh.material.set_shader_parameter("line_color", value)

@onready var line_mesh: MeshInstance3D = $LineMesh

func _ready():
	#NOTE: make unqiue not working for some reason
	line_mesh.mesh = line_mesh.mesh.duplicate_deep()
	
	animated = animated
	dashed = dashed
	thickness = thickness
	color = color

func set_end_position(pos: Vector3) -> void:
	#if pos == global_position: return
	var distance: float = get_parent().global_position.distance_to(pos)
	var midpoint: Vector3 = (get_parent().global_position + pos) / 2
	global_position = midpoint
	look_at(pos, Vector3(0.001, 1, 0)) #FIXME
	line_mesh.mesh.height = distance
	line_mesh.mesh.get_material().set_shader_parameter("line_length", distance);
