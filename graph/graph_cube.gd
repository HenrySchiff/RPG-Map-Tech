@tool extends Node3D

@onready var inside_faces: Array[Node] = $InsideFaces.get_children()
@onready var outside_faces: Array[Node] = $OutsideFaces.get_children()
@onready var all_faces: Array[Node] = inside_faces + outside_faces

@export var edge_length: float = 10.0:
	set(value):
		edge_length = value
		call_deferred("_apply_edge_length")
	
@export var cell_length: float = 1.0:
	set(value):
		cell_length = value
		if !is_inside_tree(): return
		for plane in inside_faces:
			plane.mesh.get_material().set_shader_parameter("cell_length", value)

@export var line_color: Color = Color.BLACK:
	set(value):
		line_color = value
		if !is_inside_tree(): return
		for plane in inside_faces:
			plane.mesh.get_material().set_shader_parameter("line_color", value)
		
@export var face_color: Color = Color.WHITE:
	set(value):
		face_color = value
		if !is_inside_tree(): return
		for plane in inside_faces:
			plane.mesh.get_material().set_shader_parameter("face_color", value)
			
@export var edge_color: Color = Color.BLACK:
	set(value):
		edge_color = value
		if !is_inside_tree(): return
		for plane in all_faces:
			plane.mesh.get_material().set_shader_parameter("edge_color", value)

@export_range(0.01, 0.2, 0.01) var line_thickness: float = 0.03:
	set(value):
		line_thickness = value
		if !is_inside_tree(): return
		for plane in inside_faces:
			plane.mesh.get_material().set_shader_parameter("line_thickness", value)

@export_range(0.01, 0.5, 0.01) var edge_thickness: float = 0.03:
	set(value):
		edge_thickness = value
		if !is_inside_tree(): return
		for plane in all_faces:
			plane.mesh.get_material().set_shader_parameter("edge_thickness", value)

@export_range(-1.0, 1.0, 0.01) var smooth_factor: float = 1.0:
	set(value):
		smooth_factor = value
		if !is_inside_tree(): return
		for plane in all_faces:
			plane.mesh.get_material().set_shader_parameter("smooth_factor", value)

@export var hide_faces: bool = false:
	set(value):
		hide_faces = value
		call_deferred("_apply_hide_faces")

@export var hide_outside_faces: bool = false:
	set(value):
		hide_outside_faces = value
		if !is_inside_tree(): return
		$OutsideFaces.visible = !hide_outside_faces
		

func _ready():
	# make each mesh and its shader material unique so they can receive different params
	for plane in all_faces:
		var mesh: PlaneMesh = plane.mesh
		plane.mesh = mesh.duplicate_deep()
	
	for plane in inside_faces:
		plane.mesh.material.render_priority = -1
	
	edge_length = edge_length
	cell_length = cell_length
	line_color = line_color
	face_color = face_color
	edge_color = edge_color
	line_thickness = line_thickness
	edge_thickness = edge_thickness

func _process(_delta):
	var offset_xz = Vector2(global_position.x, global_position.z) / edge_length
	_set_offset($InsideFaces/PlanePosXZ, offset_xz * Vector2(1.0, -1.0))
	_set_offset($InsideFaces/PlaneNegXZ, -offset_xz)
	
	var offset_xy = Vector2(global_position.x, global_position.y) / edge_length
	_set_offset($InsideFaces/PlanePosXY, -offset_xy)
	_set_offset($InsideFaces/PlaneNegXY, offset_xy * Vector2(-1.0, 1.0))
	
	var offset_zy = Vector2(global_position.y, global_position.z) / edge_length
	_set_offset($InsideFaces/PlanePosZY, -offset_zy)
	_set_offset($InsideFaces/PlaneNegZY, offset_zy * Vector2(1.0, -1.0))

func _set_offset(plane: MeshInstance3D, offset: Vector2) -> void:
	plane.mesh.get_material().set_shader_parameter("position_offset", offset)

func _apply_hide_faces():
	# toggle visibility for all but bottom face (negative XZ)
	for plane in inside_faces:
		if plane == $InsideFaces/PlaneNegXZ: continue
		plane.visible = !hide_faces

func _apply_edge_length():
	for plane in all_faces:
		plane.mesh.size = Vector2(edge_length, edge_length)
		plane.position = plane.position.normalized() * (edge_length / 2.0)
		plane.mesh.get_material().set_shader_parameter("edge_length", edge_length)
