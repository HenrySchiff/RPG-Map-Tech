class_name Player extends Entity

@onready var collision_shape_3d = $Area3D/CollisionShape3D
@onready var graph_cube = $GraphCube
#@onready var movement_component: MovementComponent = $MovementComponent
#@onready var icon: Icon = $Icon

const POSITION_STEP: float = 1.0
var position_target: Vector3 = Vector3.ZERO

@export_range(5.0, 50.0) var view_range: float = 5.0:
	set(value):
		view_range = value
		call_deferred("_apply_view_range")

var target_view_range = view_range

func _apply_view_range():
	collision_shape_3d.shape.size = Vector3.ONE * view_range * 2.0
	graph_cube.edge_length = view_range * 2.0

func _process(delta):
	$HeightCaster.raycast()
	#$DirectionVector.basis = movement_component.direction
	#$DirectionVector.look_at(movement_component.velocity + global_position, Vector3(0.001, 1, 0))
	
	if !is_equal_approx(view_range, target_view_range):
		view_range = Util.lerpdt(view_range, target_view_range, 0.0001, delta)
