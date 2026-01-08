@tool class_name Player extends Node3D

@onready var collision_shape_3d = $Area3D/CollisionShape3D
@onready var graph_cube = $GraphCube

@export_range(5.0, 50.0) var view_range: float = 5.0:
	set(value):
		view_range = value
		call_deferred("_apply_view_range")

func _apply_view_range():
	collision_shape_3d.shape.size = Vector3.ONE * view_range * 2.0
	graph_cube.edge_length = view_range * 2.0
