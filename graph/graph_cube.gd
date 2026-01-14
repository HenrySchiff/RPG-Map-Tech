@tool extends Node3D

@export var edge_length: float = 10.0:
	set(value):
		edge_length = value
		call_deferred("_apply_edge_length")
	
@export var cell_length: float = 1.0:
	set(value):
		cell_length = value
		for plane in get_children():
			plane.mesh.get_material().set_shader_parameter("cell_length", value)

@export var line_color: Color = Color.BLACK:
	set(value):
		line_color = value
		for plane in get_children():
			plane.mesh.get_material().set_shader_parameter("line_color", value)

@export var face_color: Color = Color.WHITE:
	set(value):
		face_color = value
		for plane in get_children():
			plane.mesh.get_material().set_shader_parameter("face_color", value)
			
@export var edge_color: Color = Color.BLACK:
	set(value):
		edge_color = value
		for plane in get_children():
			plane.mesh.get_material().set_shader_parameter("edge_color", value)

@export_range(0.05, 0.5, 0.05) var line_thickness: float = 0.05:
	set(value):
		line_thickness = value
		for plane in get_children():
			plane.mesh.get_material().set_shader_parameter("line_thickness", value)

@export_range(0.05, 0.5, 0.05) var edge_thickness: float = 0.1:
	set(value):
		edge_thickness = value
		for plane in get_children():
			plane.mesh.get_material().set_shader_parameter("edge_thickness", value)

@export var hide_faces: bool = false:
	set(value):
		hide_faces = value
		call_deferred("_apply_hide_faces")

func _init():
	_apply_edge_length()

func _ready():
	# make each mesh and its shader material unique so they can receive different params
	for plane in get_children():
		var mesh: PlaneMesh = plane.mesh
		plane.mesh = mesh.duplicate_deep()
	
	edge_length = edge_length
	cell_length = cell_length
	line_color = line_color
	face_color = face_color
	edge_color = edge_color
	line_thickness = line_thickness

func _process(_delta):
	var offset_xz = Vector2(global_position.x, global_position.z) / edge_length
	_set_offset($PlanePosXZ, offset_xz * Vector2(1.0, -1.0))
	_set_offset($PlaneNegXZ, -offset_xz)
	
	var offset_xy = Vector2(global_position.x, global_position.y) / edge_length
	_set_offset($PlanePosXY, -offset_xy)
	_set_offset($PlaneNegXY, offset_xy * Vector2(-1.0, 1.0))
	
	var offset_zy = Vector2(global_position.y, global_position.z) / edge_length
	_set_offset($PlanePosZY, -offset_zy)
	_set_offset($PlaneNegZY, offset_zy * Vector2(1.0, -1.0))

func _set_offset(plane: MeshInstance3D, offset: Vector2) -> void:
	#pass
	plane.mesh.get_material().set_shader_parameter("position_offset", offset)

func _apply_hide_faces():
	# toggle visibility for all but bottom face (negative XZ)
	for plane in [$PlanePosXY, $PlaneNegXY, $PlanePosZY, $PlaneNegZY, $PlanePosXZ]:
		plane.visible = !hide_faces

func _apply_edge_length():
	for plane in get_children():
		plane.mesh.size = Vector2(edge_length, edge_length)
		plane.position = plane.position.normalized() * (edge_length / 2.0)
		plane.mesh.get_material().set_shader_parameter("edge_length", edge_length)
