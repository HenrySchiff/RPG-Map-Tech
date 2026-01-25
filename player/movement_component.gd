class_name MovementComponent extends Node3D


const ACCELERATION: float = 30.0
const MAX_SPEED: float = 120.0
const TURNING_RADIUS: float  = 1.0

signal velocity_changed

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
