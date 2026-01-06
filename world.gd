extends Node3D

@export var enable_clipping: bool = true

@onready var player_icon = %PlayerIcon
@onready var enemy_icon = $EnemyIcon
@onready var enemy_icon_2 = $EnemyIcon2
@onready var line_node = $LineNode
@onready var line = $LineNode/Line
@onready var line_node2 = $LineNode2
@onready var line2 = $LineNode2/Line
@onready var meshes = $Meshes

var clipping_shader: ShaderMaterial = preload("res://clip.tres").duplicate()

func _ready():
	clipping_shader.set_shader_parameter("enable_clipping", enable_clipping)
	
	for node in meshes.find_children("*"):
		if node is MeshInstance3D:
			node.set_surface_override_material(0, clipping_shader)
		if node is CSGBox3D:
			node.set_material(clipping_shader)

func _process(_delta):
	$FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	
	clipping_shader.set_shader_parameter("position", %GraphCube.global_position)
	
	$Icon.set_target_pos(player_icon.global_position)
	#var distance: float = player_icon.global_position.distance_to(enemy_icon.position)
	#var midpoint: Vector3 = (player_icon.global_position + enemy_icon.position) / 2
	#line_node.position = midpoint
	#line.mesh.height = distance
	#line_node.look_at(enemy_icon.position)
	#
	#var distance2: float = player_icon.global_position.distance_to(enemy_icon_2.position)
	#var midpoint2: Vector3 = (player_icon.global_position + enemy_icon_2.position) / 2
	#line_node2.position = midpoint2
	#line2.mesh.height = distance2
	#line_node2.look_at(enemy_icon_2.position)
