class_name Util extends Node

static func lerpdt(from: float, to: float, weight: float, delta: float) -> float:
	return lerpf(from, to, 1 - pow(weight, delta))
