class_name Util extends Node

static func lerpdt(from: float, to: float, weight: float, delta: float) -> float:
	return lerpf(from, to, 1 - pow(weight, delta))

static func get_ratio_at_point(curve: Curve3D, point_idx: int) -> float:
	var point_pos: Vector3 = curve.get_point_position(point_idx)
	var closest_offset: float = curve.get_closest_offset(point_pos)
	var total_length: float = curve.get_baked_length()
	
	return closest_offset / total_length

static func generate_circle(radius: float, subdivisions: int) -> PackedVector2Array:
	var points: Array[Vector2] = []
	var angle: float = 0
	for i in range(subdivisions):
		points.append(Vector2(cos(angle), sin(angle)) * radius)
		angle += (2 * PI) / subdivisions
	
	return PackedVector2Array(points)
