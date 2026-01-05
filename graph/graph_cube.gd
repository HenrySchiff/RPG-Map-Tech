@tool extends Node3D

@export var line_color: Color = Color.BLACK:
	set(value):
		line_color = value
		for plane in get_children():
			plane.get_surface_override_material(0).set_shader_parameter("line_color", value)

@export_range(0.001, 0.1, 0.001) var line_thickness: float = 0.01:
	set(value):
		line_thickness = value
		for plane in get_children():
			plane.get_surface_override_material(0).set_shader_parameter("line_thickness", value)

func _ready():
	for plane in get_children():
		var material: ShaderMaterial = plane.get_surface_override_material(0)
		plane.set_surface_override_material(0, material.duplicate())

func _process(_delta):
	var offset_xz = Vector2(global_position.x, global_position.z) / 10.0
	set_offset($PlanePosXZ, offset_xz * Vector2(1.0, -1.0))
	set_offset($PlaneNegXZ, -offset_xz)
	
	var offset_xy = Vector2(global_position.x, global_position.y) / 10.0
	set_offset($PlanePosXY, -offset_xy)
	set_offset($PlaneNegXY, offset_xy * Vector2(-1.0, 1.0))
	
	var offset_zy = Vector2(global_position.y, global_position.z) / 10.0
	set_offset($PlanePosZY, -offset_zy)
	set_offset($PlaneNegZY, offset_zy * Vector2(1.0, -1.0))

func set_offset(plane: MeshInstance3D, offset: Vector2) -> void:
	plane.get_surface_override_material(0).set_shader_parameter("pos_offset", offset)
