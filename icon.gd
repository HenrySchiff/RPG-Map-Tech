extends Node3D

@onready var line_node = $LineNode
@onready var line = $LineNode/Line

func set_target_pos(target_pos: Vector3) -> void:
	var distance2: float = global_position.distance_to(target_pos)
	var midpoint2: Vector3 = (global_position + target_pos) / 2
	line_node.global_position = midpoint2
	line.mesh.height = distance2
	line_node.look_at(target_pos)
