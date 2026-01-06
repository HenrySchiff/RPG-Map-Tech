extends Node3D

#@onready var player_icon = $PlayerIcon
@onready var player_icon = $CameraContainer/PlayerIcon
@onready var enemy_icon = $EnemyIcon
@onready var enemy_icon_2 = $EnemyIcon2
@onready var line_node = $LineNode
@onready var line = $LineNode/Line
@onready var line_node2 = $LineNode2
@onready var line2 = $LineNode2/Line


func _process(_delta):
	$FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	
	var box: MeshInstance3D = $Buildings/Box2
	box.get_surface_override_material(0).set_shader_parameter("position", %GraphCube.global_position)
	
	var distance: float = player_icon.global_position.distance_to(enemy_icon.position)
	var midpoint: Vector3 = (player_icon.global_position + enemy_icon.position) / 2
	line_node.position = midpoint
	line.mesh.height = distance
	line_node.look_at(enemy_icon.position)
	
	var distance2: float = player_icon.global_position.distance_to(enemy_icon_2.position)
	var midpoint2: Vector3 = (player_icon.global_position + enemy_icon_2.position) / 2
	line_node2.position = midpoint2
	line2.mesh.height = distance2
	line_node2.look_at(enemy_icon_2.position)
