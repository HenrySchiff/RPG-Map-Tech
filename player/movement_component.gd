class_name MovementComponent extends Node3D


const ACCELERATION: float = 3.0
const MAX_SPEED: float = 12.0

const TURNING_RADIUS_FACTOR: float = 1.0

signal velocity_changed
signal exit_angle_factor_changed

@export var speed: float = 10.0:
	set(value):
		speed = value
		velocity = direction * speed
	
@export var direction: Vector3 = Vector3.FORWARD:
	set(value):
		direction = value.normalized()
		velocity = direction * speed

var velocity: Vector3 = direction * speed:
	set(value):
		velocity = value
		velocity_changed.emit()

var exit_angle_factor: float = 1.0:
	set(value):
		exit_angle_factor = value
		exit_angle_factor_changed.emit()
